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

Azure skills give Copilot CLI specialized knowledge for Azure workflows — deployment, diagnostics, RBAC, observability, and more. This lab uses 7 Azure skills.

## Install the Azure Skills Plugin

1. Add the Microsoft marketplace:
   ```
   /plugin marketplace add microsoft/azure-skills
   ```

2. Install the Azure plugin:
   ```
   /plugin install azure@azure-skills
   ```

3. Reload azure mcp:
   ```
   /mcp reload
   ```

4. To update later:
   ```
   /plugin update azure@azure-skills
   ```

> 💡 **MCP tools vs. Azure skills:** The Azure MCP server provides **MCP tools** — low-level operations like listing resources, querying logs, and managing deployments. Azure **skills** are higher-level prompt instructions that chain these tools together with domain knowledge (e.g., `azure-diagnostics` knows how to follow a triage reasoning chain). This lab uses both: skills drive the workflow, MCP tools execute the Azure operations.

---

**Next:** [Login & Launch →](02-login-and-launch.md)
