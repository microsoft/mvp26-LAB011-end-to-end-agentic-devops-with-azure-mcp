# Scenario 2 — See It & Evaluate It (~5 min)

Architecture diagrams are either stale, wrong, or don't exist. AI can generate them instantly — but are they accurate?

## Part A — Generate the Diagram (~2 min)

**Say to Copilot:**

> "Visualize the resources in my resource group as an architecture diagram."

### 5️⃣ `azure-resource-visualizer` activates

Watch how it:
- Queries Azure Resource Graph to inventory every resource in your resource group
- Maps relationships: Container App → Container Apps Environment → Log Analytics, Container App → ACR
- Generates a Mermaid diagram with labeled subgraphs, resource types, and connection arrows
- Outputs renderable markdown you can paste into any Mermaid viewer

> 💡 **Skill spotlight:** The visualizer doesn't just list resources — it infers relationships from resource properties (e.g., `environmentId` links the Container App to its Environment). It's reading the ARM resource model, not guessing from names.

---

## Part B — Evaluate the Diagram (~3 min)

Open the generated markdown and review critically:

- Did it capture all 4 resources (Container App, Environment, ACR, Log Analytics)?
- Are the relationships correct? Does it show ACR → Container App pull?
- What's missing that you'd need for a production architecture review?

**Say to Copilot:**

> "What's missing from this architecture for a production deployment?"

Compare the AI's recommendations against your own findings from Scenario 1B.

✅ **Checkpoint:** You have a Mermaid diagram showing at least 4 resources (Container App, Environment, ACR, Log Analytics) with connection arrows. To render it: copy the Mermaid block from Copilot's output and paste into [mermaid.live](https://mermaid.live) or use VS Code with a Mermaid extension.

**Takeaway:** `azure-resource-visualizer` is excellent for discovery ("what exists right now?") but requires expert review for documentation ("is this complete and accurate?"). The diagram reflects deployed state, not desired state — that gap is your job.

---

**Next:** [Scenario 3 — Break It & Triage It →](06-scenario-3-break-and-triage.md)
