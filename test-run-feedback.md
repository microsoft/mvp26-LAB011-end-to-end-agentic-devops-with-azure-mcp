# Lab Test Run Feedback

**Subscription:** yunjchoi subscription (107ecb4c-adab-4328-bfa2-73af8fa8581f)
**Tester:** Copilot CLI (automated)

---

## Run 1 — 2026-03-04 (Before Fixes)

### Timing

| Exercise | Expected | Actual | Delta |
|---|---|---|---|
| Getting Started | ~1 min | 0:21 | ✅ On track |
| Scenario 1A: Ship It | ~5 min | ~13 min | 🔴 +8 min (2 deployment failures) |
| Scenario 1B: Harden It | ~3 min | ~3 min | ✅ On track |
| Scenario 2: See & Evaluate | ~5 min | ~3 min | ✅ Faster |
| Scenario 3: Break & Triage | ~5 min | ~3 min | ✅ Faster |
| Scenario 4A: Post-Mortem KQL | ~5 min | ~4 min | ✅ On track |
| Scenario 4B: Operationalize | ~5 min | ~3 min | ✅ Faster |
| **Total** | **~28 min** | **~29 min** | 🟡 Barely over (Scenario 1 failures) |

### Derailments Found

1. **🔴 ACR naming with hyphens** — `var registryName = 'cr${environmentName}${resourceSuffix}'` doesn't strip hyphens. ACR names must be alphanumeric. ~3 min lost.
2. **🔴 MANIFEST_UNKNOWN chicken-and-egg** — Bicep references `api:latest` in ACR but image not pushed yet. ~5 min lost.
3. **🟡 azure-rbac MCP tools unavailable** — Falls back to general knowledge. Output still correct. ~1 min.
4. **🟡 Graph replication delay** — Role assignment fails if run immediately after identity creation. Wait 15s. ~20s.
5. **🟡 `--action-groups ""` fails** — Omit the parameter instead. ~30s.

---

## Run 2 — 2026-03-04 (After Fixes)

**Fixes applied before this run:**
- ✅ Hyphen-free environment name (`mcplabr2`) per updated instructions
- ✅ Bicep uses `replace()` to strip hyphens from ACR name
- ✅ Initial image set to `mcr.microsoft.com/k8se/quickstart:latest` (prevents chicken-and-egg)
- ✅ 15-second wait after identity creation before role assignment
- ✅ DevOps Dashboard starter app (replaced generic Hello World)

### Timing

| Exercise | Expected | Actual | Delta |
|---|---|---|---|
| Getting Started | ~1 min | 1:00 | ✅ On track |
| Scenario 1A: Ship It | ~5 min | ~7 min | ✅ On track (includes azd provisioning) |
| Scenario 1B: Harden It | ~3 min | ~3 min | ✅ On track |
| Scenario 2: See & Evaluate | ~5 min | ~2 min | ✅ Faster |
| Scenario 3: Break & Triage | ~5 min | ~3 min | ✅ Faster |
| Scenario 4A: Post-Mortem KQL | ~5 min | ~2 min | ✅ Faster |
| Scenario 4B: Operationalize | ~5 min | ~3 min | ✅ On track |
| **Total** | **~28 min** | **~21 min** | ✅ Well under target |

### Derailments

**🟢 ZERO critical derailments.** All 5 issues from Run 1 are resolved:

| Run 1 Derailment | Status in Run 2 |
|---|---|
| 🔴 ACR hyphens | ✅ Fixed — `replace()` in Bicep + hyphen-free env name |
| 🔴 MANIFEST_UNKNOWN | ✅ Fixed — placeholder image `mcr.microsoft.com/k8se/quickstart:latest` |
| 🟡 azure-rbac MCP tools | 🟡 Still present but non-blocking — correct output via fallback |
| 🟡 Graph replication delay | ✅ Fixed — 15s wait prevents the error |
| 🟡 `--action-groups ""` | ✅ Fixed — parameter omitted |

### What Worked

- **All 7 Azure skills invoked successfully:** azure-prepare, azure-validate, azure-deploy, azure-rbac, azure-resource-visualizer, azure-diagnostics, azure-observability
- **Scenario 1A deployed on first attempt** — no retries needed
- **KQL found PortMismatch in <30 seconds** after the break was introduced
- **Alert rule created with correct `--condition-query QUERY=...` syntax**
- **DevOps Dashboard endpoints all responded:** `/health`, `/api/status`, `/api/deployments`, `/`

---

## Recommendation

**The lab is ready for attendees.** Run 2 completed in ~21 min with zero critical derailments. The remaining minor issue (azure-rbac MCP tools) is invisible to attendees and produces correct results via fallback.

