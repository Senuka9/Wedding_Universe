<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";
    
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String seller = (String) session.getAttribute("username");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO decoration_services (name, description, price, rating, image, contact, location, category, features, season, status, owner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active', ?)"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(5, request.getParameter("image"));
            stmt.setString(6, request.getParameter("contact"));
            stmt.setString(7, request.getParameter("location"));
            stmt.setString(8, request.getParameter("category"));
            stmt.setString(9, request.getParameter("features")); // comma-separated tags
            stmt.setString(10, request.getParameter("season"));
            stmt.setString(11, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Decoration service added!" : "❌ Failed to add.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Decoration Seller Page</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            .navbar {
                background-color: white;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .nav-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 1rem;
                height: 4rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-family: serif;
                font-size: 1.5rem;
                color: #1a1a1a;
            }

            .nav-links {
                display: flex;
                align-items: center;
                gap: 2rem;
            }

            .nav-link {
                color: #666;
                text-decoration: none;
                transition: color 0.2s;
                font-size: 0.9rem;
            }

            .nav-link:hover, .nav-link.active {
                color: #1a1a1a;
            }

            .nav-link.active {
                font-weight: 600;
            }

            .account-btn {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
            }
            .form-container {
                max-width: 800px;
                margin: 30px auto;
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
            }

            input, select, textarea {
                width: 100%;
                padding: 10px;
                margin: 8px 0 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }

            button {
                background: var(--brown);
                color: white;
                padding: 10px;
                font-weight: bold;
                border: none;
                width: 100%;
                border-radius: 6px;
            }

            table {
                width: 95%;
                margin: 30px auto;
                background: white;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }

            th {
                background: var(--primary);
                color: white;
            }

            .disabled-link {
                pointer-events: none;
                opacity: 0.6;
                color: grey;
            }

            .message {
                text-align: center;
                font-weight: bold;
                color: green;
            }
        </style>
    </head>
    <body>
                <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Photography Seller</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="view_decoration_bookings.jsp" class="nav-link">View Bookings</a>
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
                            <a href="../logout.jsp" style="display: block; padding: 10px; text-decoration: none; color: black;" onmouseover="this.style.background = '#f0f0f0'" onmouseout="this.style.background = 'white'">Logout</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </nav><br>
        <div class="form-container">
            <h2>Add New Decoration Service</h2>
            <form method="post">
                <input type="text" name="name" placeholder="Decoration Name" required>
                <textarea name="description" placeholder="Decoration Description" required></textarea>
                <input type="number" step="0.01" name="price" placeholder="Price" required>
                <input type="number" step="0.1" name="rating" min="0" max="5" placeholder="Rating" required>
                <input type="text" name="image" placeholder="Image URL" required>
                <input type="text" name="contact" placeholder="Seller Contact" required>

                <label>Location</label>
                <select name="location" required>
                    <option value="Indoor">Indoor</option>
                    <option value="Outdoor">Outdoor</option>
                </select>

                <label>Category</label>
                <select name="category" required>
                    <option value="Elegant Themes">Elegant Themes</option>
                    <option value="Modern Designs">Modern Designs</option>
                    <option value="Garden Themes">Garden Themes</option>
                    <option value="Beach & Resort">Beach & Resort</option>
                </select>

                <label>Season</label>
                <select name="season" required>
                    <option value="all">All</option>
                    <option value="spring">Spring</option>
                    <option value="summer">Summer</option>
                    <option value="fall">Fall</option>
                    <option value="winter">Winter</option>
                </select>

                <label>Feature Tags (comma-separated)</label>
                <input type="text" name="features" placeholder="e.g. Crystal Details, Gold Accents, Premium Flowers" required>

                <button type="submit">Add Service</button>
            </form>

            <% if (!message.isEmpty()) { %>
            <div class="message"><%= message %></div>
            <% } %>
        </div>

        <%
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM decoration_services WHERE owner = '" + seller + "'");
        %>

        <div>
            <h3 style="text-align:center;">Your Decoration Listings</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Season</th>
                    <th>Status</th>
                    <th>View</th>
                    <th>Actions</th>
                </tr>

                <% while (rs.next()) {
                    String status = rs.getString("status");
                    boolean isActive = "active".equals(status);
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("category") %></td>
                    <td><%= rs.getString("season") %></td>
                    <td>
                        <%= isActive ? "✅" : "❌" %><br>
                        <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=<%= isActive ? "inactive" : "active" %>">
                            <%= isActive ? "Deactivate" : "Activate" %>
                        </a>
                    </td>
                    <td>
                        <% if (isActive) { %>
                        <a href="decoration_detail.jsp?id=<%= rs.getInt("id") %>">View</a>
                        <% } else { %>
                        <span class="disabled-link">View</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="update_decoration.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                        <a href="delete_decoration.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
                <% } rs.close(); stmt.close(); %>
            </table>
        </div>
                    <script>
            // Toggle dropdown
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
        </script>
    </body>
</html>
