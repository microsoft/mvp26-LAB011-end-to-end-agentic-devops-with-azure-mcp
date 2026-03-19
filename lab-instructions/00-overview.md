# End-to-End Agentic DevOps with Azure MCP — Ship, Harden, Break, Investigate

**Hands-On Lab (30 min) | Level: 300**

AI can deploy your app to Azure in 5 minutes. But should you trust what it built? In this lab, you'll use GitHub Copilot CLI with Azure skills to deploy a live Container App — then put on your architect hat and evaluate the AI's decisions. You'll review generated Bicep, identify what's missing for production, direct the AI to harden the deployment, break the app on purpose, and run a full forensic investigation — all without opening the Azure Portal.

> 💡 **AI responses may vary** from what's described in this guide. Focus on which skills activate and the reasoning patterns, not exact output. The prompts are tested, but AI is non-deterministic — your results may look slightly different.

### Target Architecture

```mermaid
graph LR
    Internet -->|HTTPS| CA[Container App]
    CA --> CAE[Container Apps Environment]
    CAE --> LA[Log Analytics Workspace]
    CA -->|Managed Identity + AcrPull| ACR[Azure Container Registry]
    CA -.->|System Logs| LA
    LA -.->|KQL Queries| Alerts[Alert Rules]
```

## What You'll Learn

- How Azure **skills** chain together — one prompt can trigger `prepare` → `validate` → `deploy` automatically
- Where AI-generated infrastructure gets you to 80% — and the production gaps you need to close
- How to critically review AI-generated Bicep, Dockerfiles, and architecture diagrams
- How skills like `azure-diagnostics` and `azure-observability` reason through problems: triage patterns, log correlation, KQL generation
- When to trust the AI's decisions and when to override them

## Skills Used — 7 Skills Across 4 Scenarios

| # | Skill | What It Does | Scenario |
|---|---|---|---|
| 1 | `azure-prepare` | Scans your codebase, generates IaC + Docker + config from skill references | 1A: Ship |
| 2 | `azure-validate` | Pre-flight checks: Bicep compilation, Docker status, subscription access | 1A: Ship |
| 3 | `azure-deploy` | Runs `azd up` — provisions infrastructure + builds + deploys | 1A: Ship |
| 4 | `azure-rbac` | Finds least-privilege roles from Azure docs, generates assignment commands | 1B: Harden |
| 5 | `azure-resource-visualizer` | Queries Resource Graph, maps relationships, generates Mermaid diagrams | 2: See |
| 6 | `azure-diagnostics` | Pulls system logs, follows diagnostic reasoning chain to root cause | 3: Break |
| 7 | `azure-observability` | Writes KQL queries from natural language, creates alert rules | 4: Investigate |

> 📖 **Glossary:** **ACR** = Azure Container Registry (private Docker image store). **AZD** = Azure Developer CLI (`azd`). **Bicep** = Azure's IaC language. **KQL** = Kusto Query Language (for log queries). **MCP** = Model Context Protocol.

## Lab Sections

| # | Section | File | Duration |
|---|---------|------|----------|
| 1 | [Prerequisites](01-prerequisites.md) | `01-prerequisites.md` | Pre-session |
| 2 | [Login & Launch](02-login-and-launch.md) | `02-login-and-launch.md` | ~2 min |
| 3 | [Create the Starter App](03-getting-started.md) | `03-getting-started.md` | ~2 min |
| 4 | [Scenario 1 — Ship It & Harden It](04-scenario-1-ship-and-harden.md) | `04-scenario-1-ship-and-harden.md` | ~8 min |
| 5 | [Scenario 2 — See It & Evaluate It](05-scenario-2-see-and-evaluate.md) | `05-scenario-2-see-and-evaluate.md` | ~5 min |
| 6 | [Scenario 3 — Break It & Triage It](06-scenario-3-break-and-triage.md) | `06-scenario-3-break-and-triage.md` | ~5 min |
| 7 | [Scenario 4 — Investigate & Operationalize](07-scenario-4-investigate-and-operationalize.md) | `07-scenario-4-investigate-and-operationalize.md` | ~10 min |
| 8 | [Cleanup](08-cleanup.md) | `08-cleanup.md` | ~1 min |
| 9 | [Troubleshooting](09-troubleshooting.md) | `09-troubleshooting.md` | Reference |
| 10 | [What's Next](10-whats-next.md) | `10-whats-next.md` | Reference |
