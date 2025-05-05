<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String decorationId = request.getParameter("id");
    String decorationName = "";

    if (decorationId == null) {
        response.sendRedirect("decoration_customer.jsp");
        return;
    }

    // Fetch service name
    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT name FROM decoration_services WHERE id = ?");
        stmt.setString(1, decorationId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            decorationName = rs.getString("name");
        } else {
            response.sendRedirect("decoration_customer.jsp");
            return;
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO decoration_bookings (decoration_id, decoration_name, customer_name, customer_phone, preferred_date, message) VALUES (?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, decorationId);
            stmt.setString(2, decorationName);
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
    <title>Book Decoration</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .form-box {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            padding: 12px;
            background: var(--brown);
            color: white;
            font-weight: bold;
            width: 100%;
            border: none;
            border-radius: 6px;
        }

        .success {
            color: green;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Book: <%= decorationName %></h2>

    <% if (!message.isEmpty()) { %>
        <p class="success"><%= message %></p>
    <% } %>

    <form method="post">
        <label>Your Full Name</label>
        <input type="text" name="customer_name" required>

        <label>Phone Number</label>
        <input type="text" name="customer_phone" maxlength="15" required>

        <label>Preferred Date</label>
        <input type="date" name="preferred_date" required>

        <label>Message (Optional)</label>
        <textarea name="message" rows="4"></textarea>

        <button type="submit">Send Booking Request</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="decoration_customer.jsp">← Back to Decoration</a>
    </div>
</div>

</body>
</html>
