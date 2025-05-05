<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String carId = request.getParameter("id");
    if (carId == null) {
        response.sendRedirect("weddingcar_customer.jsp");
        return;
    }

    String carName = "";
    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT name FROM wedding_cars WHERE id = ?");
        stmt.setString(1, carId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            carName = rs.getString("name");
        } else {
            response.sendRedirect("weddingcar_customer.jsp");
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
                "INSERT INTO car_bookings (car_id, car_name, customer_name, customer_phone, preferred_date, message) VALUES (?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, carId);
            stmt.setString(2, carName);
            stmt.setString(3, request.getParameter("customer_name"));
            stmt.setString(4, request.getParameter("customer_phone"));
            stmt.setString(5, request.getParameter("preferred_date"));
            stmt.setString(6, request.getParameter("message"));

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Your car booking request has been sent!" : "❌ Booking failed.";
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
    <title>Book Car - <%= carName %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f8f8f8;
        }

        .form-box {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            background: purple;
            color: white;
            padding: 12px;
            border: none;
            width: 100%;
            font-weight: bold;
            border-radius: 6px;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: green;
        }

        .error {
            text-align: center;
            font-weight: bold;
            color: red;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>Book: <%= carName %></h2>

    <% if (!message.isEmpty()) { %>
        <p class="<%= message.contains("❌") ? "error" : "message" %>"><%= message %></p>
    <% } else { %>
        <form method="post">
            <label>Your Name</label>
            <input type="text" name="customer_name" required />

            <label>Phone Number</label>
            <input type="text" name="customer_phone" maxlength="15" required />

            <label>Preferred Date</label>
            <input type="date" name="preferred_date" required />

            <label>Message (Optional)</label>
            <textarea name="message" rows="4"></textarea>

            <button type="submit">Send Booking Request</button>
        </form>
    <% } %>
</div>

</body>
</html>
