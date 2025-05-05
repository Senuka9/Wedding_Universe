<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String carId = request.getParameter("id");
    if (carId == null) {
        response.sendRedirect("weddingcar_customer.jsp");
        return;
    }

    String name = "", description = "", image = "", price = "", rating = "", features = "";

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM wedding_cars WHERE id = ?");
        stmt.setString(1, carId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            image = rs.getString("image");
            price = rs.getString("price");
            rating = rs.getString("rating");
            features = rs.getString("features");
        } else {
            out.println("❌ Car not found.");
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
        <title><%= name %> - Car Details</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                margin: 0;
                padding: 0;
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

            .detail-box {
                max-width: 1000px;
                margin: 50px auto;
                background: white;
                display: flex;
                gap: 30px;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(0,0,0,0.1);
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
            }

            .tag {
                display: inline-block;
                background: #eee;
                padding: 5px 10px;
                margin: 3px 5px 3px 0;
                font-size: 13px;
                border-radius: 4px;
            }

            .btn {
                display: inline-block;
                margin-top: 15px;
                padding: 10px 16px;
                background: purple;
                color: white;
                font-weight: bold;
                border-radius: 6px;
                text-decoration: none;
            }

            .btn:hover {
                background: #640063;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link">Home</a>
                    <a href="weddingcar_customer.jsp" class="nav-link active">Back to Car</a>
                </div>
            </div>
        </div>
        <div class="detail-box">
            <img src="<%= image %>" alt="<%= name %>">
            <div class="info">
                <h2><%= name %></h2>
                <p><strong>Rating:</strong> ⭐ <%= rating %></p>
                <p><strong>Price:</strong> $<%= price %></p>
                <p><strong>Description:</strong><br><%= description %></p>

                <p><strong>Features:</strong><br>
                    <% for (String tag : features.split(",")) { %>
                    <span class="tag"><%= tag.trim() %></span>
                    <% } %>
                </p>

                <a href="book_car.jsp?id=<%= carId %>" class="btn">📅 Book This Car</a>
            </div>
        </div>

    </body>
</html>
