const positions = [
    {
      title: 'Wedding Attire Specialist',
      location: 'On-site / Remote',
      description: 'Help brides and grooms choose the perfect attire for their big day.'
    },
    {
      title: 'Wedding Decoration Expert',
      location: 'On-site',
      description: 'Design and execute stunning wedding venue decorations tailored to couples’ themes.'
    },
    {
      title: 'Bridal Beautician',
      location: 'On-site',
      description: 'Provide professional beauty services for brides and bridal parties.'
    },
    {
      title: 'Wedding Photographer',
      location: 'On-site',
      description: 'Capture the magical moments of weddings with creative and high-quality photography.'
    },
    {
      title: 'Venue Manager',
      location: 'On-site',
      description: 'Coordinate wedding venues and ensure everything runs smoothly on the big day.'
    },
    {
      title: 'Wedding Car Chauffeur',
      location: 'On-site',
      description: 'Provide luxury and punctual wedding car services for couples.'
    },
    {
      title: 'Wedding Cake Designer',
      location: 'On-site / Remote',
      description: 'Craft and deliver exquisite wedding cakes that match the couple’s theme.'
    }
  ];
    
  function createPositionCard(position) {
    return `
      <div class="position-card">
        <h3>${position.title}</h3>
        <p class="position-location">${position.location}</p>
        <p>${position.description}</p>
        <button class="apply-btn">Apply Now</button>
      </div>
    `;
  }
  
  function initializePositions() {
    const positionsContainer = document.getElementById('positions');
    positionsContainer.innerHTML = positions.map(createPositionCard).join('');
    
    // Add click handlers for apply buttons
    document.querySelectorAll('.apply-btn').forEach((button, index) => {
      button.addEventListener('click', () => {
        window.location.href = 'index.html';
      });
    });
  }
  
  // Initialize the page
  document.addEventListener('DOMContentLoaded', initializePositions);