# Before You Begin — Login & Launch

Open a terminal (PowerShell or your preferred shell) and complete these steps:

## 1. Log in to GitHub CLI

```bash
gh auth login
```

Follow the prompts to authenticate. Verify with: `gh auth status` — you should see "Logged in to github.com."

## 2. Log in to Azure

```bash
az login
```

Select your subscription when prompted. Verify with:
```bash
az account show --query "{name:name, id:id}" -o table
```

## 3. Start GitHub Copilot CLI

```bash
copilot
```

This opens the interactive Copilot CLI session. All "Say to Copilot" prompts in this lab are typed here.

## 4. Verify Azure MCP is connected

```
/mcp show
```

You should see `azure-mcp` listed with status `● connected`. If not, go back to the [Prerequisites](01-prerequisites.md) and configure the Azure MCP Server.

✅ **Checkpoint:** You're logged into GitHub and Azure, Copilot CLI is running, and Azure MCP is connected.

---

**Next:** [Create the Starter App →](03-getting-started.md)
