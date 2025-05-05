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
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Wedding Attire Bookings</title>
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

            table {
                margin: 40px auto;
                width: 95%;
                background: white;
                border-collapse: collapse;
            }

            th, td {
                padding: 12px;
                border: 1px solid #ccc;
                text-align: center;
            }

            th {
                background: var(--primary);
                color: white;
            }

            .btn {
                padding: 6px 12px;
                margin: 2px;
                font-size: 14px;
                text-decoration: none;
                border-radius: 5px;
            }

            .btn-confirm {
                background-color: #28a745;
                color: white;
            }

            .btn-reject {
                background-color: #dc3545;
                color: white;
            }

            .btn-disabled {
                background-color: grey;
                color: white;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">View Bookings</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="attire_seller.jsp" class="nav-link">Seller Page</a>
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

            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Preferred Date</th>
                    <th>Message</th>
                    <th>Attire Name</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>

                <%
                    try {
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT b.*, a.owner FROM attire_bookings b INNER JOIN attire a ON b.attire_id = a.id WHERE a.owner = ?"
                        );
                        stmt.setString(1, seller);
                        ResultSet rs = stmt.executeQuery();

                        while (rs.next()) {
                            String status = rs.getString("status");
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("customer_phone") %></td>
                    <td><%= rs.getDate("preferred_date") %></td>
                    <td><%= rs.getString("message") %></td>
                    <td><%= rs.getString("attire_name") %></td>
                    <td><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></td>
                    <td>
                        <% if ("pending".equals(status)) { %>
                        <a class="btn btn-confirm" href="update_attire_booking_status.jsp?id=<%= rs.getInt("id") %>&status=confirmed">Confirm</a>
                        <a class="btn btn-reject" href="update_attire_booking_status.jsp?id=<%= rs.getInt("id") %>&status=rejected">Reject</a>
                        <% } else { %>
                        <span class="btn btn-disabled"><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></span>
                        <% } %>
                    </td>
                </tr>
                <% 
                        }
                        rs.close();
                        stmt.close();
                    } catch (Exception e) {
                        out.println("❌ Error: " + e.getMessage());
                    }
                %>
            </table>

            <div style="text-align:center; margin-top: 20px;">
                <a href="attire_seller.jsp">← Back to Seller Page</a>
            </div>
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
