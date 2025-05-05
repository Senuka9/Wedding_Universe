<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String id = request.getParameter("id");
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String name = "", description = "", duration = "", category = "", image = "", contact = "", status = "";
    double price = 0.0, rating = 0.0;

    try {
        stmt = conn.prepareStatement("SELECT * FROM beautician_services WHERE id = ?");
        stmt.setString(1, id);
        rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            duration = rs.getString("duration");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            image = rs.getString("image");
            category = rs.getString("category");
            contact = rs.getString("contact");
            status = rs.getString("status");
        } else {
            out.println("<h3>❌ Service not found.</h3>");
            return;
        }
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= name %> - Service Details</title>
        <link rel="stylesheet" href="styles.css" />
        <style>
            .detail-box {
                max-width: 900px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                display: flex;
                gap: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            .detail-box img {
                width: 45%;
                border-radius: 10px;
            }

            .info {
                width: 55%;
            }

            .info h2 {
                font-size: 26px;
                color: #333;
                margin-bottom: 10px;
            }

            .info p {
                margin: 10px 0;
                font-size: 15px;
                color: #555;
            }

            .price {
                font-size: 20px;
                color: var(--primary);
                font-weight: bold;
                margin: 15px 0;
            }

            .status {
                font-size: 16px;
                font-weight: bold;
                color: green;
            }

            .status.inactive {
                color: red;
            }

            .contact-button {
                background: var(--brown);
                color: white;
                padding: 10px 15px;
                font-weight: bold;
                border: none;
                border-radius: 6px;
                text-decoration: none;
            }

            .unavailable {
                font-weight: bold;
                font-size: 18px;
                color: red;
                text-align: center;
                margin: 40px auto;
            }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link">Home</a>
                    <a href="beautician_customer.jsp" class="nav-link active">Back to Beautician</a>
                </div>
            </div>
        </div>

        <% if ("inactive".equals(status)) { %>
        <div class="unavailable">❌ This service is currently unavailable.</div>
        <% } else { %>
        <div class="detail-box">
            <img src="<%= image %>" alt="<%= name %>">
            <div class="info">
                <h2><%= name %></h2>
                <p><strong>Category:</strong> <%= category %></p>
                <p><strong>Duration:</strong> <%= duration %></p>
                <p><strong>Description:</strong><br><%= description %></p>
                <p><strong>Rating:</strong> ★ <%= rating %></p>
                <p class="price">Price: $<%= price %></p>
                <p class="status">Status: <span class="<%= "inactive".equals(status) ? "status inactive" : "status" %>"><%= status %></span></p>
                <a href="book_beautician.jsp?id=<%= id %>" class="view-details">📅 Book Now</a>
            </div>
        </div>
        <% } %>

    </body>
</html>
