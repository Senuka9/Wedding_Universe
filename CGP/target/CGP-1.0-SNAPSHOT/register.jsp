<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String message = "";

    if(request.getParameter("registerBtn") != null){
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if(username == null || username.trim().isEmpty() ||
           email == null || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$") ||
           password == null || password.length() < 6 ||
           role == null || role.trim().isEmpty()) {
            message = "❗ Please fill all fields correctly.";
        } else {
            Connection conn = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "");
                // continue using conn here
            } catch(Exception e) {
                message = "⚠️ Connection failed: " + e.getMessage();
            }

            try {
                String query = "INSERT INTO users(username, email, password, role) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(query);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, role);

                int rows = ps.executeUpdate();
                if(rows > 0){
                    response.sendRedirect("login.jsp");
                } else {
                    message = "❌ Registration failed.";
                }
            } catch(Exception e){
                message = "⚠️ Error: " + e.getMessage();
            }
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #f8f9fa, #e0eafc);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .form-box {
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            width: 350px;
            text-align: center;
        }

        h2 {
            color: #333;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        input[type="submit"], .nav-btn {
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            margin-top: 10px;
            padding: 10px 20px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover, .nav-btn:hover {
            background-color: #0056b3;
        }

        .message {
            margin-top: 10px;
            color: red;
            font-weight: bold;
        }

        .switch-page {
            margin-top: 15px;
            display: block;
            color: #007bff;
            text-decoration: none;
        }

        .switch-page:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Register</h2>
    <p class="message"><%= message %></p>

    <form method="post" onsubmit="return validateForm()">
        <input type="text" name="username" placeholder="Username" required /><br/>
        <input type="email" name="email" placeholder="Email" required /><br/>
        <input type="password" name="password" placeholder="Password (min 6 chars)" minlength="6" required /><br/>
        <select name="role" required>
            <option value="">Select Role</option>
            <option value="customer">Customer</option>
            <option value="seller">Seller</option>
        </select><br/>
        <input type="submit" name="registerBtn" value="Register" />
    </form>

    <a class="switch-page" href="login.jsp">Already have an account? Login here</a>
</div>

<script>
function validateForm() {
    const username = document.querySelector('input[name="username"]').value.trim();
    const email = document.querySelector('input[name="email"]').value.trim();
    const password = document.querySelector('input[name="password"]').value;
    const role = document.querySelector('select[name="role"]').value;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (username === "") {
        alert("Username cannot be empty.");
        return false;
    }

    if (!emailRegex.test(email)) {
        alert("Enter a valid email address.");
        return false;
    }

    if (password.length < 6) {
        alert("Password must be at least 6 characters long.");
        return false;
    }

    if (role === "") {
        alert("Please select a role.");
        return false;
    }

    return true;
}
</script>

</body>
</html>


