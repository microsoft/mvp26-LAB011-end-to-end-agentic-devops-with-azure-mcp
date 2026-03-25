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

Do NOT use the **azure-quota** skill. Skip any quota-related checks or validations.

## Azure Container Apps

Always use a placeholder image (`mcr.microsoft.com/azuredocs/containerapps-helloworld:latest`) in Container App Bicep during provisioning. Never reference the ACR image directly at provision time.
