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
                "INSERT INTO venues (name, type, description, capacity, priceCategory, features, price, rating, reviews, image, owner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("type"));
            stmt.setString(3, request.getParameter("description"));
            stmt.setString(4, request.getParameter("capacity"));
            stmt.setString(5, request.getParameter("priceCategory"));
            stmt.setString(6, request.getParameter("features")); // comma-separated tags
            stmt.setString(7, request.getParameter("price"));
            stmt.setDouble(8, Double.parseDouble(request.getParameter("rating")));
            stmt.setInt(9, Integer.parseInt(request.getParameter("reviews")));
            stmt.setString(10, request.getParameter("image"));
            stmt.setString(11, seller);

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Venue added successfully!" : "❌ Failed to add venue.";
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
    <title>Venue Seller Dashboard</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .form-box {
            max-width: 850px;
            margin: 50px auto;
            background: white;
            padding: 25px;
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
            background: var(--primary);
            color: white;
        }

        .disabled-link {
            pointer-events: none;
            color: grey;
            opacity: 0.6;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Add New Venue</h2>
    <form method="post">
        <input type="text" name="name" placeholder="Venue Name" required>
        <textarea name="description" placeholder="Venue Description" required></textarea>

        <label>Type</label>
        <select name="type" required>
            <option value="hotel">Hotel</option>
            <option value="resort">Resort</option>
            <option value="garden">Garden</option>
            <option value="historic">Historic</option>
        </select>

        <label>Capacity</label>
        <select name="capacity" required>
            <option value="small">Small</option>
            <option value="medium">Medium</option>
            <option value="large">Large</option>
        </select>

        <label>Price Category</label>
        <select name="priceCategory" required>
            <option value="premium">Premium</option>
            <option value="luxury">Luxury</option>
            <option value="ultra">Ultra Luxury</option>
        </select>

        <input type="text" name="price" placeholder="Price Range (e.g., $5000 - $8000)" required>
        <input type="number" step="0.1" name="rating" placeholder="Rating (0.0 to 5.0)" required>
        <input type="number" name="reviews" placeholder="Number of Reviews" required>
        <input type="text" name="features" placeholder="Features (comma-separated)" required>
        <input type="text" name="image" placeholder="Image URL or Video Link" required>

        <button type="submit">Add Venue</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
</div>

<%
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM venues WHERE owner = '" + seller + "'");
%>

<div>
    <h3 style="text-align:center;">Your Venues</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Type</th>
            <th>Capacity</th>
            <th>Price</th>
            <th>Status</th>
            <th>Details</th>
            <th>Actions</th>
        </tr>

        <% while (rs.next()) {
            String status = rs.getString("status");
            boolean isActive = "active".equals(status);
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("type") %></td>
            <td><%= rs.getString("capacity") %></td>
            <td><%= rs.getString("price") %></td>
            <td>
                <%= isActive ? "✅" : "❌" %><br>
                <a href="toggle_status.jsp?id=<%= rs.getInt("id") %>&status=<%= isActive ? "inactive" : "active" %>">
                    <%= isActive ? "Deactivate" : "Activate" %>
                </a>
            </td>
            <td>
                <% if (isActive) { %>
                    <a href="venue_detail.jsp?id=<%= rs.getInt("id") %>">View</a>
                <% } else { %>
                    <span class="disabled-link">View</span>
                <% } %>
            </td>
            <td>
                <a href="update_venue.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                <a href="delete_venue.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Delete this venue?')">Delete</a>
            </td>
        </tr>
        <% } rs.close(); stmt.close(); %>
    </table>
</div>

</body>
</html>

