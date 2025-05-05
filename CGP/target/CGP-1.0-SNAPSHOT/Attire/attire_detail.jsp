<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String id = request.getParameter("id");
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String name = "", category = "", gender = "", image = "", contact = "";
    double price = 0.0, rating = 0.0;
    int reviews = 0;

    try {
        stmt = conn.prepareStatement("SELECT * FROM attire WHERE id = ?");
        stmt.setString(1, id);
        rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            category = rs.getString("category");
            gender = rs.getString("gender");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            image = rs.getString("image");
            contact = rs.getString("contact");
        } else {
            out.println("<h2>Attire not found.</h2>");
            return;
        }
    } catch (Exception e) {
        out.println("⚠️ Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= name %> - Wedding Attire Details</title>
        <link rel="stylesheet" href="styles.css" />
        <style>
            .detail-container {
                max-width: 1000px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                display: flex;
                gap: 30px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 10px;
            }
            .detail-container img {
                width: 50%;
                border-radius: 10px;
            }
            .detail-info {
                width: 50%;
            }
            .detail-info h2 {
                font-size: 28px;
                margin-bottom: 15px;
                color: var(--text);
            }
            .detail-info p {
                margin: 8px 0;
                font-size: 16px;
                color: #444;
            }
            .price {
                font-size: 22px;
                color: var(--primary);
                margin: 15px 0;
            }
            .contact {
                background: var(--brown);
                color: white;
                padding: 10px 15px;
                display: inline-block;
                margin-top: 20px;
                border-radius: 5px;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link">Home</a>
                    <a href="attire_customer.jsp" class="nav-link active">Back to Attire</a>
                </div>
            </div>
        </div>

        <div class="detail-container">
            <img src="<%= image %>" alt="<%= name %>">
            <div class="detail-info">
                <h2><%= name %></h2>
                <p><strong>Category:</strong> <%= category %></p>
                <p><strong>Gender:</strong> <%= gender %></p>
                <p><strong>Rating:</strong> <%= rating %> ⭐</p>
                <p class="price">Price: $<%= price %></p>
                <a href="booking_attire.jsp?id=<%= id %>" class="view-details">Book Now</a>
            </div>
        </div>

    </body>
</html>
