<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String serviceId = request.getParameter("id");
    String name = "", message = "";

    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        stmt = conn.prepareStatement("SELECT name FROM beautician_services WHERE id = ? AND status = 'active'");
        stmt.setString(1, serviceId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
        } else {
            out.println("<h3>❌ Invalid or inactive service.</h3>");
            return;
        }
    } catch (Exception e) {
        out.println("❌ Error loading service: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book <%= name %> - Dream Weddings</title>
    <link rel="stylesheet" href="styles.css" />
    <style>
        .form-box {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
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
    <h2>Book: <%= name %></h2>

    <%
        String statusMsg = "";

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                String customerName = request.getParameter("customer_name");
                String phone = request.getParameter("phone");
                String date = request.getParameter("preferred_date");
                String note = request.getParameter("note");

                PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO beautician_bookings (service_id, service_name, customer_name, customer_phone, preferred_date, message) VALUES (?, ?, ?, ?, ?, ?)"
                );
                insert.setInt(1, Integer.parseInt(serviceId));
                insert.setString(2, name);
                insert.setString(3, customerName);
                insert.setString(4, phone);
                insert.setString(5, date);
                insert.setString(6, note);

                int result = insert.executeUpdate();
                statusMsg = result > 0 ? "✅ Booking request sent!" : "❌ Failed to book.";
                insert.close();
            } catch (Exception e) {
                statusMsg = "❌ Error: " + e.getMessage();
            }
        }
    %>

    <% if (!statusMsg.isEmpty()) { %>
        <p class="success"><%= statusMsg %></p>
    <% } %>

    <form method="post">
        <label>Your Full Name</label>
        <input type="text" name="customer_name" required>

        <label>Phone Number</label>
        <input type="text" name="phone" maxlength="15" required>

        <label>Preferred Date</label>
        <input type="date" name="preferred_date" required>

        <label>Additional Message (Optional)</label>
        <textarea name="note" rows="4"></textarea>

        <button type="submit">Send Booking Request</button>
    </form>

    <div style="text-align:center; margin-top: 20px;">
        <a href="beautician_customer.jsp">← Back to Services</a>
    </div>
</div>

</body>
</html>
