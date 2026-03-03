# MVP Lab Session Abstract

## Title: **Ship, Harden, Break, Investigate — Azure DevOps with AI as Your Co-Pilot**

### Session Type: Hands-On Lab (30 min active + Q&A) | **Level: 300**

---

### Short Abstract (< 500 characters)

Deploy to Azure Container Apps, then critique what the AI built. Review generated Bicep, spot the missing production hardening, and ask Azure MCP skills to fix it. Break the app, triage with AI diagnostics, then write the post-mortem with AI-generated KQL. Seven skills, real architectural decisions, zero portal clicks.

### Abstract

AI can deploy your app to Azure in 5 minutes. But should you trust what it built? In this hands-on lab, you'll use GitHub Copilot CLI with Azure MCP skills to deploy a live Container App — then put on your architect hat and evaluate the AI's decisions. You'll review generated Bicep, identify what's missing for production (no VNet, no managed identity for ACR, no diagnostic settings forwarding), and direct the AI to harden the deployment — making architectural decisions the AI can't make for you.

You'll work through four connected scenarios that build on each other:

1. **Ship it & Harden it** — Deploy from an empty folder, then open the generated Bicep and architecture diagram. Identify production gaps. Direct the AI to add managed identity for ACR pull. Understand where AI gets you to 80% and where your expertise finishes the job.
2. **See it & Evaluate it** — Generate an architecture diagram, then critically assess it. Does the AI correctly map all resource relationships? What's missing? What would you add for a production review?
3. **Break it & Triage it** — Inject a port mismatch failure. But instead of just asking "what's wrong," watch *how* the AI triages — which logs it reads first, what it rules out, how it correlates events. Understand the diagnostic reasoning, not just the answer.
4. **Investigate it & Operationalize it** — Run KQL post-mortem queries through natural language. Then go beyond: ask the AI to create an alert rule so this class of failure triggers a notification next time. Turn incident response into incident prevention.

The narrative arc is intentional: each scenario feeds the next. You're not watching a demo — you're collaborating with AI on real architectural and operational decisions, evaluating its judgment, and filling in the gaps only an experienced Azure practitioner would catch.

### What You'll Learn

- Where AI-generated IaC gets you to 80% — and the production-readiness gaps you need to close (networking, identity, monitoring)
- How to critically review AI-generated Bicep, Dockerfiles, and architecture diagrams — not just accept them
- How Azure MCP skills reason through diagnostics: the triage pattern, log correlation, and root-cause analysis chain
- How to direct AI to write KQL you'd normally spend 20 minutes crafting — then refine the output with domain knowledge
- When to trust the AI's architectural decisions and when to override them — the 300-level judgment call

### Skills Showcased

| Skill | What It Does for You | Scenario |
|---|---|---|
| `azure-prepare` | Detects your stack, picks the right Azure service, generates all IaC + Docker + config | Ship & Harden |
| `azure-validate` | Catches misconfigurations *before* you spend money on a failed deployment | Ship & Harden |
| `azure-deploy` | Provisions infra + builds + deploys in one shot | Ship & Harden |
| `azure-resource-visualizer` | Reads your resource group and generates a Mermaid architecture diagram | See & Evaluate |
| `azure-diagnostics` | Pulls system logs, correlates events, explains the root cause in plain English | Break & Triage |
| `azure-observability` | Writes and runs KQL queries against Log Analytics, surfaces incident timelines | Investigate |
| `azure-rbac` | Identifies least-privilege roles and generates assignment commands + Bicep | Ship & Harden |

### Prerequisites

- Azure subscription with Contributor access (logged in: `az login`)
- GitHub Copilot CLI installed with Azure MCP enabled
- [Node.js 22+](https://nodejs.org/), [Docker Desktop](https://www.docker.com/products/docker-desktop/) (**must be running**), [Git](https://git-scm.com/)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) with Bicep (`az bicep install`)
- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- Azure CLI extension: `az extension add --name scheduled-query --yes`

**Quick check (run before the lab):**
```
node -v && docker version --format "{{.Server.Version}}" && az version -o tsv --query '"azure-cli"' && azd version && az account show --query name -o tsv && az extension show --name scheduled-query --query version -o tsv
```

### Target Audience

Azure developers and IT Ops professionals who already work with Azure daily and want to evaluate AI-assisted tooling critically — not just see a demo, but understand where it excels, where it falls short, and how to integrate it into production workflows.

---

## The Lab — Four Scenarios, One Story

> Each scenario flows into the next. The app you deploy in Scenario 1 is the app you harden, break, and investigate. Your role: **collaborator**, not spectator. The AI proposes; you evaluate and decide.

---

### Scenario 1 — "Ship It & Harden It" (~8 min)

**The pain point:** AI can scaffold your Azure deployment in minutes. But would you push AI-generated Bicep to production without reviewing it? This scenario tests that boundary.

#### Part A — Ship It (~5 min)

**What you'll say to Copilot:**

> "I have a Node.js API in this folder. Deploy it to Azure Container Apps."

**What the AI does (watch the reasoning, not just the output):**
- 🔍 **Detects** Node.js from `package.json`, classifies it as an HTTP API from `server.js`
- 📋 **Chooses** Container Apps over App Service or Functions — *ask yourself: do you agree with that choice? Why not App Service?*
- 🏗️ **Generates** `Dockerfile`, `azure.yaml`, `infra/main.bicep`, `infra/app/api.bicep`
- ✅ **Validates** Bicep compilation, Docker availability, subscription access
- 🚀 **Deploys** with `azd up` — provisions ACR, Container Apps Environment, Log Analytics, and the app

**End state:** Live HTTPS endpoint returning JSON. But don't celebrate yet — it's deployed, not production-ready.

#### Part B — Harden It (~3 min)

**Now put on your architect hat.** Open `infra/app/api.bicep` and the architecture diagram from Scenario 2. Ask yourself:

> ❓ **What's missing for production?**

The AI got you to ~80%. Here's what an experienced Azure practitioner would flag:

| Gap | Why It Matters | Severity |
|---|---|---|
| **No managed identity for ACR pull** | Container App uses admin credentials to pull images from ACR. In production, this is a security finding. | High |
| **No VNet integration** | Container Apps Environment is on a public network. No network isolation. | Medium |
| **No diagnostic settings** | Logs go to Log Analytics but platform metrics aren't forwarded. You'd miss CPU/memory alerts. | Medium |
| **No health probe configured** | Container Apps defaults to TCP probes. Your app has `/health` — it should use it. | Low |

**What you'll say to Copilot:**

> "My Container App is pulling images from ACR using admin credentials. Switch it to use managed identity with AcrPull role."

**What the AI does:**
- Invokes `azure-rbac` to identify the correct role (`AcrPull`)
- Generates the `az role assignment create` command scoped to your ACR
- Explains the identity chain: Container App → System-Assigned Managed Identity → AcrPull role → ACR

**The 300-level takeaway:** The AI built a working deployment. You identified what "working" doesn't mean "production-ready." That judgment call — knowing what to look for — is what separates a deployment demo from architectural review.

**⏱️ Timing:** ~8 min (5 min deploy + 3 min review & harden)

---

### Scenario 2 — "See It & Evaluate It" (~5 min)

**The pain point:** Architecture diagrams are either stale, wrong, or don't exist. AI can generate them instantly — but are they *accurate*?

#### Part A — Generate the Diagram (~2 min)

**What you'll say to Copilot:**

> "Visualize the resources in my resource group as an architecture diagram."

**What the AI does:**
- 📊 **Inventories** every resource: names, types, SKUs, locations
- 🔗 **Maps relationships**: Container App → Environment → Log Analytics, App → ACR
- 🎨 **Generates** a Mermaid `graph TB` diagram with labeled subgraphs

#### Part B — Evaluate the Diagram (~3 min)

**Now review it critically.** Open the generated markdown and ask:

| Question | What You'll Find |
|---|---|
| Did it capture all 4 resources? | ✅ Yes — Container App, Environment, ACR, Log Analytics |
| Are the relationships correct? | ✅ Hosting and log streaming links are right |
| Did it capture the *ACR pull* relationship? | ⚠️ Check — does the diagram show Container App pulling images from ACR? |
| Does it show the managed identity you just added? | ⚠️ Depends on timing — the identity was added at the Azure RM level, not in Bicep. The visualizer reads live state. |
| Would this pass a production architecture review? | ❌ Missing: no network topology (no VNet was deployed), no security annotations, no data flow arrows showing ingress path |

**What you'll say to Copilot:**

> "What's missing from this architecture for a production deployment?"

The AI surfaces recommendations you can compare against your own assessment from Scenario 1.

**The 300-level takeaway:** AI-generated diagrams are excellent for *discovery* (what exists?) but require expert review for *documentation* (is this complete and accurate?). Use them as a starting point, not a deliverable.

**⏱️ Timing:** ~5 min

---

### Scenario 3 — "Break It & Triage It" (~5 min)

**The pain point:** It's 2 AM. Your app returns 503. You open a terminal. In this scenario, pay attention not just to the *answer* but to the AI's *diagnostic reasoning chain*.

**Setup — Introduce the failure:**
```
az containerapp ingress update --name <app> -g <rg> --target-port 9999
```

**Verify it's broken:** Hit the endpoint → `503 Service Unavailable`.

**What you'll say to Copilot:**

> "My Container App is returning 503. What's wrong?"

**What the AI does — the triage chain (watch this sequence):**

1. **Hypothesis formation** — It doesn't jump to conclusions. It considers: is the app crashed? Is ingress misconfigured? Is the image bad? Is the environment unhealthy?
2. **Log correlation** — Pulls `ContainerAppSystemLogs_CL`, finds `Reason: Pending:PortMismatch` with message: *"TargetPort 9999 does not match listening port 3000"*
3. **Config verification** — Checks ingress config to confirm target port is 9999, cross-references with app's `PORT` env var
4. **Root cause + fix** — "Ingress target port was changed to 9999 but the app listens on 3000" + the exact CLI command to fix it

**Apply the fix, verify recovery** → `200 OK`.

**The 300-level discussion:**

> ❓ **What if the failure were more ambiguous?** A port mismatch is clean and diagnosable. What about intermittent 502s caused by memory pressure? Or cold-start timeouts with `minReplicas: 0`? The AI's triage pattern (system logs → config check → correlate) is the same, but compound failures surface the limits of single-turn diagnosis.

**Proctor can optionally demo:** Ask the AI about a *second* hypothetical failure ("what if the image tag was wrong instead?") to show how the diagnostic reasoning adapts.

**⏱️ Timing:** ~5 min (including ~2 min CLI revision activation wait)

---

### Scenario 4 — "Investigate It & Operationalize It" (~10 min)

**The pain point:** The incident is resolved. Your team lead asks: "How long was it down? How do we prevent it from happening again?" This scenario goes beyond post-mortem into operational readiness.

#### Part A — Post-Mortem via KQL (~5 min)

**What you'll say to Copilot:**

> "Query the Log Analytics workspace for my Container App. Show me what happened during the port mismatch incident."

**What the AI does:**

1. **Discovers tables** — `ContainerAppSystemLogs_CL` and `ContainerAppConsoleLogs_CL`

2. **Runs event distribution:**
   ```
   PortMismatch:     50 events  ← the incident signal
   ReplicaUnhealthy: 50 events  ← the downstream impact
   RevisionUpdate:   22 events  ← the remediation
   ContainerStarted:  7 events  ← normal baseline
   ```

3. **Builds incident timeline:**
   ```
   IncidentStart: 18:17:58    IncidentEnd: 18:24:53
   TotalEvents: 50            Duration: ~7 minutes
   ```

4. **Confirms recovery** — `RevisionReady` + `ContainerAppUpdate` events

**Evaluate the KQL:** The AI wrote queries like `ContainerAppSystemLogs_CL | where Reason_s has 'PortMismatch' | summarize count() by bin(TimeGenerated, 5m)`. If you know KQL, ask yourself: would you have written it differently? More efficiently? The AI uses `has` over `==` (handles PowerShell quoting), `bin(TimeGenerated, 5m)` for time bucketing — these are solid patterns.

#### Part B — Operationalize It (~5 min)

**What you'll say to Copilot:**

> "Create a KQL alert rule that fires when PortMismatch events appear in the Container App system logs."

**What the AI does:**
- Writes the KQL query for the alert condition: `ContainerAppSystemLogs_CL | where Reason_s has 'PortMismatch'`
- Generates `az monitor scheduled-query create` command using the named-placeholder pattern:
  ```
  az monitor scheduled-query create -n "PortMismatch-Alert" -g <rg> \
    --scopes <workspace-resource-id> \
    --condition "count 'PortMismatchQuery' > 0" \
    --condition-query PortMismatchQuery="ContainerAppSystemLogs_CL | where Reason_s has 'PortMismatch'" \
    --evaluation-frequency 5m --window-size 5m --severity 2
  ```
- Explains the evaluation window, action group configuration, and cost implications

**Then ask:**

> "What other alert rules should I have for a production Container App?"

The AI suggests: replica health, restart loops, high latency (P95 > 2s), 5xx spike, memory utilization > 80%.

**The 300-level takeaway:** Writing KQL from natural language is useful. But the real value is going from "the incident is over" to "this class of incident will page me next time" — in the same conversation. That's the difference between reactive and proactive operations.

**⏱️ Timing:** ~10 min

---

## Timing Summary

| Scenario | Duration | Skills | Narrative Beat |
|---|---|---|---|
| 1. Ship & Harden | ~8 min | prepare, validate, deploy, rbac | Build — then review what the AI built |
| 2. See & Evaluate | ~5 min | resource-visualizer | Understand — then challenge the AI's understanding |
| 3. Break & Triage | ~5 min | diagnostics | Respond — and learn the AI's diagnostic reasoning |
| 4. Investigate & Operationalize | ~10 min | observability | Prevent — turn post-mortem into proactive alerting |
| **Total** | **~28 min** | **7 skills** | **~2 min buffer** |

---

## Lab Cleanup

```bash
azd down --no-prompt --purge
```
> Fallback if timeout: `az group delete --name rg-<env-name> --yes --no-wait`

---

## Proctor Notes & Known Issues

> The following notes are for lab proctors, not attendees. Discovered during end-to-end testing on 2026-02-25 through 2026-03-03.

### Critical — Must Address Before Lab

| Issue | Root Cause | Mitigation |
|---|---|---|
| **AZD deploys to wrong subscription** | AZD maintains its own subscription config, separate from `az account show` | Lab setup must explicitly run `azd env set AZURE_SUBSCRIPTION_ID <id>` after `azd init`. Proctors should verify. |
| **`az containerapp ingress update` blocks for ~2 min** | CLI waits for Container Apps revision activation | Tell attendees this is expected. Use the wait time to discuss the triage reasoning chain in Scenario 3. |
| **First request after deploy can take >10s** | New revision activating | Have attendees hit `/health` first, or wait ~15s after deploy completes. |
| **Docker Desktop must be running** | `azd up` Docker build fails if Docker Desktop isn't started | Add to pre-flight check: `docker version` must succeed. Include in attendee setup instructions. |
| **`scheduled-query` CLI extension required for Scenario 4B** | `az monitor scheduled-query create` needs preview extension | Pre-install: `az extension add --name scheduled-query --yes` and set `az config set extension.dynamic_install_allow_preview=true`. Add to prerequisites. |

### Dockerfile & Build

| Issue | Fix Already Applied |
|---|---|
| `npm ci` fails without `package-lock.json` | Dockerfile uses `npm install --omit=dev` instead |
| `azd up` aborts entirely if Docker build fails | Fixed by the Dockerfile fix above |
| Cold start with `minReplicas: 0` | Bicep sets `minReplicas: 1` |

### Scenario-Specific Notes

| Scenario | Note |
|---|---|
| Scenario 1B (Harden) | The managed identity + AcrPull step may require the attendee to re-deploy (`azd deploy`) to take effect. For the lab, showing the `az role assignment create` command and explaining the pattern is sufficient — full re-deploy is optional. |
| Scenario 1B (Harden) | The "production gaps" table is opinionated. Encourage attendees to add their own findings. The goal is critical review, not a checklist. |
| Scenario 2B (Evaluate) | The diagram may not immediately reflect the managed identity added in 1B — the visualizer reads live Azure RM state, and role assignments aren't always visible as diagram nodes. This is a good discussion point about diagram limitations. |
| Scenario 3 (Break) | Do NOT use bad image tags to break the app — they poison the revision template. Port mismatch is clean and recoverable. |
| Scenario 3 (Triage) | If time allows, the proctor can demo a second hypothetical failure ("what if the image was bad?") to show how the AI adapts its triage chain. |
| Scenario 4A (KQL) | KQL logs appear within ~5 min. Azure Monitor metrics have ~15 min latency — generate traffic early. If metrics show 0, explain the pipeline delay and focus on KQL. |
| Scenario 4A (KQL) | KQL `where Reason_s == "PortMismatch"` may fail in PowerShell due to quote escaping. Use `has` operator instead: `where Reason_s has 'PortMismatch'`. The AI handles this automatically. |
| Scenario 4B (Alert) | The `az monitor scheduled-query create` requires the `scheduled-query` CLI extension (preview). Must be pre-installed. The `--condition` syntax uses named placeholders: `count 'PlaceholderName' > 0` with `--condition-query PlaceholderName="KQL..."`. This is unintuitive — the AI handles it but proctors should know the pattern. |
| Scenario 4B (Alert) | No action group is required for alert creation — the alert will fire but won't notify anyone until an action group is attached. Discuss this as a "next step." |
| Scenario 4 (General) | Lab 3 PortMismatch events appearing in Scenario 4 is intentional — it's the narrative payoff, not a bug. |

### Level 300 Facilitation Tips

| Moment | What to Do |
|---|---|
| After Scenario 1A deploy completes | **Don't move on yet.** Ask the room: "Would you push this Bicep to production?" Let them identify gaps before showing the table. |
| During Scenario 2B evaluation | Ask: "What would you add to this diagram for a production architecture review?" Expect answers about data flow, security boundaries, DR. |
| During Scenario 3 triage | Narrate the AI's reasoning chain out loud: "Notice it checked system logs first, not console logs. Why?" |
| During Scenario 4B alerting | Ask: "What's your standard alert set for Container Apps?" Compare the AI's suggestions to the room's experience. |

### Additional Scenarios (Not in Recommended Combo)

These validated scenarios can be swapped in for different audience emphasis:

| Scenario | Duration | Skills | Best For |
|---|---|---|---|
| Compliance Guardrails | ~2 min | `azure-rbac` | Governance-focused audiences |
| Cost Optimization | ~5 min | `azure-cost-optimization` | FinOps teams (needs `costmanagement` + `resource-graph` CLI extensions) |

---

*Informed by Azure MCP sync-ups (Feb 10–17, 2026), GHCP4A telemetry check-ins, and the v1.0.0 GA roadmap. All scenarios tested end-to-end on 2026-02-25, 2026-02-27, 2026-03-02, and 2026-03-03 (300-level rewrite) against live Azure resources.*

---

## Test Run Feedback — 300-Level Rewrite (2026-03-03)

> Full clean-slate test of the 300-level instructions against yunjchoi subscription.

### Timing Results

| Scenario | Expected | Actual | Notes |
|---|---|---|---|
| 1A — Ship It | ~5 min | ~4 min | `azd up` fast. Starter app creation adds ~1 min for attendees. |
| 1B — Harden It | ~3 min | ~3 min | Reviewing Bicep + running `az role assignment create` straightforward. |
| 2 — See & Evaluate | ~5 min | ~4 min | Resource inventory fast. Critical evaluation adds engagement. |
| 3 — Break & Triage | ~5 min | ~5 min | ~2 min CLI wait for ingress update, as expected. |
| 4A — Post-Mortem | ~5 min | ~4 min | KQL logs available immediately (break happened ~10 min earlier). |
| 4B — Operationalize | ~5 min | ~8 min | ⚠️ CLI extension issues added 3 min. With pre-install: ~5 min. |
| **Total** | **~28 min** | **~28 min** | On target with prerequisites met. |

### Issues Found & Resolutions

| # | Issue | Severity | Resolution |
|---|---|---|---|
| 1 | **Docker Desktop not running** — `docker build` fails during validation | Blocker | Added to prerequisites: "must be running." Added `docker version` to pre-flight check. |
| 2 | **`scheduled-query` CLI extension not installed** — `az monitor scheduled-query create` hung for 3+ min trying to auto-install, then failed | Blocker | Added `az extension add --name scheduled-query --yes` to prerequisites. Also need `az config set extension.dynamic_install_allow_preview=true`. |
| 3 | **`--condition` syntax for scheduled-query is unintuitive** — requires named placeholder `count 'Name' > 0` + separate `--condition-query Name="KQL..."` | Medium | Updated Scenario 4B instructions with correct syntax. The AI needs to get this right. |
| 4 | **`containerapp` extension warning** — `WARNING: The behavior of this command has been altered by the following extension: containerapp` corrupts output when piped to `-o tsv` | Low | Use `-o json` + parse with `ConvertFrom-Json` instead. Doesn't affect attendee experience. |
| 5 | **AZD version warning noise** — "your version of azd is out of date" on every command | Low | Cosmetic only. Doesn't block anything. |

### 300-Level Assessment

| Criterion | Rating | Notes |
|---|---|---|
| **Attendee makes decisions** | ✅ Strong | Scenario 1B gap identification, 2B diagram evaluation, 4B alert design are all active tasks. |
| **Production-relevant depth** | ✅ Strong | Managed identity, RBAC, alert rules, KQL — all production patterns. |
| **Expert engagement** | ✅ Good | Facilitation tips create room-level discussion. The "would you push this to production?" question is effective. |
| **Narrative cohesion** | ✅ Strong | Ship → Harden → Visualize → Break → Investigate → Operationalize is a logical arc. |
| **Time feasibility** | ⚠️ Tight | 28 min with ~2 min buffer. If any scenario runs long, 4B (alert) can be shown as "what you'd do next" rather than executed live. |
| **Prerequisite complexity** | ⚠️ Medium | 6 tools + 1 CLI extension + Docker running. Pre-flight check helps but expect 2-3 attendees to hit setup issues. |

### Recommendation

The 300-level rewrite is materially better than the original. The shift from "watch the AI" to "collaborate with and evaluate the AI" is the right level for MVP Summit. Two adjustments to consider:

1. **Scenario 4B is the weakest link** — the `scheduled-query` CLI syntax is fragile and the extension prerequisites add friction. Consider making 4B a "demo if time" stretch goal rather than a core scenario. This frees ~5 min of buffer.
2. **Scenario 1B is the strongest addition** — the production gap review is where the 300-level credibility lives. Give it space. If attendees engage, let the discussion run — it's more valuable than completing 4B.
