# Scenario 4 — Investigate It & Operationalize It (~10 min)

The incident is resolved. Now: "How long was it down? How do we prevent it next time?"

> ⏱️ **Log ingestion latency:** Container App system logs take ~5 minutes to appear in Log Analytics. If you completed Scenario 3 quickly, the data should be available by now — if not, wait a minute and retry.

## Part A — Post-Mortem via KQL (~5 min)

**Say to Copilot:**

> "Query the Log Analytics workspace for my Container App. Show me what happened during the port mismatch incident."

### 7️⃣ `azure-observability` activates

Watch how it builds the investigation:

1. **Workspace discovery** — locates your Log Analytics workspace from the resource group
2. **Table exploration** — queries `ContainerAppSystemLogs_CL` to find available event types
3. **Event distribution** — runs a KQL `summarize count() by Reason_s` to show the breakdown: PortMismatch events, ReplicaUnhealthy impact, RevisionUpdate recovery
4. **Incident timeline** — writes a KQL query with `earliest(TimeGenerated)` and `latest(TimeGenerated)` to calculate exact downtime duration
5. **Recovery confirmation** — checks for `RevisionReady` events to prove the fix worked

> 💡 **Skill spotlight:** `azure-observability` writes KQL *for you* based on natural language. Review the generated queries — would you have written them differently? The skill uses `has` instead of `==` for string matching in KQL, which is more resilient to log format changes.

**Review the KQL the AI wrote.** Copy a query and modify it — try adding a `| where TimeGenerated > ago(1h)` filter or changing the `summarize` to include `bin(TimeGenerated, 5m)` for a time-series view. Run modified queries in the Copilot CLI or paste them into the Azure Portal's Log Analytics query editor.

✅ **Checkpoint:** You've seen KQL queries showing the PortMismatch events, the incident timeline, and the recovery confirmation.

---

## Part B — Operationalize It (~5 min)(LEARN-ONLY)

> This section is learn-only. The steps below are expected to fail in the lab environment due to existing policy constraints.

**Say to Copilot:**

> "Create a KQL alert rule that fires when PortMismatch events appear in the Container App system logs."

### `azure-observability` continues

It:
- Writes the alert KQL query targeting `ContainerAppSystemLogs_CL`
- Generates the full `az monitor scheduled-query create` command with threshold, frequency, severity, and action group
- Explains each parameter so you can tune it (e.g., evaluation frequency, number of violations before firing)

> ⚠️ **Prerequisite:** The `scheduled-query` CLI extension must be installed: `az extension add --name scheduled-query --yes`

**Then ask:**

> "What other alert rules should I have for a production Container App?"

The AI suggests: replica health, restart loops, high latency, 5xx spikes, memory utilization — each with the KQL pattern you'd need.

✅ **Checkpoint:** `az monitor scheduled-query list -g <rg> -o table` shows your alert rule.

**Takeaway:** Two prompts, one skill (`azure-observability`), and you went from "the incident is over" to "this class of incident will page me next time." The real 300-level value: you can now read and modify these KQL queries yourself.

---

**Next:** [Cleanup →](08-cleanup.md)
