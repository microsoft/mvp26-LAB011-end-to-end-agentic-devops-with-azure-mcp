# Getting Started — Create the Starter App

## 1. Create and Enter the Project Directory

Create a new folder and navigate into it. All subsequent commands should be run from this directory. In Copilot CLI, you can preface your commands with '!' to run them directly in shell. 

```bash
!mkdir devops-dashboard
!cd devops-dashboard
```

***

## 2. Create Application Files

### Create `server.js`

Create a new file named `server.js`:

```bash
!New-Item -ItemType File server.js
```

Open `server.js` in your editor and paste the following content:

```js
const http = require("http");

const port = process.env.PORT || 3000;
const startTime = new Date().toISOString();

const routes = {
  "/health": {
    status: "healthy"
  },
  "/api/status": {
    service: "devops-dashboard",
    version: "1.0.0",
    region: process.env.AZURE_REGION || "local",
    deployedAt: startTime,
    runtime: {
      node: process.version,
      platform: process.platform,
      memory: Math.round(process.memoryUsage().rss / 1024 / 1024) + " MB"
    }
  },
  "/api/deployments": {
    latest: {
      id: "azd-" + Date.now(),
      status: "succeeded",
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || "development"
    }
  }
};

const server = http.createServer((req, res) => {
  const handler = routes[req.url];

  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(
    JSON.stringify(
      handler || {
        service: "devops-dashboard",
        endpoints: Object.keys(routes)
      }
    )
  );
});

server.listen(port, () => {
  console.log(`DevOps Dashboard API running on port ${port}`);
});
```

***

### Create `package.json`

Create a new file named `package.json` with the following contents:

```json
{
  "name": "devops-dashboard",
  "version": "1.0.0",
  "scripts": {
    "start": "node server.js"
  }
}
```

***

### Generate `package-lock.json`

Generate a lock file without installing any dependencies:

```bash
!npm install --package-lock-only
```

Expected output:

```text
added 0 packages
audited 0 packages
```

***

## 3. Initialize Git Repository

Initialize a Git repository and commit the starter app.

```bash
!git init
!git add -A
!git commit -m "init"
```

***

## 4. AZD Notes and Gotchas

### Environment Naming

When using AI-assisted setup, AZD environment names **must not include hyphens**.

✅ Valid:

```text
mcplab1234
```

❌ Invalid:

```text
mcp-lab-1234
```

Azure Container Registry names must be alphanumeric. Using hyphens can cause deployment failures.

***

### Subscription Alignment

AZD maintains its own subscription configuration, separate from the Azure CLI.

After running `azd init`, ensure the subscription matches your current Azure CLI context:

```bash
!azd env set AZURE_SUBSCRIPTION_ID $(az account show --query id -o tsv)
```

***

## 5. Checkpoint: Verify Setup

### Verify Git Commit

```bash
!git log --oneline
```

You should see the initial commit.

***

### Run the App Locally

Start the server:

```bash
!node server.js
```

Open a browser and navigate to:

```text
http://localhost:3000
```

You should see JSON output listing the service name and available endpoints.

***

### Stop the Server

Press **Ctrl + C** to stop the running server.

***

✅ You now have a working starter app ready to be integrated into AZD and Copilot CLI–driven workflows.

***

**Next:** [Scenario 1 — Ship It & Harden It →](04-scenario-1-ship-and-harden.md)
