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