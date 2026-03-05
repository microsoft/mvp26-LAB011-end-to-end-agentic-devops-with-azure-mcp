# Troubleshooting

## ACR name contains hyphens → Deployment fails
**Symptom:** `azd up` fails with an error about invalid ACR name.
**Cause:** ACR names must be alphanumeric. Hyphens in your AZD environment name propagate to the registry name.
**Fix:** Use an environment name without hyphens (e.g., `mcplab1234`). Re-run `azd init` with a new name.

## AZD deploys to wrong subscription
**Symptom:** Resources appear in an unexpected subscription, or you get permission errors.
**Cause:** AZD maintains its own subscription config, separate from `az account show`.
**Fix:** Run `azd env set AZURE_SUBSCRIPTION_ID $(az account show --query id -o tsv)` to align.

## `az containerapp ingress update` hangs for 2+ minutes
**Symptom:** The command appears stuck after running.
**Cause:** The CLI waits for the new Container Apps revision to activate.
**Fix:** This is expected behavior. Wait for it to complete — do not Ctrl+C.

## First request after deploy returns timeout or slow response
**Symptom:** `curl` times out or takes >10 seconds on first request.
**Cause:** New revision is activating (cold start). `minReplicas: 1` is set, but initial activation still takes time.
**Fix:** Wait ~15 seconds after deployment completes, then retry.

## KQL query returns no results in Scenario 4
**Symptom:** Queries return empty tables.
**Cause:** Log Analytics ingestion has ~5 minute latency. Metrics have ~15 minute latency.
**Fix:** Wait 5 minutes after Scenario 3, then retry the query.

## `az monitor scheduled-query create` fails with "command not found"
**Symptom:** CLI doesn't recognize the `scheduled-query` command.
**Cause:** The preview CLI extension isn't installed.
**Fix:** Run `az extension add --name scheduled-query --yes`

## Docker build fails during `azd up`
**Symptom:** Deployment fails with Docker-related error.
**Cause:** Docker Desktop isn't running.
**Fix:** Start Docker Desktop and verify with `docker version`. Then re-run `azd up`.

## PowerShell quote escaping in KQL queries
**Symptom:** KQL `where Reason_s == "PortMismatch"` fails with syntax errors in PowerShell.
**Cause:** PowerShell handles double quotes differently than bash.
**Fix:** Use the `has` operator instead: `where Reason_s has "PortMismatch"`. The AI typically handles this automatically.

---

**Back to:** [Overview](00-overview.md) | [What's Next →](10-whats-next.md)
