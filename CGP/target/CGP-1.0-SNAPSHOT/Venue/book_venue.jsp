<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String venueId = request.getParameter("id");
    String venueName = "";

    if (venueId == null) {
        response.sendRedirect("venue_customer.jsp");
        return;
    }

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT name FROM venues WHERE id = ? AND status = 'active'");
        stmt.setString(1, venueId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            venueName = rs.getString("name");
        } else {
            response.sendRedirect("venue_customer.jsp");
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
                "INSERT INTO venue_bookings (venue_id, venue_name, customer_name, customer_phone, preferred_date, message) VALUES (?, ?, ?, ?, ?, ?)"
            );
            stmt.setInt(1, Integer.parseInt(venueId));
            stmt.setString(2, venueName);
            stmt.setString(3, request.getParameter("customer_name"));
            stmt.setString(4, request.getParameter("customer_phone"));
            stmt.setString(5, request.getParameter("preferred_date"));
            stmt.setString(6, request.getParameter("message"));

            int result = stmt.executeUpdate();
            message = result > 0 ? "✅ Your viewing request was submitted!" : "❌ Booking failed.";
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
    <title>Book Venue Viewing</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .form-box {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
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
    <h2>Book Viewing: <%= venueName %></h2>

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

        <button type="submit">Submit Request</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="venue_customer.jsp">← Back to Venues</a>
    </div>
</div>

</body>
</html>
