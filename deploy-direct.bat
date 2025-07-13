@echo off
echo 🚀 Direct Worker Deployment
echo.

echo Current directory contents:
dir /b *.toml *.js
echo.

echo Deploying worker...
wrangler deploy --config wrangler-worker.toml

echo.
echo If successful, your worker is now live!
echo Next: Set up the route in Cloudflare Dashboard
pause
