var banner = document.getElementById("wip-banner")
if (banner) {
        banner.addEventListener("click", function() {
        document.getElementById("wip-banner").id = "wip-banner-fade-out";
        });
};



var banner = document.getElementById("wip-banner-mobile")
if (banner) {
        banner.addEventListener("click", function() {

  document.getElementById("wip-banner-mobile").id = "wip-banner-fade-out-mobile";
  });
};



const events = document.querySelectorAll('.timeline-event');
if (events) {
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      } else {
        entry.target.classList.remove('visible');
      }
    });
  }, {
    threshold: 0.6
  });


  document.addEventListener('DOMContentLoaded', function () {
    events.forEach(event => {
      observer.observe(event);
    });
  });
};
/*
document.getElementById("submit").addEventListener("click", function() {
  fields.name = document.getElementById('name');
  fields.email = document.getElementById('email');
  fields.message = document.getElementById('message');
})

class User {
  constructor(firstName, lastName, gender, address, country, email, newsletter, question) {
  this.firstName = firstName;
  this.lastName = lastName;
  this.gender = gender;
  this.address = address;
  this.country = country;
  this.email = email;
  this.newsletter = newsletter;
  this.question = question;
  }
 }




function isNotEmpty(value) {
  if (value == null || typeof value == 'undefined' ) return false;
  return (value.length > 0);
}

function isEmail(email) {
  let regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
  return regex.test(String(email).toLowerCase());
}

function isValid() {
  var valid = true;
  
  valid &= fieldValidation(fields.name, isNotEmpty);
  valid &= fieldValidation(fields.email, isEmail);
  valid &= fieldValidation(fields.message, isNotEmpty);
 
  return valid;
 }

*/

// Contact Form Handler
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contact-form');
    const submitBtn = document.getElementById('submit-btn');
    const responseDiv = document.getElementById('form-response');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.value = 'Sending...';
            
            // Basic client-side validation
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const message = document.getElementById('message').value.trim();
            
            if (!name || !email || !message) {
                showResponse('Please fill in all required fields.', 'error');
                resetSubmitButton();
                return;
            }
            
            if (!isValidEmail(email)) {
                showResponse('Please enter a valid email address.', 'error');
                resetSubmitButton();
                return;
            }
            
            if (message.length < 10) {
                showResponse('Message must be at least 10 characters long.', 'error');
                resetSubmitButton();
                return;
            }
            
            // Create FormData object
            const formData = new FormData(contactForm);
            
            // Send AJAX request to Cloudflare Worker
            fetch('/api/contact', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showResponse(data.message, 'success');
                    contactForm.reset();
                } else {
                    showResponse(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showResponse('Sorry, there was an error sending your message. Please try again later.', 'error');
            })
            .finally(() => {
                resetSubmitButton();
            });
        });
    }
    
    // Helper functions
    function isValidEmail(email) {
        const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
        return emailRegex.test(email);
    }
    
    function showResponse(message, type) {
        responseDiv.innerHTML = message;
        responseDiv.className = type === 'success' ? 'success-message' : 'error-message';
        responseDiv.style.display = 'block';
        
        // Auto-hide success messages after 5 seconds
        if (type === 'success') {
            setTimeout(() => {
                responseDiv.style.display = 'none';
            }, 5000);
        }
        
        // Scroll to response message
        responseDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    
    function resetSubmitButton() {
        submitBtn.disabled = false;
        submitBtn.value = 'Send Message';
    }
});