#!/bin/bash

# Deploy Cloudflare Worker - Linux/Mac Script
echo "🚀 Deploying Cloudflare Worker..."

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "Installing Wrangler CLI..."
    npm install -g wrangler
fi

# Login to Cloudflare (if not already logged in)
echo "Checking Cloudflare authentication..."
wrangler whoami || wrangler login

# Deploy the worker
echo "Deploying worker..."
wrangler deploy --config wrangler-worker.toml

# Check deployment status
if [ $? -eq 0 ]; then
    echo "✅ Worker deployed successfully!"
    echo "Your contact form endpoint is now available at:"
    echo "https://contact-form-worker.yourusername.workers.dev/"
    echo "Or at your custom domain: https://stcoops.com/api/contact"
else
    echo "❌ Deployment failed. Check the error messages above."
fi

echo "🔧 Next steps:"
echo "1. Test the worker endpoint"
echo "2. Configure your domain routing"
echo "3. Set up KV namespace for rate limiting (optional)"
echo "4. Add email secrets if needed"
