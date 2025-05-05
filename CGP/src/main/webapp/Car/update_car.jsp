<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String seller = (String) session.getAttribute("username");
    String message = "";

    String name="", description="", price="", rating="", image="", contact="", car_type="", features="";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE wedding_cars SET name=?, description=?, price=?, rating=?, image=?, contact=?, car_type=?, features=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(5, request.getParameter("image"));
            stmt.setString(6, request.getParameter("contact"));
            stmt.setString(7, request.getParameter("car_type"));
            stmt.setString(8, request.getParameter("features"));
            stmt.setString(9, id);
            stmt.setString(10, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Car updated successfully!" : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM wedding_cars WHERE id = ? AND owner = ?");
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
            car_type = rs.getString("car_type");
            features = rs.getString("features");
        } else {
            out.println("❌ Car not found or unauthorized.");
            return;
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error loading car: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Wedding Car</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; }
        .form-box {
            max-width: 700px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        input, textarea, select {
            width: 100%; padding: 10px; margin-bottom: 15px; border-radius: 6px; border: 1px solid #ccc;
        }
        button {
            background: purple; color: white; padding: 12px; width: 100%; border: none; border-radius: 6px; font-weight: bold;
        }
        .message { text-align: center; font-weight: bold; color: green; }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Edit Car</h2>
    <% if (!message.isEmpty()) { %><div class="message"><%= message %></div><% } %>

    <form method="post">
        <input type="text" name="name" value="<%= name %>" required>
        <textarea name="description" required><%= description %></textarea>
        <input type="text" name="price" value="<%= price %>" required>
        <input type="text" name="rating" value="<%= rating %>" required>
        <input type="text" name="image" value="<%= image %>" required>
        <input type="text" name="contact" value="<%= contact %>" required>

        <label>Car Type</label>
        <select name="car_type">
            <option value="Limousine" <%= "Limousine".equals(car_type) ? "selected" : "" %>>Limousine</option>
            <option value="Classic" <%= "Classic".equals(car_type) ? "selected" : "" %>>Classic</option>
            <option value="SUV" <%= "SUV".equals(car_type) ? "selected" : "" %>>SUV</option>
            <option value="Convertible" <%= "Convertible".equals(car_type) ? "selected" : "" %>>Convertible</option>
        </select>

        <input type="text" name="features" value="<%= features %>" required>

        <button type="submit">Update Car</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="car_seller.jsp">← Back to Seller Page</a>
    </div>
</div>

</body>
</html>
