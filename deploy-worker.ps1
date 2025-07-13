# PowerShell Worker Deployment Script
Write-Host "🚀 PowerShell Worker Deployment" -ForegroundColor Green
Write-Host ""

# Check if files exist
if (Test-Path "wrangler-worker.toml") {
    Write-Host "✅ wrangler-worker.toml found" -ForegroundColor Green
} else {
    Write-Host "❌ wrangler-worker.toml not found" -ForegroundColor Red
    exit 1
}

if (Test-Path "worker.js") {
    Write-Host "✅ worker.js found" -ForegroundColor Green
} else {
    Write-Host "❌ worker.js not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Deploying worker..." -ForegroundColor Yellow

# Deploy the worker
try {
    wrangler deploy --config wrangler-worker.toml
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Worker deployed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 Next steps:" -ForegroundColor Cyan
        Write-Host "1. Go to Cloudflare Dashboard"
        Write-Host "2. Workers & Pages > Overview"
        Write-Host "3. Find 'contact-form-worker'"
        Write-Host "4. Add custom domain: stcoops.com/api/contact"
        Write-Host ""
        Write-Host "📊 Monitor your worker:" -ForegroundColor Cyan
        Write-Host "- wrangler tail contact-form-worker"
        Write-Host "- wrangler logs contact-form-worker"
    } else {
        Write-Host ""
        Write-Host "❌ Deployment failed" -ForegroundColor Red
        Write-Host "Try alternative: wrangler deploy worker.js --name contact-form-worker"
    }
} catch {
    Write-Host "❌ Error during deployment: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to continue"
