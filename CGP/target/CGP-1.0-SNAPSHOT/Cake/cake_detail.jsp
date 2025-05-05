<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../db.jsp" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dream Weddings - Cake Details</title>
        <link rel="stylesheet" href="cake_detail.css">
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link active">Home</a>
                    <div class="search-container">
                        <input type="text" placeholder="Search services..." class="search-input">
                        <i class="lucide lucide-search search-icon"></i>
                    </div>
                        <% if (role == null) { %>
                            <!-- 👤 Login Icon Button (when logged out) -->
                            <a href="login.jsp">
                                <button class="account-btn" title="Login">👤</button>
                            </a>
                        <% } else { %>
                            <!-- User Dropdown (when logged in) -->
                            <div style="position: relative;">
                                <button class="account-btn" id="userDropdownBtn">👤</button>
                                <div id="userDropdownMenu" style="display: none; position: absolute; right: 0; top: 35px; background-color: white; box-shadow: 0 2px 6px rgba(0,0,0,0.2); border-radius: 5px; width: 150px;">
                                    <div style="padding: 10px; border-bottom: 1px solid #eee;">
                                        <strong><%= loggedUser %></strong><br>
                                        <small><%= role %></small>
                                    </div>
                                    <a href="#" style="display: block; padding: 10px; text-decoration: none; color: black;" onmouseover="this.style.background = '#f0f0f0'" onmouseout="this.style.background = 'white'">Settings</a>
                                    <a href="logout.jsp" style="display: block; padding: 10px; text-decoration: none; color: black;" onmouseover="this.style.background = '#f0f0f0'" onmouseout="this.style.background = 'white'">Logout</a>
                                </div>
                            </div>
                        <% } %>
                </div>
            </div>
        </nav>
        <main class="main">
            <div class="container">
                <%
                  String cakeId = request.getParameter("id");
                  if (cakeId == null || conn == null) {
                %>
                <p style="color:red; text-align:center;">Error loading cake details. Please try again.</p>
                <%
                  } else {
                    try {
                      Statement stmt = conn.createStatement();
                      ResultSet rs = stmt.executeQuery("SELECT * FROM cakes WHERE id = " + cakeId);
                      if (rs.next()) {
                        String name = rs.getString("name");
                        String description = rs.getString("description");
                        double price = rs.getDouble("price");
                        double rating = rs.getDouble("rating");
                        String image = rs.getString("image");
                        String contact = rs.getString("contact");
                %>
                <div class="product-grid">
                    <div class="gallery">
                        <div class="main-image-container">
                            <img id="mainImage" src="<%= image %>" alt="<%= name %>" class="main-image">
                            <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>
                            </svg>
                            </button>
                        </div>
                    </div>
                    <div class="product-details">
                        <div class="product-header">
                            <h1><%= name %></h1>
                            <div class="rating">
                                <div class="stars">⭐ <%= rating %></div>
                                <span class="review-count">(Based on reviews)</span>
                            </div>
                        </div>
                        <div class="price">RS. <%= rs.getDouble("price") %></div>
                        <p class="description"><%= description %></p>
                        <p><strong>Contact Seller:</strong> <%= contact %></p>
                        <div class="delivery-info">
                            <svg class="truck-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 18H3c-.6 0-1-.4-1-1V7c0-.6.4-1 1-1h10c.6 0 1 .4 1 1v11"/>
                            <path d="M14 9h4l4 4v4c0 .6-.4 1-1 1h-2"/>
                            <circle cx="7" cy="18" r="2"/>
                            <path d="M15 18H9"/>
                            <circle cx="17" cy="18" r="2"/>
                            </svg>
                            <div>
                                <h4>Delivery Information</h4>
                                <p>Estimated delivery: 2-3 weeks from order confirmation.<br>Free delivery within 25 miles of our bakery.</p>
                            </div>
                        </div>
                            <form method="post" action="../CakeCartServlet">
                                <input type="hidden" name="action" value="add" />
                                <input type="hidden" name="cakeId" value="<%= rs.getInt("id") %>" />
                                <input type="hidden" name="cakeName" value="<%= rs.getString("name") %>" />
                                <input type="hidden" name="price" value="<%= rs.getDouble("price") %>" />
                                <input type="hidden" name="image" value="<%= rs.getString("image") %>" />
                                <button type="submit" class="add-to-cart-btn">🛒 Add to Cart</button>
                            </form>

                    </div>
                </div>
                <%
                      } else {
                %>
                <p style="text-align:center;">Cake not found.</p>
                <%
                      }
                      rs.close();
                      stmt.close();
                    } catch (Exception e) {
                      out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
                    }
                  }
                %>
            </div>
        </main>
        <script src="cake_detail.js"></script>
    </body>
</html>
