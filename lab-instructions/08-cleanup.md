# Cleanup

When you're done, tear everything down:

```bash
azd down --no-prompt --purge
```

If that times out:
```bash
az group delete --name rg-<your-env-name> --yes --no-wait
```

> ⚠️ **Cost warning:** If you skip cleanup, the Container Apps Environment and ACR will incur charges (~$5-12/month). Set a calendar reminder to verify resources are deleted.

**Estimated lab cost per attendee (if cleaned up immediately):** ~$0.20. If left running for 30 days: ~$8-12.

## Timing Summary

| Scenario | Duration | Skills Invoked | Skill Count |
|---|---|---|---|
| 1. Ship & Harden | ~8 min | `azure-prepare` → `azure-validate` → `azure-deploy` + `azure-rbac` | 4 |
| 2. See & Evaluate | ~5 min | `azure-resource-visualizer` | 1 |
| 3. Break & Triage | ~5 min | `azure-diagnostics` | 1 |
| 4. Investigate & Operationalize | ~10 min | `azure-observability` | 1 |
| **Total** | **~28 min** | **7 unique skills** | **7** |

---

**Next:** [Troubleshooting →](09-troubleshooting.md) | [What's Next →](10-whats-next.md)
