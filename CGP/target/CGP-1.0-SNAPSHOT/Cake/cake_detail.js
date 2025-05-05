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

// DOM Elements
const mainImage = document.getElementById('mainImage');
const thumbnails = document.querySelectorAll('.thumbnail');
const sizeBtns = document.querySelectorAll('.size-btn');
const toppingCheckboxes = document.querySelectorAll('input[name="topping"]');
const totalPriceElement = document.getElementById('totalPrice');



// State
let currentPrice = 399; // Default medium size price
let selectedToppings = new Set();
let isWishlisted = false;

// Image Gallery
thumbnails.forEach(thumbnail => {
    thumbnail.addEventListener('click', () => {
        // Update main image
        mainImage.src = thumbnail.dataset.image;

        // Update active state
        thumbnails.forEach(t => t.classList.remove('active'));
        thumbnail.classList.add('active');
    });
});


// Size Selection
sizeBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        // Update active state
        sizeBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        // Update base price
        currentPrice = parseInt(btn.dataset.price);
        updateTotalPrice();
    });
});


// Toppings Selection
toppingCheckboxes.forEach(checkbox => {
    checkbox.addEventListener('change', () => {
        const price = parseInt(checkbox.dataset.price);
        if (checkbox.checked) {
            selectedToppings.add(price);
        } else {
            selectedToppings.delete(price);
        }
        updateTotalPrice();
    });
});

// Update Total Price
function updateTotalPrice() {
    const toppingsTotal = Array.from(selectedToppings).reduce((sum, price) => sum + price, 0);
    const total = currentPrice + toppingsTotal;
    totalPriceElement.textContent = `$${total}`;
}

// Initialize
updateTotalPrice();