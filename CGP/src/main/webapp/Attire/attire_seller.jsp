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
%>


<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        String rating = request.getParameter("rating");
        String image = request.getParameter("image");
        String contact = request.getParameter("contact");
        String sellerUsername = (String) session.getAttribute("username");

        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO attire (name, gender, category, price, rating, image, contact, owner) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, name);
            stmt.setString(2, gender);
            stmt.setString(3, category);
            stmt.setDouble(4, Double.parseDouble(price));
            stmt.setDouble(5, Double.parseDouble(rating));
            stmt.setString(6, image);
            stmt.setString(7, contact);
            stmt.setString(8, sellerUsername);

            int result = stmt.executeUpdate();
            message = (result > 0) ? "✅ Attire added successfully." : "❌ Error adding attire.";
            stmt.close();
        } catch (Exception e) {
            message = "⚠️ Error: " + e.getMessage();
        }
    }
%>

<html>
    <head>
        <title>Seller Page - Add Attire</title>
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
                padding: 30px;
                margin: 30px auto;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                width: 420px;
            }

            .form-container input, .form-container select, .form-container textarea {
                width: 100%;
                margin-bottom: 15px;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .form-container button {
                background: #28a745;
                color: white;
                padding: 10px;
                width: 100%;
                border: none;
                font-weight: bold;
                border-radius: 4px;
            }

            table {
                margin: 20px auto;
                width: 90%;
                background: white;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: center;
            }

            th {
                background: #0099cc;
                color: white;
            }

            #imagePreview {
                display: none;
                margin-top: 10px;
                max-width: 100%;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Photography Seller</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="attire_booking_view.jsp" class="nav-link">View Bookings</a>
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
            <h2>Add Wedding Attire</h2>
            <form method="post">
                <label>Name:</label>
                <input type="text" name="name" required>

                <label>Gender:</label>
                <select name="gender" required>
                    <option value="Women">Women</option>
                    <option value="Men">Men</option>
                </select>

                <label>Category:</label>
                <select name="category" id="category" required>
                    <option value="Bridal Gowns">Bridal Gowns</option>
                    <option value="Flower Girl Dresses">Flower Girl Dresses</option>
                    <option value="Groom Suits">Groom Suits</option>
                    <option value="Ring Bearer Outfits">Ring Bearer Outfits</option>
                </select>

                <label>Price:</label>
                <input type="number" step="0.01" name="price" required>

                <label>Rating (0.0 - 5.0):</label>
                <input type="number" step="0.1" name="rating" min="0" max="5" required>

                <label>Contact Number:</label>
                <input type="text" name="contact" id="contact" maxlength="10" required placeholder="07X XXX XXXX">
                <span id="contactError" style="color:red; display:none;">Must start with 07 and be 10 digits.</span>

                <label>Image URL:</label>
                <input type="text" name="image" id="imageURL" required>
                <img id="imagePreview" alt="Image Preview" />

                <button type="submit">Add Attire</button>
            </form>

            <% if (!message.isEmpty()) { %>
            <div class="message"><%= message %></div>
            <% } %>
        </div>

        <%
            String seller = (String) session.getAttribute("username");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM attire WHERE owner = '" + seller + "'");
        %>

        <div>
            <h3 style="text-align:center;">Your Attire Listings</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Gender</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("category") %></td>
                    <td><%= rs.getString("gender") %></td>
                    <td>$<%= rs.getDouble("price") %></td>
                    <td>
                        <%= rs.getString("status") %><br>
                        <% if (rs.getString("status").equals("active")) { %>
                            <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=inactive">Deactivate</a>
                        <% } else { %>
                            <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=active">Activate</a>
                        <% } %>
                    </td>

                    <td>
                        <a href="update_attire.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                        <a href="delete_attire.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
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
            
            const categoriesByGender = {
                Men: ["Groom Suits", "Ring Bearer Outfits"],
                Women: ["Bridal Gowns", "Flower Girl Dresses"]
            };

            const genderSelect = document.querySelector("select[name='gender']");
            const categorySelect = document.getElementById("category");

            function updateCategoryOptions() {
                const selectedGender = genderSelect.value;
                const categories = categoriesByGender[selectedGender] || [];

                categorySelect.innerHTML = "";

                categories.forEach(cat => {
                    const option = document.createElement("option");
                    option.value = cat;
                    option.textContent = cat;
                    categorySelect.appendChild(option);
                });
            }

            genderSelect.addEventListener("change", updateCategoryOptions);
            document.addEventListener("DOMContentLoaded", updateCategoryOptions);
            const imageURLInput = document.getElementById("imageURL");
            const imagePreview = document.getElementById("imagePreview");

            imageURLInput.addEventListener("input", function () {
                const url = this.value.trim();
                imagePreview.src = url;
                imagePreview.style.display = url.length > 5 ? "block" : "none";
            });

            const contactInput = document.getElementById("contact");
            const contactError = document.getElementById("contactError");

            document.querySelector("form").addEventListener("submit", function (e) {
                let raw = contactInput.value.replace(/\D/g, "");
                const validPattern = /^07\d{8}$/;
                if (!validPattern.test(raw)) {
                    e.preventDefault();
                    contactError.style.display = "block";
                    contactInput.focus();
                } else {
                    contactError.style.display = "none";
                    contactInput.value = "+94" + raw.slice(1);
                }
            });
        </script>

    </body>
</html>
