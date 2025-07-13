@echo off
echo 🌐 Cloudflare Pages Deployment
echo.

echo Current directory contents:
dir /b *.html
echo.

echo Choose deployment method:
echo 1. Deploy via GitHub Actions (push to repo)
echo 2. Deploy directly with Wrangler
echo 3. Manual upload to Cloudflare Dashboard
echo.

set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo.
    echo 🚀 Deploying via GitHub Actions...
    echo.
    echo Adding all files to git...
    git add .
    
    echo Committing changes...
    git commit -m "Deploy site with contact form - %date% %time%"
    
    echo Pushing to GitHub...
    git push origin main
    
    echo.
    echo ✅ Pushed to GitHub!
    echo Go to your repository's Actions tab to watch the deployment
    echo GitHub Actions will automatically deploy to Cloudflare Pages
    
) else if "%choice%"=="2" (
    echo.
    echo 🚀 Deploying directly with Wrangler...
    echo.
    
    wrangler pages deploy . --project-name=website
    
    if %errorlevel% equ 0 (
        echo.
        echo ✅ Site deployed successfully!
        echo Your site is now live at: https://website.pages.dev
    ) else (
        echo.
        echo ❌ Deployment failed
        echo Try: wrangler pages deploy . --project-name=stcoops-website
    )
    
) else if "%choice%"=="3" (
    echo.
    echo 📁 Manual upload instructions:
    echo.
    echo 1. Go to https://dash.cloudflare.com/
    echo 2. Click "Workers & Pages"
    echo 3. Click "Create" > "Pages" > "Upload assets"
    echo 4. Drag and drop your entire site folder
    echo 5. Click "Deploy site"
    echo.
    echo 💡 Tip: Create a ZIP file of your site first for easier upload
    
) else (
    echo Invalid choice. Please run the script again.
)

echo.
pause
