# 🚀 Cloudflare Worker Deployment Guide

## Prerequisites

1. **Node.js installed** (version 16 or higher)
2. **Cloudflare account** with a domain (free plan works)
3. **Wrangler CLI** (we'll install this)

## Step-by-Step Deployment

### 1. Install Wrangler CLI

```bash
# Install globally
npm install -g wrangler

# Or if you prefer yarn
yarn global add wrangler
```

### 2. Authenticate with Cloudflare

```bash
# Login to Cloudflare
wrangler login

# Verify authentication
wrangler whoami
```

### 3. Deploy the Worker

#### Option A: Using the deployment script
```bash
# On Windows
./deploy-worker.bat

# On Linux/Mac
chmod +x deploy-worker.sh
./deploy-worker.sh
```

#### Option B: Manual deployment
```bash
# Deploy using the worker config
wrangler deploy --config wrangler-worker.toml

# Or deploy with custom name
wrangler deploy worker.js --name contact-form-worker
```

### 4. Set up Domain Routing

#### Option A: Using Routes (Recommended)
1. Go to Cloudflare Dashboard
2. Select your domain (stcoops.com)
3. Go to Workers & Pages > Overview
4. Find your worker and click "Add Custom Domain"
5. Add route: `stcoops.com/api/contact`

#### Option B: Using Wrangler
```bash
# Add route via CLI
wrangler route add "stcoops.com/api/contact" contact-form-worker
```

### 5. Optional: Set up KV Namespace for Rate Limiting

```bash
# Create KV namespace
wrangler kv:namespace create "RATE_LIMIT_KV"

# Create preview namespace
wrangler kv:namespace create "RATE_LIMIT_KV" --preview
```

Then update `wrangler-worker.toml`:
```toml
[[kv_namespaces]]
binding = "RATE_LIMIT_KV"
id = "your-namespace-id-here"
preview_id = "your-preview-namespace-id-here"
```

### 6. Optional: Add Email Secrets

```bash
# Add secrets for email configuration
wrangler secret put CONTACT_EMAIL
wrangler secret put FROM_EMAIL
wrangler secret put DKIM_PRIVATE_KEY  # For better email delivery
```

## Testing the Deployment

### Test with curl:
```bash
curl -X POST https://stcoops.com/api/contact \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "name=Test&email=test@example.com&message=This is a test message"
```

### Test with browser:
1. Go to your website
2. Fill out the contact form
3. Submit and check for success message
4. Check your email for the message

## Monitoring and Debugging

### View logs:
```bash
# Tail worker logs
wrangler tail contact-form-worker

# View recent logs
wrangler logs contact-form-worker
```

### Check deployment status:
```bash
# List all workers
wrangler list

# Get worker details
wrangler status contact-form-worker
```

## Common Issues and Solutions

### ❌ **"Worker not found"**
- Check if deployment was successful
- Verify worker name in dashboard
- Try redeploying

### ❌ **"Route not working"**
- Check route configuration in Cloudflare dashboard
- Verify DNS is proxied through Cloudflare
- Wait a few minutes for propagation

### ❌ **"Email not sending"**
- Check MailChannels is working
- Verify DKIM configuration
- Check worker logs for errors

### ❌ **"CORS errors"**
- Update CORS origins in worker.js
- Check request headers
- Verify preflight handling

## Alternative Email Services

If MailChannels doesn't work, you can integrate other services:

### SendGrid:
```javascript
const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${env.SENDGRID_API_KEY}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(sendGridPayload)
});
```

### Mailgun:
```javascript
const response = await fetch('https://api.mailgun.net/v3/your-domain.com/messages', {
  method: 'POST',
  headers: {
    'Authorization': `Basic ${btoa(`api:${env.MAILGUN_API_KEY}`)}`,
  },
  body: formData
});
```

## Production Checklist

- [ ] Worker deployed successfully
- [ ] Custom domain route configured
- [ ] Email sending works
- [ ] Rate limiting enabled
- [ ] Error handling tested
- [ ] CORS configured correctly
- [ ] Monitoring set up
- [ ] Backup email method configured

## Support

If you run into issues:
1. Check the Cloudflare Workers documentation
2. Review worker logs with `wrangler tail`
3. Test locally with `wrangler dev`
4. Check the Cloudflare community forums
