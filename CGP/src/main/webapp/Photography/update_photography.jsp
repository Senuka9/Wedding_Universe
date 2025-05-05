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

    String name = "", description = "", duration = "", category = "", image = "", contact = "";
    double price = 0.0, rating = 0.0;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE photography_services SET name=?, description=?, duration=?, price=?, rating=?, image=?, category=?, contact=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setString(3, request.getParameter("duration"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(6, request.getParameter("image"));
            stmt.setString(7, request.getParameter("category"));
            stmt.setString(8, request.getParameter("contact"));
            stmt.setInt(9, Integer.parseInt(id));
            stmt.setString(10, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Photography service updated!" : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM photography_services WHERE id=? AND owner=?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            duration = rs.getString("duration");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            image = rs.getString("image");
            category = rs.getString("category");
            contact = rs.getString("contact");
        } else {
            out.println("<h3>❌ Service not found or you’re not authorized.</h3>");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error loading service: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Photography Package</title>
    <link rel="stylesheet" href="styles.css" />
    <style>
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            background: var(--brown);
            color: white;
            padding: 12px;
            border: none;
            width: 100%;
            border-radius: 6px;
            font-weight: bold;
        }

        .message {
            text-align: center;
            color: green;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Update Photography Package</h2>
    <form method="post">
        <input type="text" name="name" value="<%= name %>" required>
        <textarea name="description" rows="3" required><%= description %></textarea>
        <input type="text" name="duration" value="<%= duration %>" required>
        <input type="number" step="0.01" name="price" value="<%= price %>" required>
        <input type="number" step="0.1" name="rating" min="0" max="5" value="<%= rating %>" required>
        <input type="text" name="image" value="<%= image %>" required>
        <input type="text" name="contact" value="<%= contact %>" required>

        <select name="category" required>
            <option value="Full Day Packages" <%= category.equals("Full Day Packages") ? "selected" : "" %>>Full Day Packages</option>
            <option value="Half Day Packages" <%= category.equals("Half Day Packages") ? "selected" : "" %>>Half Day Packages</option>
            <option value="Pre-Wedding Shoots" <%= category.equals("Pre-Wedding Shoots") ? "selected" : "" %>>Pre-Wedding Shoots</option>
            <option value="Engagement Sessions" <%= category.equals("Engagement Sessions") ? "selected" : "" %>>Engagement Sessions</option>
        </select>

        <button type="submit">Update</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div style="text-align:center;">
        <a href="photography_seller.jsp">← Back to Seller Page</a>
    </div>
</div>

</body>
</html>