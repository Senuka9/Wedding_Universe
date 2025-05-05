<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String venueId = request.getParameter("id");
    if (venueId == null) {
        response.sendRedirect("venue_customer.jsp");
        return;
    }

    String name = "", type = "", capacity = "", price = "", description = "", features = "", image = "";
    String priceCategory = "";
    double rating = 0.0;
    int reviews = 0;
    String status = "";

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM venues WHERE id = ?");
        stmt.setString(1, venueId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            status = rs.getString("status");
            if (!"active".equals(status)) {
                out.println("<h3>This venue is currently not available.</h3>");
                return;
            }

            name = rs.getString("name");
            type = rs.getString("type");
            capacity = rs.getString("capacity");
            price = rs.getString("price");
            rating = rs.getDouble("rating");
            reviews = rs.getInt("reviews");
            description = rs.getString("description");
            features = rs.getString("features");
            priceCategory = rs.getString("priceCategory");
            image = rs.getString("image");
        } else {
            out.println("❌ Venue not found.");
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
        <title><%= name %> - Venue Details</title>
        <link rel="stylesheet" href="style.css">
        <style>
            .detail-box {
                max-width: 1000px;
                margin: 50px auto;
                display: flex;
                gap: 40px;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 8px rgba(0,0,0,0.1);
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
                margin: 2px 5px 2px 0;
                font-size: 13px;
                border-radius: 4px;
            }

            .btn {
                margin-top: 15px;
                display: inline-block;
                padding: 10px 16px;
                background: var(--brown);
                color: white;
                font-weight: bold;
                border-radius: 6px;
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
                    <a href="venue_customer.jsp" class="nav-link active">Back to Venue</a>
                </div>
            </div>
        </div>

        <div class="detail-box">
            <img src="<%= image %>" alt="<%= name %>">
            <div class="info">
                <h2><%= name %></h2>
                <p><strong>Type:</strong> <%= type %></p>
                <p><strong>Capacity:</strong> <%= capacity %></p>
                <p><strong>Price:</strong> <%= price %></p>
                <p><strong>Category:</strong> <%= priceCategory %></p>
                <p><strong>Rating:</strong> ★ <%= rating %> (<%= reviews %> reviews)</p>
                <p><strong>Description:</strong><br><%= description %></p>

                <p><strong>Features:</strong><br>
                    <% for (String tag : features.split(",")) { %>
                    <span class="tag"><%= tag.trim() %></span>
                    <% } %>
                </p>

                <a href="book_venue.jsp?id=<%= venueId %>" class="btn">📅 Schedule Viewing</a>
            </div>
        </div>

    </body>
</html>
