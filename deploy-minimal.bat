@echo off
echo 🚀 Minimal Worker Deployment
echo.

wrangler deploy --config wrangler-worker.toml

if %errorlevel% equ 0 (
    echo.
    echo ✅ Success! Worker deployed.
    echo.
    echo 🔗 Next steps:
    echo 1. Go to Cloudflare Dashboard
    echo 2. Workers ^& Pages ^> Overview
    echo 3. Find "contact-form-worker"
    echo 4. Add custom domain: stcoops.com/api/contact
) else (
    echo.
    echo ❌ Deployment failed
    echo Try: wrangler deploy worker.js --name contact-form-worker
)

pause
