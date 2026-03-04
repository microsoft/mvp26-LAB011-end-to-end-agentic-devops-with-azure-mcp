# Ship, Harden, Break, Investigate — Azure DevOps with AI as Your Co-Pilot

**Hands-On Lab (30 min) | Level: 300**

AI can deploy your app to Azure in 5 minutes. But should you trust what it built? In this lab, you'll use GitHub Copilot CLI with Azure MCP skills to deploy a live Container App — then put on your architect hat and evaluate the AI's decisions. You'll review generated Bicep, identify what's missing for production, direct the AI to harden the deployment, break the app on purpose, and run a full forensic investigation — all without opening the Azure Portal.

---

## What You'll Learn

- Where AI-generated infrastructure gets you to 80% — and the production gaps you need to close
- How to critically review AI-generated Bicep, Dockerfiles, and architecture diagrams
- How Azure MCP skills reason through diagnostics: triage patterns, log correlation, root-cause analysis
- How to direct AI to write KQL queries and create alert rules from natural language
- When to trust the AI's decisions and when to override them

## Skills Used

| Skill | What It Does | Scenario |
|---|---|---|
| `azure-prepare` | Detects your stack, generates IaC + Docker + config | Ship & Harden |
| `azure-validate` | Catches misconfigurations before deployment | Ship & Harden |
| `azure-deploy` | Provisions infrastructure + builds + deploys | Ship & Harden |
| `azure-rbac` | Identifies least-privilege roles, generates assignment commands | Ship & Harden |
| `azure-resource-visualizer` | Generates a Mermaid architecture diagram from live resources | See & Evaluate |
| `azure-diagnostics` | Pulls system logs, correlates events, explains root cause | Break & Triage |
| `azure-observability` | Writes and runs KQL queries, surfaces incident timelines | Investigate |

---

## Prerequisites

Run the setup script to install and validate everything:

```powershell
powershell -ExecutionPolicy Bypass -File setup-lab.ps1
```

Or validate an existing setup:

```powershell
powershell -ExecutionPolicy Bypass -File setup-lab.ps1 -ValidateOnly
```

**What you need:**

- Azure subscription with Contributor access
- GitHub Copilot CLI with Azure MCP enabled
- [Node.js 22+](https://nodejs.org/) · [Docker Desktop](https://www.docker.com/products/docker-desktop/) (must be running) · [Git](https://git-scm.com/)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) with Bicep (`az bicep install`)
- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)

**Quick manual check:**
```
node -v && docker version --format "{{.Server.Version}}" && az version -o tsv --query '"azure-cli"' && azd version && az account show --query name -o tsv
```

---

## Getting Started — Create the Starter App

Create a new folder and add these two files:

**server.js**
```javascript
const http = require("http");
const port = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ status: "healthy" }));
  }
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ message: "Hello from MCP Lab!", timestamp: new Date().toISOString() }));
});
server.listen(port, () => console.log(`Server running on port ${port}`));
```

**package.json**
```json
{ "name": "mcp-lab-api", "version": "1.0.0", "scripts": { "start": "node server.js" } }
```

Then initialize the project:
```bash
npm install --package-lock-only
git init && git add -A && git commit -m "init"
```

---

## Scenario 1 — Ship It & Harden It (~8 min)

AI can scaffold your Azure deployment in minutes. But would you push AI-generated Bicep to production without reviewing it?

### Part A — Ship It (~5 min)

**Say to Copilot:**

> "I have a Node.js API in this folder. Deploy it to Azure Container Apps."

**Watch how the AI:**
- 🔍 Detects Node.js from `package.json`, classifies it as an HTTP API
- 📋 Chooses Container Apps over App Service or Functions — do you agree with that choice?
- 🏗️ Generates `Dockerfile`, `azure.yaml`, `infra/main.bicep`, `infra/app/api.bicep`
- ✅ Validates Bicep compilation, Docker availability, subscription access
- 🚀 Deploys with `azd up` — provisions ACR, Container Apps Environment, Log Analytics, and the app

**End state:** A live HTTPS endpoint returning JSON. But it's deployed, not production-ready.

### Part B — Harden It (~3 min)

Open `infra/app/api.bicep`. What's missing for production?

| Gap | Why It Matters | Severity |
|---|---|---|
| **No managed identity for ACR pull** | Container App uses admin credentials to pull images. Security finding. | High |
| **No VNet integration** | Container Apps Environment is on a public network. No isolation. | Medium |
| **No diagnostic settings** | Platform metrics aren't forwarded. You'd miss CPU/memory alerts. | Medium |
| **No health probe configured** | Defaults to TCP probes. Your app has `/health` — it should use it. | Low |

**Say to Copilot:**

> "My Container App is pulling images from ACR using admin credentials. Switch it to use managed identity with AcrPull role."

The AI invokes `azure-rbac` to identify the correct role, generates the `az role assignment create` command, and explains the identity chain: Container App → Managed Identity → AcrPull → ACR.

**Takeaway:** The AI built a working deployment. You identified what "working" doesn't mean "production-ready."

---

## Scenario 2 — See It & Evaluate It (~5 min)

Architecture diagrams are either stale, wrong, or don't exist. AI can generate them instantly — but are they accurate?

### Part A — Generate the Diagram (~2 min)

**Say to Copilot:**

> "Visualize the resources in my resource group as an architecture diagram."

The AI inventories every resource, maps relationships (Container App → Environment → Log Analytics, App → ACR), and generates a Mermaid diagram with labeled subgraphs.

### Part B — Evaluate the Diagram (~3 min)

Open the generated markdown and review critically:

- Did it capture all 4 resources?
- Are the relationships correct?
- Does it show the ACR pull relationship?
- Would this pass a production architecture review?

**Say to Copilot:**

> "What's missing from this architecture for a production deployment?"

Compare the AI's recommendations against your own findings from Scenario 1.

**Takeaway:** AI-generated diagrams are excellent for discovery (what exists?) but require expert review for documentation (is this complete and accurate?).

---

## Scenario 3 — Break It & Triage It (~5 min)

It's 2 AM. Your app returns 503. You open a terminal. Pay attention to the AI's diagnostic reasoning chain, not just the answer.

### Introduce the Failure

```bash
az containerapp ingress update --name <app> -g <rg> --target-port 9999
```

Hit the endpoint — you'll get `503 Service Unavailable`.

### Diagnose with AI

**Say to Copilot:**

> "My Container App is returning 503. What's wrong?"

**Watch the triage chain:**

1. **Hypothesis formation** — considers: app crashed? Ingress misconfigured? Bad image? Unhealthy environment?
2. **Log correlation** — finds `Reason: Pending:PortMismatch` — *"TargetPort 9999 does not match listening port 3000"*
3. **Config verification** — confirms ingress is set to 9999, app env says 3000
4. **Root cause + fix** — gives you the exact CLI command to fix it

### Apply the Fix

Run the suggested fix command. Verify recovery → `200 OK`.

**Takeaway:** From "my app is broken" to root cause + fix in one question, ~30 seconds.

---

## Scenario 4 — Investigate It & Operationalize It (~10 min)

The incident is resolved. Now: "How long was it down? How do we prevent it next time?"

### Part A — Post-Mortem via KQL (~5 min)

**Say to Copilot:**

> "Query the Log Analytics workspace for my Container App. Show me what happened during the port mismatch incident."

**The AI will:**

1. Discover available log tables
2. Run event distribution — showing PortMismatch events, ReplicaUnhealthy impact, RevisionUpdate recovery
3. Build an incident timeline with exact start/end timestamps and duration
4. Confirm recovery via `RevisionReady` events

Review the KQL the AI wrote. Would you have written it differently?

### Part B — Operationalize It (~5 min)

**Say to Copilot:**

> "Create a KQL alert rule that fires when PortMismatch events appear in the Container App system logs."

The AI writes the alert query and generates the `az monitor scheduled-query create` command with threshold, frequency, and severity.

**Then ask:**

> "What other alert rules should I have for a production Container App?"

The AI suggests: replica health, restart loops, high latency, 5xx spikes, memory utilization.

**Takeaway:** The real value is going from "the incident is over" to "this class of incident will page me next time" — in the same conversation.

---

## Timing Summary

| Scenario | Duration | Skills |
|---|---|---|
| 1. Ship & Harden | ~8 min | prepare, validate, deploy, rbac |
| 2. See & Evaluate | ~5 min | resource-visualizer |
| 3. Break & Triage | ~5 min | diagnostics |
| 4. Investigate & Operationalize | ~10 min | observability |
| **Total** | **~28 min** | **7 skills** |

---

## Cleanup

When you're done, tear everything down:

```bash
azd down --no-prompt --purge
```

If that times out:
```bash
az group delete --name rg-<your-env-name> --yes --no-wait
```
