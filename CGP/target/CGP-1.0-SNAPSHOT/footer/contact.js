// Form handling
const form = document.getElementById('contactForm');
form.addEventListener('submit', (e) => {
  e.preventDefault();
  const formData = {
    name: document.getElementById('name').value,
    email: document.getElementById('email').value,
    message: document.getElementById('message').value
  };
  
  // Here you would typically send the data to a server
  console.log('Form submitted:', formData);
  alert('Thank you for your message! We will get back to you soon.');
  form.reset();
});