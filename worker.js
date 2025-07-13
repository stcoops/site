// Cloudflare Worker to handle contact form
export default {
  async fetch(request, env) {
    // Handle CORS for preflight requests
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': 'https://stcoops.com',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, X-Requested-With',
          'Access-Control-Max-Age': '86400',
        },
      });
    }

    // Only allow POST requests
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const formData = await request.formData();
      const name = formData.get('name')?.toString().trim();
      const email = formData.get('email')?.toString().trim();
      const message = formData.get('message')?.toString().trim();
      const honeypot = formData.get('honeypot')?.toString();

      // Honeypot check
      if (honeypot) {
        return new Response(JSON.stringify({ success: false, message: 'Bot detected.' }), {
          headers: { 'Content-Type': 'application/json' },
        });
      }

      // Validation
      if (!name || !email || !message) {
        return new Response(JSON.stringify({ success: false, message: 'All fields are required.' }), {
          headers: { 'Content-Type': 'application/json' },
        });
      }

      if (!isValidEmail(email)) {
        return new Response(JSON.stringify({ success: false, message: 'Please enter a valid email address.' }), {
          headers: { 'Content-Type': 'application/json' },
        });
      }

      if (message.length < 10 || message.length > 2000) {
        return new Response(JSON.stringify({ success: false, message: 'Message must be between 10 and 2000 characters.' }), {
          headers: { 'Content-Type': 'application/json' },
        });
      }

      // Rate limiting using Cloudflare KV (you'll need to bind this)
      const clientIP = request.headers.get('CF-Connecting-IP') || 'unknown';
      const rateKey = `rate_limit_${clientIP}`;
      
      if (env.RATE_LIMIT_KV) {
        const lastSubmission = await env.RATE_LIMIT_KV.get(rateKey);
        if (lastSubmission && Date.now() - parseInt(lastSubmission) < 60000) {
          return new Response(JSON.stringify({ success: false, message: 'Please wait before sending another message.' }), {
            headers: { 'Content-Type': 'application/json' },
          });
        }
      }

      // Send email using Cloudflare Email Workers or external service
      const emailData = {
        to: env.CONTACT_EMAIL || 'contact@stcoops.co.uk',
        from: env.FROM_EMAIL || 'noreply@stcoops.com',
        subject: 'Contact Form Submission from stcoops.com',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background-color: #007acc; color: white; padding: 20px; text-align: center;">
              <h2>New Contact Form Submission</h2>
            </div>
            <div style="padding: 20px; background-color: #f9f9f9;">
              <p><strong>Name:</strong> ${escapeHtml(name)}</p>
              <p><strong>Email:</strong> ${escapeHtml(email)}</p>
              <p><strong>Message:</strong></p>
              <p>${escapeHtml(message).replace(/\n/g, '<br>')}</p>
            </div>
            <div style="background-color: #333; color: white; padding: 10px; text-align: center; font-size: 12px;">
              <p>Sent from: ${request.headers.get('Host')} on ${new Date().toISOString()}</p>
              <p>IP Address: ${clientIP}</p>
            </div>
          </div>
        `
      };

      // Send email using MailChannels (free with Cloudflare Workers)
      try {
        await sendEmail(emailData);
        console.log('Email sent successfully');
      } catch (emailError) {
        console.error('Failed to send email:', emailError);
        // Continue anyway - don't fail the entire request
      }

      // Update rate limiting
      if (env.RATE_LIMIT_KV) {
        await env.RATE_LIMIT_KV.put(rateKey, Date.now().toString(), { expirationTtl: 3600 });
      }

      return new Response(JSON.stringify({ 
        success: true, 
        message: 'Thank you for your message! I\'ll get back to you soon.' 
      }), {
        headers: { 
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': 'https://stcoops.com'
        },
      });

    } catch (error) {
      console.error('Contact form error:', error);
      return new Response(JSON.stringify({ 
        success: false, 
        message: 'Sorry, there was an error sending your message. Please try again later.' 
      }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }
  },
};

// Function to send email using MailChannels (free with Cloudflare Workers)
async function sendEmail(emailData) {
  const mailChannelsEndpoint = 'https://api.mailchannels.net/tx/v1/send';
  
  const emailPayload = {
    personalizations: [
      {
        to: [{ email: emailData.to }],
        dkim_domain: 'stcoops.com',
        dkim_selector: 'mailchannels',
        dkim_private_key: env.DKIM_PRIVATE_KEY || undefined
      }
    ],
    from: {
      email: emailData.from,
      name: 'Contact Form'
    },
    subject: emailData.subject,
    content: [
      {
        type: 'text/html',
        value: emailData.html
      }
    ]
  };

  const response = await fetch(mailChannelsEndpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(emailPayload)
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`MailChannels API error: ${response.status} ${errorText}`);
  }

  return response;
}

function isValidEmail(email) {
  const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
  return emailRegex.test(email);
}

function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return text.replace(/[&<>"']/g, (m) => map[m]);
}
