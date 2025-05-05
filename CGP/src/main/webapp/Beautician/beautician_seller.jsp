<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";


    if (role == null || (!role.equals("seller") && !role.equals("admin"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String seller = (String) session.getAttribute("username");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO beautician_services (name, description, duration, price, rating, image, category, contact, owner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setString(3, request.getParameter("duration"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(6, request.getParameter("image"));
            stmt.setString(7, request.getParameter("category"));
            stmt.setString(8, request.getParameter("contact"));
            stmt.setString(9, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Service added successfully!" : "❌ Failed to add service.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Beautician Services - Seller</title>
        <link rel="stylesheet" href="../styles.css" />
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: #f5f5f5;
                margin: 0; /* remove default margin */
                padding: 0; /* remove default padding */
                overflow-y: auto;
                padding-bottom: 120px; /* keep this for spacing below */
            }

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
                background: white;
                padding: 30px;
                border-radius: 10px;
                width: 600px;
                margin: auto;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
                margin-bottom: 80px;
            }

            input, select, textarea {
                width: 100%;
                padding: 10px;
                font-size: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                margin-bottom: 15px;
            }

            button {
                width: 100%;
                background-color: #5C4033; /* replaced var(--brown) with brown hex */
                color: white;
                padding: 12px;
                font-size: 16px;
                font-weight: bold;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }


            .message {
                margin-top: 15px;
                text-align: center;
                font-weight: bold;
                color: green;
            }

            table {
                width: 90%;
                margin: 40px auto;
                background: white;
                border-collapse: collapse;
                border: 1px solid #ccc;
            }

            th, td {
                padding: 12px;
                border: 1px solid #ccc;
                text-align: center;
            }

            th {
                background: #0099cc;
                color: white;
            }

            .status-icon {
                font-size: 18px;
            }

            .icon-green {
                color: green;
            }

            .icon-grey {
                color: grey;
            }

            a.disabled-link {
                pointer-events: none;
                opacity: 0.5;
                color: grey;
            }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Beautician Seller</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="view_bookings.jsp" class="nav-link">View Bookings</a>
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
            <h2>Add Beautician Service</h2>
            <form method="post">
                <input type="text" name="name" placeholder="Service Name" required>
                <textarea name="description" rows="3" placeholder="Description..." required></textarea>
                <input type="text" name="duration" placeholder="e.g. 1 hour" required>
                <input type="number" step="0.01" name="price" placeholder="Price" required>
                <input type="number" step="0.1" name="rating" min="0" max="5" placeholder="Rating" required>
                <input type="text" name="image" placeholder="Image URL" required>
                <input type="text" name="contact" placeholder="Contact (07X...)" required>

                <select name="category" required>
                    <option value="" disabled selected>Choose Category</option>
                    <option value="Bridal Makeup">Bridal Makeup</option>
                    <option value="Hair Styling">Hair Styling</option>
                    <option value="Bridesmaid Packages">Bridesmaid Packages</option>
                    <option value="Family Packages">Family Packages</option>
                </select>

                <div style="text-align:center; margin-top: 20px;">
                    <button type="submit">Add Service</button>
                </div>

            </form>

            <% if (!message.isEmpty()) { %>
            <div class="message"><%= message %></div>
            <% } %>
        </div>

        <%
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM beautician_services WHERE owner = '" + seller + "'");
        %>

        <div>
            <h3 style="text-align:center;">Your Beautician Services</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Details</th>
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
                    <td>
                        <% if (isActive) { %>
                        <span class="status-icon icon-green">✅</span>
                        <% } else { %>
                        <span class="status-icon icon-grey">❌</span>
                        <% } %><br>
                        <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=<%= isActive ? "inactive" : "active" %>">
                            <%= isActive ? "Deactivate" : "Activate" %>
                        </a>
                    </td>
                    <td>
                        <% if (isActive) { %>
                        <a href="beautician_detail.jsp?id=<%= rs.getInt("id") %>">View</a>
                        <% } else { %>
                        <a href="#" class="disabled-link">View</a>
                        <% } %>
                    </td>
                    <td>
                        <a href="update_beautician.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                        <a href="delete_beautician.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
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