// Add smooth scrolling for navigation links
document.querySelectorAll('.nav-link').forEach(link => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    const href = link.getAttribute('href');
    if (href === '#') {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    }
  });
});

// Add scroll effect to navbar
let prevScrollpos = window.pageYOffset;
window.onscroll = function() {
  const currentScrollPos = window.pageYOffset;
  if (prevScrollpos > currentScrollPos) {
    document.querySelector('.navbar').style.top = "0";
  } else {
    document.querySelector('.navbar').style.top = "-100px";
  }
  prevScrollpos = currentScrollPos;
}