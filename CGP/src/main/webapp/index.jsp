<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dream Weddings</title>
        <link rel="stylesheet" href="css/styles.css">
        <link href="https://unpkg.com/lucide-web/dist/umd/lucide.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="#" class="nav-link active">Home</a>
                    <a href="#services" class="nav-link">Services</a>

                    <div class="search-container">
                        <form id="serviceSearchForm" onsubmit="return redirectServicePage();">
                            <div class="search-wrapper" style="position: relative;">
                                <input type="text" id="searchBox" placeholder="Search services..." oninput="showSuggestions()" onclick="showSuggestions()" autocomplete="off" />
                                <button type="submit" class="search-btn"><i class="fas fa-search"></i></button>
                                <div id="suggestionsDropdown" class="suggestions-box"></div>
                            </div>
                        </form>
                    </div>


                    <% if (role == null) { %>
                    <!-- 👤 Login Button (when not logged in) -->
                    <a href="login.jsp" title="Login">
                        <button class="account-btn">👤</button>
                    </a>
                    <% } else { %>
                    <!-- 👤 Dropdown Button (when logged in) -->
                    <div style="position: relative;">
                        <button class="account-btn" id="userDropdownBtn">👤</button>
                        <div id="userDropdownMenu" class="user-dropdown">
                            <div class="user-info">
                                <strong><%= username %></strong><br>
                                <small><%= role %></small>
                            </div>
                            <a href="#" class="dropdown-link">Settings</a>
                            <a href="logout.jsp" class="dropdown-link">Logout</a>
                        </div>
                    </div>
                    <% } %>

                </div>
            </div>
        </nav>

        <div class="hero">
            <div class="hero-content">
                <h2>Your Perfect Day Begins Here</h2>
                <p>Let us help you create the wedding of your dreams with our comprehensive planning services. Every detail crafted to perfection.</p>
                <a href="#services"><button class="cta-button">Start Planning</button></a>
            </div>
        </div>

        <div class="services" id="services">
            <h2>Our Services</h2>
            <div class="services-grid">
                <a href="Attire/attire_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.pexels.com/photos/4982191/pexels-photo-4982191.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" alt="Wedding Attire">
                        </div>
                        <div class="service-content">
                            <h3>Wedding Attire</h3>
                            <p>Exclusive collection of wedding dresses and suits</p>
                        </div>
                    </div>
                </a>
                <a href="Decoration/decoration_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.unsplash.com/photo-1519225421980-715cb0215aed?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Decoration">
                        </div>
                        <div class="service-content">
                            <h3>Decoration</h3>
                            <p>Beautiful wedding decoration services</p>
                        </div>
                    </div>
                </a>
                <a href="Beautician/beautician_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Beautician">
                        </div>
                        <div class="service-content">
                            <h3>Beautician</h3>
                            <p>Professional makeup and hair styling</p>
                        </div>
                    </div>
                </a>
                <a href="Photography/photography_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.unsplash.com/photo-1537633552985-df8429e8048b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Photography">
                        </div>
                        <div class="service-content">
                            <h3>Photography</h3>
                            <p>Capture your special moments</p>
                        </div>
                    </div>
                </a>
                <a href="Venue/venue_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.unsplash.com/photo-1519167758481-83f550bb49b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Venue">
                        </div>
                        <div class="service-content">
                            <h3>Venue</h3>
                            <p>Luxurious hotels and venues</p>
                        </div>
                    </div>
                </a>
                <a href="Car/weddingcar_customer.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://i0.wp.com/wiwaha.com/wp-content/uploads/listing-uploads/gallery/2020/04/94105776_120307406296380_352456659966099456_o.jpg?fit=1000%2C666&ssl=1" alt="Wedding Cars">
                        </div>
                        <div class="service-content">
                            <h3>Wedding Cars</h3>
                            <p>Luxury vehicles for your special day</p>
                        </div>
                    </div>
                </a>
                <a href="Cake/CAKE.jsp">
                    <div class="service-card">
                        <div class="service-image">
                            <img src="https://images.unsplash.com/photo-1535254973040-607b474cb50d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Wedding Cake">
                        </div>
                        <div class="service-content">
                            <h3>Wedding Cake</h3>
                            <p>Custom designed wedding cakes</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <footer class="site-footer">
            <div class="footer-content">
                <div class="footer-logo">
                    <h2>Dream Wedding</h2>
                    <p>Your perfect wedding starts here</p>
                </div>
                <div class="footer-links">
                    <div class="footer-section">
                        <h3>Company</h3>
                        <ul>
                            <li><a href="footer/Aboutus.html">About Us</a></li>
                            <li><a href="footer/Careers.html">Careers</a></li>
                            <li><a href="footer/Contactus.html">Contact Us</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Support</h3>
                        <ul>
                            <li><a href="footer/FAQ.html">FAQ</a></li>
                            <li><a href="footer/Helpcenter.html">Help Center</a></li>
                            <li><a href="footer/TOS.html">Terms of Service</a></li>
                            <li><a href="footer/Privacypolicy.html">Privacy Policy</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h3>Connect</h3>
                        <div class="social-links">
                            <a href="https://facebook.com"><i class="fab fa-facebook-f"></i></a>
                            <a href="https://twitter.com"><i class="fab fa-twitter"></i></a>
                            <a href="https://instagram.com"><i class="fab fa-instagram"></i></a>
                            <a href="https://youtube.com"><i class="fab fa-youtube"></i></a>
                        </div>
                        <div class="app-links">
                            <a href="https://www.apple.com/" class="app-btn">
                                <i class="fab fa-apple"></i>
                                <span>App Store</span>
                            </a>
                            <a href="https://play.google.com/" class="app-btn">
                                <i class="fab fa-google-play"></i>
                                <span>Google Play</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 DreamWedding. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://unpkg.com/lucide-web"></script>
        <script src="js/script.js"></script>
    </body>
</html>
