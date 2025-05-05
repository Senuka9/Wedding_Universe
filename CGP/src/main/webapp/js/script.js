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

const services = {
        "attire": "Attire/attire_customer.jsp",
        "decoration": "Decoration/decoration_customer.jsp",
        "beautician": "Beautician/beautician_customer.jsp",
        "photography": "Photography/photography_customer.jsp",
        "venue": "Venue/venue_customer.jsp",
        "car": "Car/weddingcar_customer.jsp",
        "cake": "Cake/CAKE.jsp"
    };

    function showSuggestions() {
        const input = document.getElementById("searchBox");
        const dropdown = document.getElementById("suggestionsDropdown");
        const query = input.value.toLowerCase().trim();

        dropdown.innerHTML = "";
        if (query === "") {
            for (const name in services) {
                const item = document.createElement("div");
                item.innerText = capitalize(name);
                item.onclick = () => selectSuggestion(name);
                dropdown.appendChild(item);
            }
            dropdown.style.display = "block";
        } else {
            let found = false;
            for (const name in services) {
                if (name.startsWith(query)) {
                    const item = document.createElement("div");
                    item.innerText = capitalize(name);
                    item.onclick = () => selectSuggestion(name);
                    dropdown.appendChild(item);
                    found = true;
                }
            }
            dropdown.style.display = found ? "block" : "none";
        }
    }

    function selectSuggestion(serviceName) {
        document.getElementById("searchBox").value = capitalize(serviceName);
        document.getElementById("suggestionsDropdown").style.display = "none";
    }

    function redirectServicePage() {
        const input = document.getElementById("searchBox").value.trim().toLowerCase();
        if (services[input]) {
            window.location.href = services[input];
        } else {
            alert("Service not found. Please choose a valid one.");
        }
        return false; // prevent form submit
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    document.addEventListener("click", function (e) {
        const box = document.getElementById("suggestionsDropdown");
        if (!document.getElementById("searchBox").contains(e.target)) {
            box.style.display = "none";
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
