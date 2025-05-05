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
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Photography Booking Requests</title>
        <link rel="stylesheet" href="styles.css" />
        <style>
            body {
                padding: 0px;
                margin: 0px;
                font-family: 'Poppins', sans-serif;
                background: #f4f4f4;
            }

            h2 {
                text-align: center;
                margin-bottom: 30px;
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

            table {
                width: 95%;
                margin: auto;
                background: white;
                border-collapse: collapse;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
            }

            th, td {
                padding: 12px;
                text-align: center;
                border: 1px solid #ccc;
            }

            th {
                background: var(--primary);
                color: white;
            }

            .btn {
                padding: 6px 10px;
                font-size: 0.9rem;
                text-decoration: none;
                font-weight: bold;
                border-radius: 4px;
                color: white;
            }

            .confirm {
                background-color: green;
            }
            .reject {
                background-color: red;
            }

            .status-pending {
                color: orange;
                font-weight: bold;
            }
            .status-confirmed {
                color: green;
                font-weight: bold;
            }
            .status-rejected {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">View Bookings</h1>
                <div class="nav-links">
                    <a href="../seller_index.jsp" class="nav-link active">Home</a>
                    <a href="photography_seller.jsp" class="nav-link">Seller Page</a>
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

        <%
            try {
                stmt = conn.prepareStatement(
                    "SELECT b.*, s.owner FROM photography_bookings b JOIN photography_services s ON b.service_id = s.id WHERE s.owner = ? ORDER BY b.created_at DESC"
                );
                stmt.setString(1, seller);
                rs = stmt.executeQuery();

                boolean found = false;
        %>

        <table>
            <tr>
                <th>ID</th>
                <th>Service</th>
                <th>Customer</th>
                <th>Phone</th>
                <th>Preferred Date</th>
                <th>Message</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                    while (rs.next()) {
                        found = true;
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("service_name") %></td>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("customer_phone") %></td>
                <td><%= rs.getString("preferred_date") %></td>
                <td><%= rs.getString("message") == null ? "-" : rs.getString("message") %></td>
                <td class="status-<%= rs.getString("status") %>"><%= rs.getString("status") %></td>
                <td>
                    <% if ("pending".equals(rs.getString("status"))) { %>
                    <a href="update_photography_booking.jsp?id=<%= rs.getInt("id") %>&status=confirmed" class="btn confirm">Confirm</a>
                    <a href="update_photography_booking.jsp?id=<%= rs.getInt("id") %>&status=rejected" class="btn reject">Reject</a>
                    <% } else { %>
                    -
                    <% } %>
                </td>
            </tr>
            <%
                    }

                    if (!found) {
            %>
            <tr><td colspan="8">No booking requests found.</td></tr>
            <%
                    }

                    rs.close();
                    stmt.close();
                } catch (Exception e) {
                    out.println("❌ Error: " + e.getMessage());
                }
            %>
        </table>
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
