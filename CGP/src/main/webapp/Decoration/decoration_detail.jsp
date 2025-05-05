<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String id = request.getParameter("id");
    String name = "", description = "", image = "", contact = "", category = "", location = "", season = "", features = "", status = "";
    double price = 0.0, rating = 0.0;

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM decoration_services WHERE id = ?");
        stmt.setString(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            image = rs.getString("image");
            contact = rs.getString("contact");
            category = rs.getString("category");
            location = rs.getString("location");
            season = rs.getString("season");
            features = rs.getString("features");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            status = rs.getString("status");
        } else {
            out.println("<h3>❌ Service not found.</h3>");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= name %> - Decoration Details</title>
        <link rel="stylesheet" href="styles.css" />
        <style>
            .detail-box {
                max-width: 900px;
                margin: 50px auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
                display: flex;
                gap: 30px;
            }

            .detail-box img {
                width: 45%;
                border-radius: 10px;
            }

            .info {
                width: 55%;
            }

            .info h2 {
                margin-bottom: 10px;
            }

            .info p {
                margin-bottom: 10px;
                font-size: 15px;
                color: #333;
            }

            .info .price {
                font-size: 20px;
                font-weight: bold;
                color: var(--primary);
            }

            .btn {
                margin-top: 20px;
                display: inline-block;
                padding: 10px 15px;
                background: var(--brown);
                color: white;
                font-weight: bold;
                text-decoration: none;
                border-radius: 6px;
            }

            .unavailable {
                text-align: center;
                color: red;
                font-weight: bold;
                margin-top: 40px;
            }

            .tag {
                display: inline-block;
                background: #eee;
                padding: 5px 10px;
                margin: 2px 5px 2px 0;
                border-radius: 4px;
                font-size: 13px;
            }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link">Home</a>
                    <a href="decoration_customer.jsp" class="nav-link active">Back to Decoration</a>
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
                <p><strong>Location:</strong> <%= location %></p>
                <p><strong>Season:</strong> <%= season.substring(0,1).toUpperCase() + season.substring(1) %></p>
                <p><strong>Description:</strong><br><%= description %></p>
                <p><strong>Rating:</strong> ★ <%= rating %></p>
                <p class="price">Price: $<%= price %></p>

                <div><strong>Features:</strong><br>
                    <% for (String tag : features.split(",")) { %>
                    <span class="tag"><%= tag.trim() %></span>
                    <% } %>
                </div>

                <p><strong>Contact:</strong> <%= contact %></p>

                <a href="book_decoration.jsp?id=<%= id %>" class="btn">📅 Book This Service</a>
            </div>
        </div>
        <% } %>

    </body>
</html>
