<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String id = request.getParameter("id");
    String name = "", category = "", description = "", duration = "", image = "", contact = "", status = "";
    double price = 0.0, rating = 0.0;

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM photography_services WHERE id = ?");
        stmt.setString(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            category = rs.getString("category");
            description = rs.getString("description");
            duration = rs.getString("duration");
            image = rs.getString("image");
            contact = rs.getString("contact");
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
    <title><%= name %> - Photography Details</title>
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
    </style>
</head>
<body>

        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link">Home</a>
                    <a href="photography_customer.jsp" class="nav-link active">Back to Photography</a>
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
            <p><strong>Contact:</strong> <%= contact %></p>
            <a href="book_photography.jsp?id=<%= id %>" class="btn">📆 Book Now</a>
        </div>
    </div>
<% } %>

</body>
</html>
