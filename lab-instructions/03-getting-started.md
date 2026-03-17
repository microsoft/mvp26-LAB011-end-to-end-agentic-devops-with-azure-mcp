# Getting Started — Set Up the Starter App

> 💡 **Note:** All shell commands in this step are prefaced with `!` so they run directly in your Copilot CLI session. If you're running commands in a separate terminal instead, omit the `!` prefix.

## 1. Clone the Lab Repository

If you haven't already, clone the lab repo and navigate into it:

```bash
!git clone https://github.com/microsoft/mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp.git
!cd mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp
```

## 2. Copy the Starter App

The `starter-app/` directory contains a ready-to-go Node.js API. Copy it to a new `devops-dashboard` working directory and initialize it as its own Git repo:

```powershell
!Copy-Item -Recurse starter-app devops-dashboard
!cd devops-dashboard
!git init && git add -A && git commit -m "init"
```

All subsequent commands should be run from the `devops-dashboard` directory.

> 💡 **What's in the starter app?** `server.js` is a lightweight Node.js HTTP API with `/health`, `/api/status`, and `/api/deployments` endpoints. `package.json` defines the project metadata and start script. `package-lock.json` is pre-generated.

## 3. AZD Notes and Gotchas

### Environment Naming

When using AI-assisted setup, AZD environment names **must not include hyphens**.

✅ Valid:

```text
mcplab1234
```

❌ Invalid:

```text
mcp-lab-1234
```

Azure Container Registry names must be alphanumeric. Using hyphens can cause deployment failures.

***

### Subscription Alignment

AZD maintains its own subscription configuration, separate from the Azure CLI.

After running `azd init`, ensure the subscription matches your current Azure CLI context:

```bash
!azd env set AZURE_SUBSCRIPTION_ID $(az account show --query id -o tsv)
```

> 🔄 **When to re-run this:** If you restart your terminal session, switch Azure subscriptions, or run `azd init` again, you must re-run this command to keep AZD aligned with your CLI context.

***

## 4. Checkpoint: Verify Setup

```bash
!git log --oneline
```

You should see the initial commit.

Start the server:

```bash
!node server.js
```

Open a browser and navigate to `http://localhost:3000` — you should see JSON output listing the service name and available endpoints. Press **Ctrl + C** to stop the running server.

✅ You now have a working starter app ready to be integrated into AZD and Copilot CLI–driven workflows.

***

**Next:** [Scenario 1 — Ship It & Harden It →](04-scenario-1-ship-and-harden.md)
