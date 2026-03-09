# Copilot CLI — Lab Instructions

## Azure Skills

Always use Azure skills when working with Azure resources in this project:

- **azure-prepare** — Scaffold infrastructure (Bicep, azure.yaml, Dockerfile)
- **azure-validate** — Pre-flight checks before deployment
- **azure-deploy** — Execute deployment via azd
- **azure-rbac** — Role assignments and least-privilege access
- **azure-diagnostics** — Troubleshoot production issues and analyze logs
- **azure-observability** — KQL queries, alerts, and monitoring setup
- **azure-resource-visualizer** — Architecture diagrams from deployed resources

## Project Context

- This is a Node.js HTTP API targeting **Azure Container Apps** via **Azure Developer CLI (azd)**.
- The app exposes `/health`, `/api/status`, and `/api/deployments` endpoints.
- Infrastructure is defined in Bicep under `infra/`.

## Code Generation Guidelines

- When generating `az` CLI commands, verify Azure resource provider namespaces are spelled correctly (e.g., `Microsoft.ContainerRegistry`, `Microsoft.App`, `Microsoft.OperationalInsights`).
- When creating AZD environment names, use alphanumeric characters only — no hyphens (Azure Container Registry names must be alphanumeric).
- Use managed identity over admin credentials or connection strings wherever possible.
