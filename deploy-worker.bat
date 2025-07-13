@echo off
REM Deploy Cloudflare Worker - Windows Script
echo 🚀 Deploying Cloudflare Worker...

REM Check if wrangler is installed
where wrangler >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Wrangler CLI...
    npm install -g wrangler
)

REM Login to Cloudflare (if not already logged in)
echo Checking Cloudflare authentication...
wrangler whoami || wrangler login

REM Deploy the worker
echo Deploying worker...
wrangler deploy --config wrangler-worker.toml

REM Check deployment status
if %errorlevel% equ 0 (
    echo ✅ Worker deployed successfully!
    echo Your contact form endpoint is now available at:
    echo https://contact-form-worker.yourusername.workers.dev/
    echo Or at your custom domain: https://stcoops.com/api/contact
) else (
    echo ❌ Deployment failed. Check the error messages above.
)

echo 🔧 Next steps:
echo 1. Test the worker endpoint
echo 2. Configure your domain routing
echo 3. Set up KV namespace for rate limiting (optional)
echo 4. Add email secrets if needed

pause
