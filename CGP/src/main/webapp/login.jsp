<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String message = "";

    if(request.getParameter("loginBtn") != null){
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            message = "Email and password are required.";
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
                String query = "SELECT * FROM users WHERE email=? AND password=?";
                PreparedStatement ps = conn.prepareStatement(query);
                ps.setString(1, email);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();

                if(rs.next()){
                    String role = rs.getString("role");
                    String username = rs.getString("username");

                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    if(role.equalsIgnoreCase("customer")){
                        response.sendRedirect("index.jsp");
                        return;
                    } else if(role.equalsIgnoreCase("seller")){
                        response.sendRedirect("seller_index.jsp");
                        return;
                    }
                     else if ("admin".equals(role)) {
                        session.setAttribute("role", "admin");
                        response.sendRedirect("Admin/admin_home.jsp");

                    } else {
                        message = "Role not recognized.";
                    }

                } else {
                    message = "❌ Invalid email or password.";
                }

            } catch(Exception e){
                message = "⚠️ Login error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
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
            <h2>Login</h2>
            <p class="message"><%= message %></p>

            <form method="post" onsubmit="return validateLoginForm()">
                <input type="email" name="email" placeholder="Email" required /><br/>
                <input type="password" name="password" placeholder="Password" required /><br/>
                <input type="submit" name="loginBtn" value="Login" />
            </form>

            <a class="switch-page" href="register.jsp">Don't have an account? Register here</a>
        </div>

        <script>
            function validateLoginForm() {
                const email = document.querySelector('input[name="email"]').value;
                const password = document.querySelector('input[name="password"]').value;

                if (!email || !password) {
                    alert("Please fill in all fields.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>
