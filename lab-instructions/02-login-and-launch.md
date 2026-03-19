# Before You Begin — Login & Launch

## 0. Start Docker

Type for **Docker Desktop** in the Search and start your Docker instance. 

Open a terminal (PowerShell or your preferred shell) and complete these steps.

> 💡 **Your Azure and GitHub credentials can be found in the Resources tab of the Skillable VM.** Always use the credentials listed there — do not use your personal Microsoft account or your work/corporate account.

> ⚠️ **Duplicate users:** In some lab environments, you may see two different user accounts listed. If this happens, use the credentials shown in the **Resources** tab and ignore any additional accounts. The Resources tab is the source of truth.

## 1. Log in to Azure

```bash
az login
```

When the sign-in pop-up shows up, select **Work or school account** and select **Continue**. Input the username found in the **Resources** tab of your Skillable VM by clicking on the keyboard icon and select **Next**. Then, input the TAP found in the same tab by clicking on the keyboard icon to complete sign-in.

> ⚠️ **Do NOT select "Microsoft account" (personal/consumer).** The login page may show multiple options — always select **Work or school account**. Selecting the wrong option will result in access-denied errors.

When the terminal prompts you for subscription selection, hit **Enter** for no changes. 

## 2. Log in to Azure Developer CLI

```bash
azd auth login
```

Select the Azure account from the previous step and complete authentication. 

## 3. Log in to GitHub

Open this link in the browser: <https://github.com/enterprises/skillable-events/sso>. Follow the prompts to authenticate. Select the Azure account you just authenticated to. 

## 4. Log in to GitHub Copilot CLI

```bash
copilot
```
This opens the interactive Copilot CLI session. All "Say to Copilot" prompts in this lab are typed here. **Keep this session open for the rest of the lab** — this is where you'll interact with AI skills.

> 💡 **Terminal vs. Copilot:** Throughout this lab, you'll run commands in two places. **Copilot CLI** is for AI-driven prompts (e.g., "Deploy my app to Azure"). **Terminal commands** (prefixed with `!` in Copilot) are for shell operations like `curl`, `az`, and `git`. When in doubt, you can run any terminal command inside Copilot by prefixing it with `!`.

```bash
/login
```
Follow the instructions in Copilot to complete authorization using the signed-in account.

![Copilot Login](../resources/CopilotLogIn.png)

## 5. Install the Azure Skills Plugin

1. Add the Microsoft marketplace:
   ```
   /plugin marketplace add microsoft/azure-skills
   ```

2. Install the Azure plugin:
   ```
   /plugin install azure@azure-skills
   ```

3. Reload azure mcp:
   ```
   /mcp reload
   ```

4. To update later:
   ```
   /plugin update azure@azure-skills
   ```

> 💡 **MCP tools vs. Azure skills:** The Azure MCP server provides **MCP tools** — low-level operations like listing resources, querying logs, and managing deployments. Azure **skills** are higher-level prompt instructions that chain these tools together with domain knowledge (e.g., `azure-diagnostics` knows how to follow a triage reasoning chain). This lab uses both: skills drive the workflow, MCP tools execute the Azure operations.

✅ **Checkpoint:** You're logged into GitHub and Azure, Copilot CLI is running, Azure skills and Azure MCP Server are installed.

---

**Next:** [Create the Starter App →](03-getting-started.md)
