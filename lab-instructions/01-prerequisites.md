# Prerequisites

**Pre-installed on the VM for your convenience:**
- Azure subscription with Contributor access
- GitHub Copilot CLI (see setup below)
- [Node.js 22+](https://nodejs.org/) · [Docker Desktop](https://www.docker.com/products/docker-desktop/) (must be running) · [Git](https://git-scm.com/)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) with Bicep (`az bicep install`)
- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- Azure MCP Server

**Configuration needed**
- Azure Skills Plugin
- Git user identity (see below)

## Configure Your Environment

### Pin Terminal to the Taskbar

Right-click **Windows Terminal** in the Start menu and select **Pin to taskbar** for easy access throughout the lab.

> 💡 **PowerShell 7** is recommended and pre-installed on the VM. If prompted to use PowerShell 7 instead of Windows PowerShell 5.1, select **Yes**.

### Configure Git Identity

Git requires a user identity for commits. Run the following in your terminal:

```bash
git config --global user.email "labuser@youremail.com"
git config --global user.name "Lab User"
```

> ⚠️ **WSL update prompts:** VS Code may prompt you to update WSL when you first open it. You can safely dismiss these prompts or select **Update** — either way, it won't affect the lab. If the prompt is persistent, click **Don't Show Again**.

## Install the Azure Skills Plugin

Azure skills give Copilot CLI specialized knowledge for Azure workflows — deployment, diagnostics, RBAC, observability, and more. This lab uses 7 Azure skills.

1. Add the Microsoft marketplace:
   ```
   /plugin marketplace add microsoft/github-copilot-for-azure
   ```

2. Install the Azure plugin:
   ```
   /plugin install azure@github-copilot-for-azure
   ```

3. To update later:
   ```
   /plugin update azure@github-copilot-for-azure
   ```

> 💡 **MCP tools vs. Azure skills:** The Azure MCP server provides **MCP tools** — low-level operations like listing resources, querying logs, and managing deployments. Azure **skills** are higher-level prompt instructions that chain these tools together with domain knowledge (e.g., `azure-diagnostics` knows how to follow a triage reasoning chain). This lab uses both: skills drive the workflow, MCP tools execute the Azure operations.

---

**Next:** [Login & Launch →](02-login-and-launch.md)
