// Initialize search functionality
const searchInput = document.querySelector('#searchHelp');
const helpCards = document.querySelectorAll('.help-card');

searchInput.addEventListener('input', (e) => {
  const searchTerm = e.target.value.toLowerCase();
  
  helpCards.forEach(card => {
    const title = card.querySelector('h3').textContent.toLowerCase();
    const description = card.querySelector('p').textContent.toLowerCase();
    
    if (title.includes(searchTerm) || description.includes(searchTerm)) {
      card.style.display = 'block';
    } else {
      card.style.display = 'none';
    }
  });
});

// Add click handlers for help cards
document.querySelectorAll('.view-help-btn').forEach(button => {
  button.addEventListener('click', (e) => {
    const category = e.target.closest('.help-card').querySelector('h3').textContent;
    alert(`Viewing help for: ${category}`);
    // In a real application, this would navigate to the specific help category page
  });
});