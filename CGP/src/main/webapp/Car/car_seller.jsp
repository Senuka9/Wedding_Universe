<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String seller = (String) session.getAttribute("username");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO wedding_cars (name, description, price, rating, image, contact, car_type, features, owner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(5, request.getParameter("image"));
            stmt.setString(6, request.getParameter("contact"));
            stmt.setString(7, request.getParameter("car_type"));
            stmt.setString(8, request.getParameter("features"));
            stmt.setString(9, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Car added successfully!" : "❌ Failed to add.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Wedding Car - Seller</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
        }

        .form-container {
            max-width: 700px;
            margin: 30px auto;
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
            background: purple;
            color: white;
            padding: 12px;
            font-weight: bold;
            width: 100%;
            border: none;
            border-radius: 6px;
        }

        table {
            width: 95%;
            margin: 30px auto;
            background: white;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: purple;
            color: white;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: green;
        }

        .disabled-link {
            pointer-events: none;
            opacity: 0.6;
            color: grey;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Add New Wedding Car</h2>
    <% if (!message.isEmpty()) { %><div class="message"><%= message %></div><% } %>

    <form method="post">
        <input type="text" name="name" placeholder="Car Name" required>
        <textarea name="description" placeholder="Car Description" required></textarea>
        <input type="number" step="0.01" name="price" placeholder="Price" required>
        <input type="number" step="0.1" name="rating" min="0" max="5" placeholder="Rating (0-5)" required>
        <input type="text" name="image" placeholder="Image URL" required>
        <input type="text" name="contact" placeholder="Contact" required>

        <label>Car Type</label>
        <select name="car_type">
            <option value="Limousine">Limousine</option>
            <option value="Classic">Classic</option>
            <option value="SUV">SUV</option>
            <option value="Convertible">Convertible</option>
        </select>

        <label>Features (comma separated)</label>
        <input type="text" name="features" placeholder="AC, Chauffeur, Leather Seats" required>

        <button type="submit">Add Car</button>
    </form>
</div>

<%
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM wedding_cars WHERE owner = '" + seller + "'");
%>

<div>
    <h3 style="text-align:center;">Your Car Listings</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Type</th>
            <th>Status</th>
            <th>View</th>
            <th>Actions</th>
        </tr>

        <% while (rs.next()) {
            String status = rs.getString("status");
            boolean isActive = "active".equals(status);
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("car_type") %></td>
            <td>
                <%= isActive ? "✅" : "❌" %><br>
                <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=<%= isActive ? "inactive" : "active" %>">
                    <%= isActive ? "Deactivate" : "Activate" %>
                </a>
            </td>
            <td>
                <% if (isActive) { %>
                    <a href="car_detail.jsp?id=<%= rs.getInt("id") %>">View</a>
                <% } else { %>
                    <span class="disabled-link">View</span>
                <% } %>
            </td>
            <td>
                <a href="update_car.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                <a href="delete_car.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
        <% } rs.close(); stmt.close(); %>
    </table>
</div>

</body>
</html>
