# Cloudflare Pages Deployment Guide

## 🚫 Issues with Current Setup
Your GitHub Action wasn't working because:
1. Missing `wrangler.toml` configuration file
2. PHP isn't supported on Cloudflare Pages (static hosting only)
3. Missing proper project structure
4. No error handling in the workflow

## ✅ What I've Fixed

### 1. Created `wrangler.toml`
- Proper Cloudflare Pages configuration
- URL redirects for clean URLs
- Security headers
- 404 handling

### 2. Updated GitHub Actions Workflow
- Added proper error handling
- Added Node.js setup
- Added verification steps
- Better logging

### 3. Contact Form Solution
Since Cloudflare Pages doesn't support PHP, I've created two solutions:

#### Option A: Cloudflare Worker (Recommended)
- Created `worker.js` - A Cloudflare Worker to handle contact form submissions
- Updated contact form to use `/api/contact` endpoint
- Includes rate limiting, validation, and security features

#### Option B: External Service Integration
- Use services like Netlify Forms, Formspree, or EmailJS
- Keep the current form structure but change the action URL

## � Deploying Your Static Site

### Method 1: GitHub Actions (Automated) - Recommended

Your GitHub Actions workflow is already set up! Here's what to do:

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Deploy site with contact form"
   git push origin main
   ```

2. **Check GitHub Actions:**
   - Go to your GitHub repository
   - Click on "Actions" tab
   - Watch the deployment process

3. **If it fails, check these:**
   - GitHub secrets are set correctly
   - Repository has the right permissions
   - `wrangler.toml` is in the root directory

### Method 2: Direct Wrangler Deploy

If GitHub Actions isn't working, deploy directly:

```bash
# Deploy pages directly
wrangler pages deploy . --project-name=website

# Or with custom project name
wrangler pages deploy . --project-name=stcoops-website
```

### Method 3: Cloudflare Dashboard (Manual)

1. **Go to Cloudflare Dashboard**
2. **Navigate to Workers & Pages**
3. **Click "Create" > "Pages" > "Upload assets"**
4. **Drag and drop your entire site folder**
5. **Click "Deploy site"**

## �🔧 Setup Instructions

### 1. GitHub Secrets
Add these secrets in your GitHub repository settings:
- `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token
- `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare account ID

### 2. Cloudflare Pages Setup
1. Go to Cloudflare Dashboard > Pages
2. Connect your GitHub repository
3. Set build settings:
   - Build command: (leave empty for static sites)
   - Build output directory: `.`
   - Root directory: `/`

### 3. For Contact Form (Worker Option)
1. Create a new Cloudflare Worker
2. Deploy the `worker.js` code
3. Set up route: `yoursite.com/api/contact`
4. Add KV namespace for rate limiting (optional)
5. Configure email service (SendGrid, Mailgun, etc.)

### 4. Test Deployment
1. Push to your main branch
2. Check GitHub Actions tab for deployment logs
3. Visit your Cloudflare Pages URL

## 📋 Checklist Before Deployment

- [ ] GitHub secrets configured
- [ ] Cloudflare Pages project created
- [ ] Worker deployed (if using contact form)
- [ ] DNS configured (if using custom domain)
- [ ] SSL/TLS enabled
- [ ] Test contact form functionality

## 🔍 Debugging Common Issues

### Deployment Fails
- Check GitHub Actions logs
- Verify secrets are set correctly
- Ensure `wrangler.toml` is in root directory

### Contact Form Not Working
- Check if Worker is deployed
- Verify Worker route is correct
- Check browser console for errors
- Test with curl or Postman

### Files Not Found
- Check `_redirects` file
- Verify file paths in HTML
- Check Cloudflare Pages build logs

## 🚀 Going Live

1. Add custom domain in Cloudflare Pages
2. Configure DNS records
3. Enable security features
4. Set up monitoring/analytics
5. Test everything thoroughly

## 📞 Support

If you encounter issues:
1. Check Cloudflare Pages logs
2. Review GitHub Actions output
3. Test locally with Wrangler CLI
4. Check browser developer tools
