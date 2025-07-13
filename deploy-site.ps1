# PowerShell Site Deployment Script
Write-Host "🌐 Cloudflare Pages Deployment" -ForegroundColor Green
Write-Host ""

# Check if we're in a git repository
if (Test-Path ".git") {
    Write-Host "✅ Git repository detected" -ForegroundColor Green
} else {
    Write-Host "⚠️ Not a git repository - some options may not work" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Choose deployment method:" -ForegroundColor Cyan
Write-Host "1. Deploy via GitHub Actions (recommended)"
Write-Host "2. Deploy directly with Wrangler"
Write-Host "3. Manual upload instructions"
Write-Host ""

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🚀 Deploying via GitHub Actions..." -ForegroundColor Yellow
        Write-Host ""
        
        try {
            Write-Host "Adding all files to git..." -ForegroundColor Cyan
            git add .
            
            $commitMessage = "Deploy site with contact form - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "Committing changes..." -ForegroundColor Cyan
            git commit -m $commitMessage
            
            Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
            git push origin main
            
            Write-Host ""
            Write-Host "✅ Pushed to GitHub!" -ForegroundColor Green
            Write-Host "Go to your repository's Actions tab to watch the deployment"
            Write-Host "GitHub Actions will automatically deploy to Cloudflare Pages"
            
        } catch {
            Write-Host "❌ Git operations failed: $_" -ForegroundColor Red
            Write-Host "Make sure you have git configured and the repository is connected to GitHub"
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "🚀 Deploying directly with Wrangler..." -ForegroundColor Yellow
        Write-Host ""
        
        try {
            wrangler pages deploy . --project-name=website
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "✅ Site deployed successfully!" -ForegroundColor Green
                Write-Host "Your site is now live at: https://website.pages.dev"
            } else {
                Write-Host ""
                Write-Host "❌ Deployment failed" -ForegroundColor Red
                Write-Host "Try: wrangler pages deploy . --project-name=stcoops-website"
            }
            
        } catch {
            Write-Host "❌ Wrangler deployment failed: $_" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "📁 Manual upload instructions:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Go to https://dash.cloudflare.com/"
        Write-Host "2. Click 'Workers & Pages'"
        Write-Host "3. Click 'Create' > 'Pages' > 'Upload assets'"
        Write-Host "4. Drag and drop your entire site folder"
        Write-Host "5. Click 'Deploy site'"
        Write-Host ""
        Write-Host "💡 Tip: Create a ZIP file of your site first for easier upload" -ForegroundColor Yellow
        
        # Offer to create ZIP file
        $createZip = Read-Host "Would you like to create a ZIP file now? (y/n)"
        if ($createZip -eq "y" -or $createZip -eq "Y") {
            $zipPath = "site-deployment.zip"
            Write-Host "Creating ZIP file..." -ForegroundColor Cyan
            
            # Get all files except git and node_modules
            $files = Get-ChildItem -Path . -Recurse | Where-Object { 
                $_.FullName -notlike "*\.git\*" -and 
                $_.FullName -notlike "*\node_modules\*" -and
                $_.Name -ne "deploy-*.bat" -and
                $_.Name -ne "deploy-*.ps1"
            }
            
            Compress-Archive -Path $files -DestinationPath $zipPath -Force
            Write-Host "✅ ZIP file created: $zipPath" -ForegroundColor Green
        }
    }
    
    default {
        Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Press Enter to continue"
