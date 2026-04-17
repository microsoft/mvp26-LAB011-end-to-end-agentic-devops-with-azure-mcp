[← Previous: Login & Launch](02-login-and-launch.md) | [Next: Scenario 1 — Ship & Harden →](04-scenario-1-ship-and-harden.md)

---

# Getting Started — Set Up the Starter App

Open a new Powershell session and set up the starter app using the following instructions. 

## 1. Clone the Lab Repository

clone the lab repo and navigate into it:

```powershell
git clone https://github.com/microsoft/mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp.git
```
```powershell
cd mvp26-LAB011-end-to-end-agentic-devops-with-azure-mcp
```

## 2. Copy the Starter App

The `starter-app/` directory contains a ready-to-go Node.js API. Copy it to a new `devops-dashboard` working directory and initialize it as its own Git repo:

```powershell
Copy-Item -Recurse starter-app devops-dashboard
```

> [!TIP]
> 🏠 **On macOS or Linux?** Use `cp -r starter-app devops-dashboard` instead of the PowerShell command above.

```powershell
cd devops-dashboard
```
```powershell
git config --global user.name "Your Name"
```
```powershell
git config --global user.email "you@example.com"
```
```powershell
git init && git add -A && git commit -m "init"
```

All subsequent commands should be run from the `devops-dashboard` directory.

> 💡 **What's in the starter app?** `server.js` is a lightweight Node.js HTTP API with `/health`, `/api/status`, and `/api/deployments` endpoints. `package.json` defines the project metadata and start script. `package-lock.json` is pre-generated.

## 3. Checkpoint: Verify Setup

```powershell
git log --oneline
```

You should see the initial commit.

Start the server:

```powershell
node server.js
```

Open a browser and navigate to `http://localhost:3000` — you should see JSON output listing the service name and available endpoints. Press **Ctrl + C** to stop the running server.

✅ You now have a working starter app ready to be integrated into AZD and Copilot CLI–driven workflows.

***

**Next:** [Scenario 1 — Ship It & Harden It →](04-scenario-1-ship-and-harden.md)

---

[← Previous: Login & Launch](02-login-and-launch.md) | [Next: Scenario 1 — Ship & Harden →](04-scenario-1-ship-and-harden.md)
