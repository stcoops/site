@echo off
echo 🚀 Cloudflare Worker Deployment - Enhanced Version
echo.

REM Check if wrangler is installed
where wrangler >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Wrangler CLI...
    npm install -g wrangler
    if %errorlevel% neq 0 (
        echo ❌ Failed to install Wrangler. Please install Node.js first.
        pause
        exit /b 1
    )
)

echo ✅ Wrangler is installed
echo.

REM Check authentication
echo Checking Cloudflare authentication...
wrangler whoami
if %errorlevel% neq 0 (
    echo 🔐 Not authenticated. Starting login process...
    echo.
    echo IMPORTANT: When you see token permissions, type 'y' and press Enter to accept
    echo.
    pause
    wrangler login
    if %errorlevel% neq 0 (
        echo ❌ Authentication failed. 
        echo.
        echo Try these alternatives:
        echo 1. Run: wrangler login --browser=false
        echo 2. Create an API token at: https://dash.cloudflare.com/profile/api-tokens
        echo 3. Set token: set CLOUDFLARE_API_TOKEN=your-token-here
        pause
        exit /b 1
    )
) else (
    echo ✅ Authentication successful - proceeding with deployment
)
echo.

REM Deploy the worker
echo 🚀 Deploying worker...
wrangler deploy --config wrangler-worker.toml

if %errorlevel% equ 0 (
    echo.
    echo ✅ Worker deployed successfully!
    echo.
    echo 🔗 Your endpoints:
    echo - Worker URL: https://contact-form-worker.yourusername.workers.dev/
    echo - Custom domain: https://stcoops.com/api/contact (after route setup)
    echo.
    echo 🔧 Next steps:
    echo 1. Test the worker endpoint
    echo 2. Configure domain routing in Cloudflare dashboard
    echo 3. Test your contact form
    echo.
    echo 📊 Monitor your worker:
    echo - View logs: wrangler tail contact-form-worker
    echo - Check status: wrangler status contact-form-worker
) else (
    echo ❌ Deployment failed. 
    echo.
    echo 🔍 Common issues:
    echo - Check your wrangler-worker.toml file exists
    echo - Verify you have write permissions to Workers
    echo - Check your account limits
    echo.
    echo 🔧 Debug commands:
    echo - wrangler whoami
    echo - wrangler list
    echo - wrangler dev (test locally)
)

echo.
pause
