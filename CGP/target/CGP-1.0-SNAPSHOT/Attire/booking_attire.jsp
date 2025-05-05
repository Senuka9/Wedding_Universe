<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String attireId = request.getParameter("id");
    String attireName = "";

    if (attireId == null) {
        response.sendRedirect("attire_customer.jsp");
        return;
    }

    // Fetch attire name
    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT name FROM attire WHERE id = ?");
        stmt.setString(1, attireId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            attireName = rs.getString("name");
        } else {
            response.sendRedirect("attire_customer.jsp");
            return;
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO attire_bookings (attire_id, attire_name, customer_name, customer_phone, preferred_date, message) VALUES (?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, attireId);
            stmt.setString(2, attireName);
            stmt.setString(3, request.getParameter("customer_name"));
            stmt.setString(4, request.getParameter("customer_phone"));
            stmt.setString(5, request.getParameter("preferred_date"));
            stmt.setString(6, request.getParameter("message"));

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Booking request sent successfully!" : "❌ Booking failed.";
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
    <title>Book Wedding Attire</title>
        <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .form-container {
            max-width: 500px;
            background: #ffffff;
            padding: 30px;
            margin: 50px auto;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333333;
        }
        form input[type="text"],
        form input[type="date"],
        form textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 20px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        form textarea {
            resize: vertical;
            min-height: 100px;
        }
        form button {
            width: 100%;
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        form button:hover {
            background-color: #45a049;
        }
        .message {
            margin-top: 20px;
            padding: 10px;
            text-align: center;
            background-color: #e7f3fe;
            color: #31708f;
            border: 1px solid #bce8f1;
            border-radius: 5px;
        }
        a {
            text-decoration: none;
            color: #4CAF50;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Book <%= attireName %></h2>
    <form method="post">
        <input type="text" name="customer_name" placeholder="Your Name" required>
        <input type="text" name="customer_phone" placeholder="Your Phone Number" required>
        <input type="date" name="preferred_date" required>
        <textarea name="message" placeholder="Message (Optional)"></textarea>
        <button type="submit">Submit Booking</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <div style="text-align:center; margin-top: 20px;">
        <a href="attire_customer.jsp">← Back to Attire</a>
    </div>
</div>

</body>
</html>
