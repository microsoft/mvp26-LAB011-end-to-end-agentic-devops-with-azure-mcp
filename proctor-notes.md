# Proctor Notes — Ship, Harden, Break, Investigate Lab

> For lab proctors only. Discovered during end-to-end testing (2026-02-25 through 2026-03-03).

---

## ⚠️ Real-World Timing Advisory

Benchmark testing completed the lab in ~25 minutes, but **in real lab conditions expect 45–90 minutes** for most attendees. Contributing factors:
- **VM performance:** Skillable VMs may be slower than dev machines, adding time to deployments
- **VM disconnects:** Some testers reported 4–5 disconnects per hour — each costs 1–2 minutes to recover
- **Azure skill variability:** AI responses are non-deterministic; skills may take longer or require re-prompting
- **Login friction:** Account confusion at sign-in can cost 5–10 minutes

**Recommendation:** Frame Scenarios 1–3 as the core lab (~20 min). Scenario 4 is a bonus. Encourage attendees to continue on their own if they run out of time — the lab repo is public and the instructions are self-contained.

## VM Stability Notes

| Issue | What Testers Reported | What To Tell Attendees |
|---|---|---|
| **Frequent disconnections** | 4–5 disconnects in ~1 hour | "Reconnect via the launch URL — your work is preserved. The VM keeps running." |
| **Slow responsiveness** | Commands take 2–3x longer than on local machines | "Deployment steps are slower on shared VMs — this is expected. Use wait time for discussion." |
| **Azure skills interrupted** | Skill invocations timeout or hang | "Re-send the same prompt. If it keeps failing, try breaking it into smaller requests." |
| **Launch URL issues** | Blank page or error on initial access | "Relaunch from the Skillable portal. If persistent, ask a proctor for a fresh environment." |

---

## Critical — Must Address Before Lab

| Issue | Root Cause | Mitigation |
|---|---|---|
| **AZD deploys to wrong subscription** | AZD maintains its own subscription config, separate from `az account show` | Lab setup must run `azd env set AZURE_SUBSCRIPTION_ID <id>` after `azd init`. Verify this. |
| **`az containerapp ingress update` blocks ~2 min** | CLI waits for Container Apps revision activation | Tell attendees this is expected. Use the wait to discuss the triage reasoning chain. |
| **First request after deploy can take >10s** | New revision activating | Have attendees hit `/health` first, or wait ~15s after deploy completes. |
| **Docker Desktop must be running** | `azd up` Docker build fails otherwise | Pre-flight check: `docker version` must succeed. |
| **`scheduled-query` CLI extension required for Scenario 4B** | `az monitor scheduled-query create` needs preview extension | Pre-install: `az extension add --name scheduled-query --yes` and `az config set extension.dynamic_install_allow_preview=true`. |

## Dockerfile & Build Issues (Already Fixed)

| Issue | Fix Applied |
|---|---|
| `npm ci` fails without `package-lock.json` | Dockerfile uses `npm install --omit=dev` |
| Cold start with `minReplicas: 0` | Bicep sets `minReplicas: 1` |

## Scenario-Specific Notes

| Scenario | Note |
|---|---|
| 1B (Harden) | The managed identity + AcrPull step may require re-deploy to take effect. For the lab, showing the command and explaining the pattern is sufficient. |
| 1B (Harden) | The production gaps table is opinionated. Encourage attendees to add their own findings. |
| 2B (Evaluate) | The diagram may not reflect the managed identity from 1B — role assignments aren't always visible as diagram nodes. Good discussion point. |
| 3 (Break) | Do NOT use bad image tags — they poison the revision template. Port mismatch is clean and recoverable. |
| 3 (Triage) | If time allows, demo a second hypothetical failure to show how the AI adapts. |
| 4A (KQL) | KQL logs appear within ~5 min. Azure Monitor metrics have ~15 min latency. If metrics show 0, explain the pipeline delay. |
| 4A (KQL) | KQL `where Reason_s == "PortMismatch"` may fail in PowerShell due to quote escaping. `has` operator works. The AI handles this. |
| 4B (Alert) | The `--condition` syntax uses named placeholders: `count 'Name' > 0` with `--condition-query Name="KQL..."`. Unintuitive but the AI handles it. |
| 4B (Alert) | No action group needed for alert creation — discuss attaching one as a "next step." |
| 4 (General) | Scenario 3 PortMismatch events appearing in Scenario 4 is intentional — narrative payoff, not a bug. |

## Facilitation Tips

| Moment | What to Do |
|---|---|
| After Scenario 1A deploy | Ask: "Would you push this Bicep to production?" Let attendees identify gaps before showing the table. |
| During Scenario 2B | Ask: "What would you add for a production architecture review?" Expect: data flow, security boundaries, DR. |
| During Scenario 3 triage | Narrate the reasoning chain: "It checked system logs first, not console logs. Why?" |
| During Scenario 4B | Ask: "What's your standard alert set for Container Apps?" Compare AI suggestions to the room's experience. |

## Alternate Scenarios (Swappable)

| Scenario | Duration | Skills | Best For |
|---|---|---|---|
| Compliance Guardrails | ~2 min | `azure-rbac` | Governance-focused audiences |
| Cost Optimization | ~5 min | `azure-cost-optimization` | FinOps teams (needs `costmanagement` + `resource-graph` CLI extensions) |

## Timing Benchmarks (From Testing)

| Scenario | Expected | Actual |
|---|---|---|
| 1A — Ship | ~5 min | ~4 min |
| 1B — Harden | ~3 min | ~3 min |
| 2 — See & Evaluate | ~5 min | ~4 min |
| 3 — Break & Triage | ~5 min | ~5 min |
| 4A — Post-Mortem | ~5 min | ~4 min |
| 4B — Operationalize | ~5 min | ~5 min (with pre-installed extension) |
| **Total** | **~28 min** | **~25-28 min** |
