@echo off
echo 🚀 Cloudflare Worker Deployment - Simple Version
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

REM Show current auth status
echo Current authentication status:
wrangler whoami
echo.

REM Deploy the worker directly
echo 🚀 Deploying worker...
echo.

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
    echo 1. Go to Cloudflare Dashboard ^> Workers ^& Pages
    echo 2. Find your worker "contact-form-worker" 
    echo 3. Add custom domain route: stcoops.com/api/contact
    echo 4. Test your contact form
    echo.
    echo 📊 Monitor your worker:
    echo - View logs: wrangler tail contact-form-worker
    echo - Check status: wrangler status contact-form-worker
    echo.
    echo 🧪 Test the worker:
    echo curl -X POST https://contact-form-worker.yourusername.workers.dev/ -d "name=Test&email=test@example.com&message=Hello"
) else (
    echo.
    echo ❌ Deployment failed. 
    echo.
    echo 🔍 Troubleshooting:
    echo 1. Check if wrangler-worker.toml exists in this directory
    echo 2. Verify your account has Workers enabled
    echo 3. Check for syntax errors in worker.js
    echo.
    echo 🔧 Debug commands:
    echo - wrangler list (see existing workers)
    echo - wrangler dev (test locally)
    echo - wrangler deploy worker.js --name contact-form-worker (direct deploy)
)

echo.
pause
