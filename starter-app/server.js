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
