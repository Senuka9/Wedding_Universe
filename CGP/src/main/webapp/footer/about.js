/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// Testimonials data
const testimonials = [
  {
    quote: "Dream Weddings made our special day absolutely perfect. Their attention to detail and dedication was outstanding!",
    couple: "Sarah & James",
    date: "March 2024"
  },
  {
    quote: "We couldn't have asked for better planners. They turned our vision into reality with such grace and professionalism.",
    couple: "Emily & Michael",
    date: "January 2024"
  },
  {
    quote: "The team's creativity and organization skills made our wedding planning journey stress-free and enjoyable.",
    couple: "Jessica & David",
    date: "February 2024"
  }
];

// Testimonial functionality
let currentTestimonial = 0;
const testimonialContent = document.getElementById('testimonialContent');
const prevButton = document.getElementById('prevButton');
const nextButton = document.getElementById('nextButton');

function updateTestimonial() {
  const testimonial = testimonials[currentTestimonial];
  testimonialContent.innerHTML = `
    <p style="font-style: italic; margin-bottom: 1rem; color: #666;">"${testimonial.quote}"</p>
    <p style="font-size: 1.2rem; margin-bottom: 0.5rem;">${testimonial.couple}</p>
    <p style="font-size: 0.9rem; color: #666;">${testimonial.date}</p>
  `;
}

prevButton.addEventListener('click', () => {
  currentTestimonial = (currentTestimonial - 1 + testimonials.length) % testimonials.length;
  updateTestimonial();
});

nextButton.addEventListener('click', () => {
  currentTestimonial = (currentTestimonial + 1) % testimonials.length;
  updateTestimonial();
});

// Initialize first testimonial
updateTestimonial();