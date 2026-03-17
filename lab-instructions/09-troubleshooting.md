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

## Lab VM disconnects frequently
**Symptom:** The Skillable VM disconnects every 10–15 minutes or drops connection multiple times per hour.
**Cause:** Network instability between your browser and the Skillable VM environment.
**Fix:** Reconnect using the Skillable lab launch URL. Your work is preserved — the VM is still running. If disconnects are very frequent, try switching to a wired network connection or a different browser. Avoid having many browser tabs open alongside the VM.

## Lab VM is slow or unresponsive
**Symptom:** Commands take much longer than expected, typing lags, or the UI feels sluggish.
**Cause:** Lab VM resources are shared and may vary in performance. Deployment steps (`azd up`) are particularly resource-intensive.
**Fix:** Be patient with deployment commands — they typically complete within 5–7 minutes even on slower VMs. Close unnecessary applications within the VM (browser tabs, extra VS Code windows). If a specific command appears hung, check if it's still making progress before cancelling.

## Azure skill is interrupted or takes very long
**Symptom:** A Copilot skill invocation seems to hang, times out, or takes significantly longer than expected.
**Cause:** Azure skill execution depends on both the AI service and the Azure APIs it calls. Intermittent slowness can occur.
**Fix:** Wait up to 2 minutes for a skill to complete. If it truly times out, re-send the same prompt. If a skill is repeatedly interrupted, try breaking the request into smaller prompts (e.g., instead of "deploy and harden," try "deploy" first, then "harden" separately).

## Cannot access lab VM via launch URL
**Symptom:** Clicking the Skillable lab launch URL returns an error or blank page.
**Cause:** Session may have expired, or the URL may have been invalidated.
**Fix:** Return to the Skillable portal and relaunch the lab. If the issue persists, check with a proctor for a fresh lab environment.

---

**Back to:** [Overview](00-overview.md) | [What's Next →](10-whats-next.md)
