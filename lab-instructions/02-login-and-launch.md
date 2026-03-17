# Before You Begin — Login & Launch

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

## 2. Log in to GitHub

Open this link in the browser: <https://github.com/enterprises/skillable-events/sso>. Follow the prompts to authenticate. Select the Azure account you just authenticated to. 

## 3. Log in to GitHub Copilot CLI

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

## 4. Verify Azure MCP is connected

```
/mcp show
```

You should see `azure-mcp` listed with status `● connected`. If not, go back to the [Prerequisites](01-prerequisites.md) and configure the Azure MCP Server.

✅ **Checkpoint:** You're logged into GitHub and Azure, Copilot CLI is running, and Azure MCP is connected.

---

**Next:** [Create the Starter App →](03-getting-started.md)
