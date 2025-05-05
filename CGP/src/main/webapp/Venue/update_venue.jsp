<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String seller = (String) session.getAttribute("username");
    String message = "";

    String name = "", type = "", capacity = "", price = "", description = "", features = "", image = "", priceCategory = "";
    double rating = 0.0;
    int reviews = 0;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE venues SET name=?, type=?, description=?, capacity=?, priceCategory=?, features=?, price=?, rating=?, reviews=?, image=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("type"));
            stmt.setString(3, request.getParameter("description"));
            stmt.setString(4, request.getParameter("capacity"));
            stmt.setString(5, request.getParameter("priceCategory"));
            stmt.setString(6, request.getParameter("features"));
            stmt.setString(7, request.getParameter("price"));
            stmt.setDouble(8, Double.parseDouble(request.getParameter("rating")));
            stmt.setInt(9, Integer.parseInt(request.getParameter("reviews")));
            stmt.setString(10, request.getParameter("image"));
            stmt.setString(11, id);
            stmt.setString(12, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Venue updated successfully." : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM venues WHERE id = ? AND owner = ?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            type = rs.getString("type");
            capacity = rs.getString("capacity");
            price = rs.getString("price");
            description = rs.getString("description");
            features = rs.getString("features");
            image = rs.getString("image");
            priceCategory = rs.getString("priceCategory");
            rating = rs.getDouble("rating");
            reviews = rs.getInt("reviews");
        } else {
            out.println("❌ Venue not found or not owned by you.");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error loading venue: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Venue</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .form-box {
            max-width: 800px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            background: var(--brown);
            color: white;
            font-weight: bold;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: green;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Edit Venue</h2>
    <% if (!message.isEmpty()) { %><div class="message"><%= message %></div><% } %>

    <form method="post">
        <input type="text" name="name" value="<%= name %>" required>
        <textarea name="description" required><%= description %></textarea>

        <label>Type</label>
        <select name="type">
            <option value="hotel" <%= "hotel".equals(type) ? "selected" : "" %>>Hotel</option>
            <option value="resort" <%= "resort".equals(type) ? "selected" : "" %>>Resort</option>
            <option value="garden" <%= "garden".equals(type) ? "selected" : "" %>>Garden</option>
            <option value="historic" <%= "historic".equals(type) ? "selected" : "" %>>Historic</option>
        </select>

        <label>Capacity</label>
        <select name="capacity">
            <option value="small" <%= "small".equals(capacity) ? "selected" : "" %>>Small</option>
            <option value="medium" <%= "medium".equals(capacity) ? "selected" : "" %>>Medium</option>
            <option value="large" <%= "large".equals(capacity) ? "selected" : "" %>>Large</option>
        </select>

        <label>Price Category</label>
        <select name="priceCategory">
            <option value="premium" <%= "premium".equals(priceCategory) ? "selected" : "" %>>Premium</option>
            <option value="luxury" <%= "luxury".equals(priceCategory) ? "selected" : "" %>>Luxury</option>
            <option value="ultra" <%= "ultra".equals(priceCategory) ? "selected" : "" %>>Ultra Luxury</option>
        </select>

        <input type="text" name="price" value="<%= price %>" required>
        <input type="number" step="0.1" name="rating" value="<%= rating %>" required>
        <input type="number" name="reviews" value="<%= reviews %>" required>
        <input type="text" name="features" value="<%= features %>" required>
        <input type="text" name="image" value="<%= image %>" required>

        <button type="submit">Update Venue</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="venue_seller.jsp">← Back to Seller Page</a>
    </div>
</div>

</body>
</html>
