<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String seller = (String) session.getAttribute("username");
    String id = request.getParameter("id");
    String message = "";

    String name = "", description = "", price = "", rating = "", image = "", contact = "";
    String location = "", category = "", season = "", features = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE decoration_services SET name=?, description=?, price=?, rating=?, image=?, contact=?, location=?, category=?, season=?, features=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(5, request.getParameter("image"));
            stmt.setString(6, request.getParameter("contact"));
            stmt.setString(7, request.getParameter("location"));
            stmt.setString(8, request.getParameter("category"));
            stmt.setString(9, request.getParameter("season"));
            stmt.setString(10, request.getParameter("features"));
            stmt.setInt(11, Integer.parseInt(id));
            stmt.setString(12, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Updated successfully!" : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM decoration_services WHERE id=? AND owner=?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            price = rs.getString("price");
            rating = rs.getString("rating");
            image = rs.getString("image");
            contact = rs.getString("contact");
            location = rs.getString("location");
            category = rs.getString("category");
            season = rs.getString("season");
            features = rs.getString("features");
        } else {
            out.println("❌ Decoration not found or unauthorized.");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error loading decoration: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Decoration</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .form-box {
            max-width: 700px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            padding: 12px;
            background: var(--brown);
            color: white;
            font-weight: bold;
            border: none;
            width: 100%;
            border-radius: 6px;
        }

        .message {
            text-align: center;
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Update Decoration</h2>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <form method="post">
        <input type="text" name="name" value="<%= name %>" required>
        <textarea name="description" required><%= description %></textarea>
        <input type="number" step="0.01" name="price" value="<%= price %>" required>
        <input type="number" step="0.1" name="rating" min="0" max="5" value="<%= rating %>" required>
        <input type="text" name="image" value="<%= image %>" required>
        <input type="text" name="contact" value="<%= contact %>" required>

        <label>Location</label>
        <select name="location">
            <option value="Indoor" <%= location.equals("Indoor") ? "selected" : "" %>>Indoor</option>
            <option value="Outdoor" <%= location.equals("Outdoor") ? "selected" : "" %>>Outdoor</option>
        </select>

        <label>Category</label>
        <select name="category">
            <option value="Elegant Themes" <%= category.equals("Elegant Themes") ? "selected" : "" %>>Elegant Themes</option>
            <option value="Modern Designs" <%= category.equals("Modern Designs") ? "selected" : "" %>>Modern Designs</option>
            <option value="Garden Themes" <%= category.equals("Garden Themes") ? "selected" : "" %>>Garden Themes</option>
            <option value="Beach & Resort" <%= category.equals("Beach & Resort") ? "selected" : "" %>>Beach & Resort</option>
        </select>

        <label>Season</label>
        <select name="season">
            <option value="all" <%= season.equals("all") ? "selected" : "" %>>All</option>
            <option value="spring" <%= season.equals("spring") ? "selected" : "" %>>Spring</option>
            <option value="summer" <%= season.equals("summer") ? "selected" : "" %>>Summer</option>
            <option value="fall" <%= season.equals("fall") ? "selected" : "" %>>Fall</option>
            <option value="winter" <%= season.equals("winter") ? "selected" : "" %>>Winter</option>
        </select>

        <label>Feature Tags</label>
        <input type="text" name="features" value="<%= features %>" required>

        <button type="submit">Update</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="decoration_seller.jsp">← Back to Seller Dashboard</a>
    </div>
</div>

</body>
</html>
