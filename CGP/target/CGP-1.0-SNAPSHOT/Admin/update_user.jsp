<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userId = request.getParameter("id");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newRole = request.getParameter("role");
        try {
            PreparedStatement ps = conn.prepareStatement("UPDATE users SET role = ? WHERE id = ?");
            ps.setString(1, newRole);
            ps.setInt(2, Integer.parseInt(userId));
            ps.executeUpdate();
            message = "User role updated successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            message = "Failed to update user role.";
        }
    }

    String currentRole = "";
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT role FROM users WHERE id = ?");
        ps.setInt(1, Integer.parseInt(userId));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            currentRole = rs.getString("role");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User Role</title>
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #34495e;
            --text-color: #333;
            --border-color: #ddd;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f7fa;
            color: var(--text-color);
            line-height: 1.6;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }

        h2 {
            color: var(--secondary-color);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            position: relative;
        }

        .alert.success {
            background-color: rgba(46, 204, 113, 0.1);
            border-left: 4px solid var(--success-color);
            color: var(--success-color);
        }

        .alert.error {
            background-color: rgba(231, 76, 60, 0.1);
            border-left: 4px solid var(--danger-color);
            color: var(--danger-color);
        }

        .close-btn {
            position: absolute;
            right: 15px;
            top: 15px;
            cursor: pointer;
        }

        form {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-color);
        }

        select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 1rem;
            transition: border 0.3s;
        }

        select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        button, .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        button {
            background-color: var(--primary-color);
            color: white;
        }

        button:hover {
            background-color: #2980b9;
        }

        .btn {
            background-color: var(--light-color);
            color: var(--text-color);
        }

        .btn:hover {
            background-color: #d5dbdb;
        }

        .btn i {
            margin-right: 8px;
        }

        @media (max-width: 768px) {
            .form-actions {
                flex-direction: column;
            }
            
            button, .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    
    <h2>Edit User Role</h2>

    <% if (!message.isEmpty()) { %>
        <p class="<%= message.contains("success") ? "success" : "error" %>"><%= message %></p>
    <% } %>

    <form method="post">
        <label>Select Role:</label><br>
        <select name="role" required>
            <option value="customer" <%= currentRole.equals("customer") ? "selected" : "" %>>Customer</option>
            <option value="seller" <%= currentRole.equals("seller") ? "selected" : "" %>>Seller</option>
            <option value="admin" <%= currentRole.equals("admin") ? "selected" : "" %>>Admin</option>
        </select><br><br>
        <button type="submit">Update Role</button>
    </form>
        <a href="manage_users.jsp">← Back to User Management</a>

</body>
</html>
