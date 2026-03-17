# What's Next

Congratulations — you've deployed, hardened, broken, diagnosed, and operationalized an Azure Container App using 7 AI skills in 30 minutes. Here's where to go from here:

## 📋 Cheat Sheet — Quick Reference

Keep these tips handy for your own projects:

| Tip | Command / Setting |
|---|---|
| **Enable yolo mode** (auto-approve commands) | `/config set yolo true` |
| **Switch AI models** | `/config set model <model-name>` |
| **Install Azure skills plugin** | `/plugin marketplace add microsoft/github-copilot-for-azure` then `/plugin install azure@github-copilot-for-azure` |
| **Update Azure skills plugin** | `/plugin update azure@github-copilot-for-azure` |
| **Run shell commands in Copilot** | Prefix with `!` (e.g., `!az account show`) |
| **Check MCP connection** | `/mcp show` |
| **View available skills** | `/skill list` |

## 🔗 Clone the Lab Repo

Want to revisit this lab or share it with colleagues? Clone the starter repo:

```bash
git clone https://github.com/microsoft/mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp.git
```

## Learn More

- **Azure MCP Server docs:** [learn.microsoft.com/azure/developer/azure-mcp-server](https://learn.microsoft.com/azure/developer/azure-mcp-server)
- **GitHub Copilot CLI docs:** [docs.github.com/copilot/github-copilot-in-the-cli](https://docs.github.com/en/copilot/github-copilot-in-the-cli)
- **Container Apps learning path:** [learn.microsoft.com/training/paths/deploy-manage-container-apps](https://learn.microsoft.com/training/paths/deploy-manage-container-apps)

## Try These Next

- **VNet integration** for network isolation
- **Key Vault** for secrets management
- **GitHub Actions CI/CD** with OIDC workload identity federation
- **Terraform support** via `azure-prepare`

## 💬 Share Your Feedback

We'd love to hear how the lab went! Share feedback via the MVP Summit group chat or open an issue at [github.com/microsoft/mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp/issues](https://github.com/microsoft/mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp/issues).

---

**Back to:** [Overview](00-overview.md)
