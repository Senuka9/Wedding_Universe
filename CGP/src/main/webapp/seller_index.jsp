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

        <div class="services" id="services">
            <h2>Our Services</h2>
            <div class="services-grid">
                <a href="Attire/attire_seller.jsp">
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
                <a href="Decoration/decoration_seller.jsp">
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
                <a href="Beautician/beautician_seller.jsp">
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
                <a href="Photography/photography_seller.jsp">
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
                <a href="Venue/venue_seller.jsp">
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
                <a href="Car/car_seller.jsp">
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
                <a href="Cake/cake_seller.jsp">
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
        <script src="https://unpkg.com/lucide-web"></script>
        <script src="js/script.js"></script>
    </body>
</html>
