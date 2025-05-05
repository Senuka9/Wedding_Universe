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

    String id = request.getParameter("id");
    String seller = (String) session.getAttribute("username");
    String message = "";

    String name = "", description = "", duration = "", category = "", image = "", contact = "";
    double price = 0.0, rating = 0.0;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE beautician_services SET name=?, description=?, duration=?, price=?, rating=?, image=?, category=?, contact=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setString(3, request.getParameter("duration"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(6, request.getParameter("image"));
            stmt.setString(7, request.getParameter("category"));
            stmt.setString(8, request.getParameter("contact"));
            stmt.setString(9, id);
            stmt.setString(10, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Updated successfully!" : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM beautician_services WHERE id=? AND owner=?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            duration = rs.getString("duration");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            image = rs.getString("image");
            category = rs.getString("category");
            contact = rs.getString("contact");
        } else {
            out.println("<h3>❌ Service not found or you are not authorized to edit this.</h3>");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Beautician Service</title>
        <link rel="stylesheet" href="styles.css" />
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
                background: white;
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
                border-radius: 10px;
            }

            input, textarea, select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }

            button {
                background: var(--brown);
                color: white;
                padding: 12px;
                font-weight: bold;
                border: none;
                width: 100%;
                border-radius: 6px;
            }

            .message {
                text-align: center;
                margin-top: 15px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Update Details</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="beautician_seller.jsp" class="nav-link">Seller Page</a>
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
            <h2>Update Service</h2>
            <form method="post">
                <input type="text" name="name" value="<%= name %>" required>
                <textarea name="description" rows="3" required><%= description %></textarea>
                <input type="text" name="duration" value="<%= duration %>" required>
                <input type="number" step="0.01" name="price" value="<%= price %>" required>
                <input type="number" step="0.1" name="rating" min="0" max="5" value="<%= rating %>" required>
                <input type="text" name="image" value="<%= image %>" required>
                <input type="text" name="contact" value="<%= contact %>" required>

                <select name="category" required>
                    <option value="Bridal Makeup" <%= category.equals("Bridal Makeup") ? "selected" : "" %>>Bridal Makeup</option>
                    <option value="Hair Styling" <%= category.equals("Hair Styling") ? "selected" : "" %>>Hair Styling</option>
                    <option value="Bridesmaid Packages" <%= category.equals("Bridesmaid Packages") ? "selected" : "" %>>Bridesmaid Packages</option>
                    <option value="Family Packages" <%= category.equals("Family Packages") ? "selected" : "" %>>Family Packages</option>
                </select>

                <button type="submit">Update Service</button>
            </form>

            <% if (!message.isEmpty()) { %>
            <div class="message"><%= message %></div>
            <% } %>

            <a href="beautician_seller.jsp">← Back to Seller Page</a>
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
