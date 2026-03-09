# Before You Begin — Login & Launch

Open a terminal (PowerShell or your preferred shell) and complete these steps.

> 💡 **Your Azure and GitHub credentials can be found in the Resources tab of the Skillable VM.**

## 1. Log in to Azure

```bash
az login
```

When the sign-in pop-up shows up, select **Work or school account** and select **Continue**. Input the username found in the **Resources** tab of your Skillable VM by clicking on the keyboard icon and select **Next**. Then, input the TAP found in the same tab by clicking on the keyboard icon to complete sign-in. 

When the terminal prompts you for subscription selection, hit **Enter** for no changes. 

## 2. Log in to GitHub

Open this link in the browser: <https://github.com/enterprises/skillable-events/sso>. Follow the prompts to authenticate. Select the Azure account you just authenticated to. 

## 3. Log in to GitHub Copilot CLI

```bash
copilot
```
This opens the interactive Copilot CLI session. All "Say to Copilot" prompts in this lab are typed here.

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
