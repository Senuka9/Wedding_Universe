// User dropdown toggle
document.addEventListener("DOMContentLoaded", function () {
    const userBtn = document.getElementById("userDropdownBtn");
    const menu = document.getElementById("userDropdownMenu");

    if (userBtn && menu) {
        userBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });

        document.addEventListener("click", function () {
            menu.style.display = "none";
        });
    }
});

// Initialize Lucide icons
lucide.createIcons();

// Add smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Search functionality
const searchInput = document.querySelector('.search-input');
searchInput.addEventListener('input', (e) => {
    const searchTerm = e.target.value.toLowerCase();
    const serviceCards = document.querySelectorAll('.service-card');

    serviceCards.forEach(card => {
        const title = card.querySelector('h3').textContent.toLowerCase();
        const description = card.querySelector('p').textContent.toLowerCase();

        if (title.includes(searchTerm) || description.includes(searchTerm)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
});

// Add intersection observer for smooth fade-in animations
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('fade-in');
        }
    });
}, {
    threshold: 0.1
});

document.querySelectorAll('.service-card').forEach(card => {
    observer.observe(card);
});

// Active link highlighting
const navLinks = document.querySelectorAll('.nav-link');
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        navLinks.forEach(l => l.classList.remove('active'));
        link.classList.add('active');
    });
});