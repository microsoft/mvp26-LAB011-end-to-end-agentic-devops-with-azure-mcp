# Scenario 1 — Ship It & Harden It (~8 min)

AI can scaffold your Azure deployment in minutes. But would you push AI-generated Bicep to production without reviewing it?

## Part A — Ship It (~5 min)

**Say to Copilot:**

> "I have a Node.js API in this folder. Deploy it to Azure Container Apps."

This single prompt triggers a **three-skill chain** — watch Copilot invoke each one:

### 1️⃣ `azure-prepare` activates first

Watch how it:
- Scans your workspace — finds `package.json`, classifies it as a Node.js HTTP API
- Chooses Container Apps as the hosting target (do you agree with that choice over App Service or Functions?)
- Generates four files: `Dockerfile`, `azure.yaml`, `infra/main.bicep`, `infra/app/api.bicep`
- Creates an AZD environment and sets your subscription + region

> 💡 **Skill spotlight:** `azure-prepare` doesn't just generate files — it reads skill references for your language runtime, Bicep patterns, and AZD conventions. Open the generated `Dockerfile` and `infra/app/api.bicep` — these came from skill reference templates, not generic boilerplate.

### 2️⃣ `azure-validate` activates next

It runs pre-flight checks:
- Compiles Bicep (`az bicep build`) — catches syntax errors before deployment
- Verifies Docker is running — deployment will fail without it
- Confirms your subscription access and that the resource group name isn't taken

### 3️⃣ `azure-deploy` activates last

It runs `azd up --no-prompt`, which:
- Provisions ACR, Container Apps Environment, Log Analytics, and the app
- Builds your Docker image and pushes it to ACR
- Deploys the container and returns a live HTTPS endpoint

### Verify it works

```bash
curl <your-endpoint-url>
```

> 💡 **Finding your endpoint URL:** If the URL scrolled off screen, run `azd env get-values | grep SERVICE_API` or ask Copilot: "What's the URL for my Container App?" The URL looks like `https://<app-name>.<region>.azurecontainerapps.io`.

> 💡 **First request may be slow:** The first request after deploy can take 10-15 seconds while the new revision activates. This is normal — retry after a moment.

**End state:** A live HTTPS endpoint returning JSON. Three skills, one prompt. But it's deployed, not production-ready.

✅ **Checkpoint:** `curl <your-endpoint-url>/health` returns `{"status":"healthy",...}`. Note your app name and resource group — you'll need them in Scenario 3. Run: `azd env get-values` and note `AZURE_RESOURCE_GROUP` and your Container App name.

---

## Part B — Harden It (~3 min)

Open `infra/app/api.bicep`. What's missing for production?

| Gap | Why It Matters | Severity |
|---|---|---|
| **No managed identity for ACR pull** | Container App uses admin credentials to pull images. Security finding. | High |
| **No VNet integration** | Container Apps Environment is on a public network. No isolation. | Medium |
| **No diagnostic settings** | Platform metrics aren't forwarded. You'd miss CPU/memory alerts. | Medium |
| **No health probe configured** | Defaults to TCP probes. Your app has `/health` — it should use it. | Low |

**Say to Copilot:**

> "My Container App is pulling images from ACR using admin credentials. Switch it to use managed identity with AcrPull role."

### 4️⃣ `azure-rbac` activates

Watch how it:
- Searches Azure RBAC documentation for the minimum-privilege role matching "pull images from ACR"
- Identifies `AcrPull` (not `Contributor`, not `AcrPush` — least privilege)
- Generates the exact `az role assignment create` command with your resource names
- Explains the identity chain: Container App → System-Assigned Managed Identity → AcrPull role → ACR

> 💡 **300-level insight:** The AI chose `AcrPull` over `Contributor`. If it had chosen `Contributor`, would you have caught it? That's the gap between "AI-generated" and "production-reviewed."

> ℹ️ **Note:** The role assignment is created, but the Container App configuration would need a re-deploy to switch from admin credentials to managed identity pull. For this lab, understanding the pattern is the goal — you don't need to re-deploy.

**Other production gaps worth discussing:** Key Vault for secrets management (not just environment variables), VNet integration for network isolation (adds ~3 min provisioning time), and error handling in the app code (`SIGTERM` graceful shutdown, proper HTTP status codes). These are out of scope for 30 minutes but essential in production.

✅ **Checkpoint:** The `az role assignment create` command succeeded. You can verify with: `az role assignment list --scope <acr-id> --query "[?roleDefinitionName=='AcrPull']" -o table`.

**Takeaway:** The AI built a working deployment across 3 skills. You identified what "working" doesn't mean "production-ready," and used a 4th skill to start hardening.

---

**Next:** [Scenario 2 — See It & Evaluate It →](05-scenario-2-see-and-evaluate.md)
