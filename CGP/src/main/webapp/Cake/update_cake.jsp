<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String seller = (String) session.getAttribute("username");
    String message = "";
    String id = request.getParameter("id");

    if (seller == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Handle update
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String rating = request.getParameter("rating");
        String image = request.getParameter("image");
        String contact = request.getParameter("contact");

        try {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE cakes SET name=?, description=?, price=?, rating=?, image=?, contact=? WHERE id=? AND owner=?"
            );
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setDouble(4, Double.parseDouble(rating));
            ps.setString(5, image);
            ps.setString(6, contact);
            ps.setInt(7, Integer.parseInt(id));
            ps.setString(8, seller);

            int result = ps.executeUpdate();
            message = (result > 0) ? "✅ Cake updated successfully." : "❌ You are not allowed to update this cake.";
            ps.close();
        } catch (Exception e) {
            message = "⚠️ Error: " + e.getMessage();
        }
    }

    // Load existing cake details for this seller
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM cakes WHERE id=? AND owner=?");
    ps.setInt(1, Integer.parseInt(id));
    ps.setString(2, seller);
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
        out.println("<p style='color:red;'>❌ Cake not found or access denied.</p>");
        return;
    }
%>

<html>
<head>
    <title>Edit Cake</title>
    <style>
        body {
            font-family: Arial;
            background: #f5f5f5;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            width: 100%;
            background-color: #007bff;
            color: white;
            padding: 10px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
        }

        .message {
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Edit Cake</h2>
    <form method="post">
        Name:
        <input type="text" name="name" value="<%= rs.getString("name") %>" required>

        Description:
        <textarea name="description" rows="4" required><%= rs.getString("description") %></textarea>

        Price:
        <input type="number" name="price" step="0.01" value="<%= rs.getDouble("price") %>" required>

        Rating:
        <input type="number" name="rating" step="0.1" min="0" max="5" value="<%= rs.getDouble("rating") %>" required>

        Contact Number:
        <input type="text" name="contact" value="<%= rs.getString("contact") %>" required>

        Image URL:
        <input type="text" name="image" value="<%= rs.getString("image") %>" required>

        <button type="submit">Update Cake</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div style="text-align: center; margin-top: 10px;">
        <a href="cake_seller.jsp">⬅ Back to Seller Dashboard</a>
    </div>
</div>

</body>
</html>

<%
    rs.close();
    ps.close();
%>
