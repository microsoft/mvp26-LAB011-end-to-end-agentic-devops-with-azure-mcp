# Getting Started — Create the Starter App

Create a new folder and navigate into it — all subsequent commands assume you're in this directory:

```bash
mkdir devops-dashboard && cd devops-dashboard
```

Add these two files:

## server.js

```javascript
const http = require("http");
const port = process.env.PORT || 3000;
const startTime = new Date().toISOString();

const routes = {
  "/health": () => ({ status: "healthy", uptime: process.uptime() }),
  "/api/status": () => ({
    service: "devops-dashboard",
    version: "1.0.0",
    region: process.env.AZURE_REGION || "local",
    deployed: startTime,
    runtime: { node: process.version, platform: process.platform, memory: Math.round(process.memoryUsage().rss / 1024 / 1024) + "MB" }
  }),
  "/api/deployments": () => ({
    latest: { id: "azd-" + Date.now(), status: "succeeded", timestamp: new Date().toISOString() },
    environment: process.env.NODE_ENV || "development"
  })
};

const server = http.createServer((req, res) => {
  const handler = routes[req.url];
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify(handler ? handler() : { service: "devops-dashboard", endpoints: Object.keys(routes) }));
});

server.listen(port, () => console.log(`DevOps Dashboard API running on port ${port}`));
```

## package.json

```json
{ "name": "devops-dashboard", "version": "1.0.0", "scripts": { "start": "node server.js" } }
```

## Initialize the Project

```bash
npm install --package-lock-only
git init && git add -A && git commit -m "init"
```

Expected output: `added 0 packages` from npm, then `[main (root-commit) ...] init` from git.

> ⚠️ **Important:** When the AI creates your AZD environment, use a name **without hyphens** (e.g., `mcplab1234`, not `mcp-lab-1234`). Azure Container Registry names must be alphanumeric only — hyphens in the environment name will cause deployment to fail.

> ⚠️ **AZD subscription alignment:** AZD maintains its own subscription config, separate from `az account show`. After `azd init`, run `azd env set AZURE_SUBSCRIPTION_ID $(az account show --query id -o tsv)` to ensure AZD uses the same subscription you're logged into.

✅ **Checkpoint:** Run `git log --oneline` — you should see one commit. Run `node server.js` — visit `http://localhost:3000` and confirm you see JSON output. Press Ctrl+C to stop.

---

**Next:** [Scenario 1 — Ship It & Harden It →](04-scenario-1-ship-and-harden.md)
