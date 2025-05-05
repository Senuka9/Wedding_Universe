<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String seller = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Car Bookings - Seller View</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
        }

        table {
            margin: 40px auto;
            width: 95%;
            background: white;
            border-collapse: collapse;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: purple;
            color: white;
        }

        .btn {
            padding: 6px 12px;
            font-size: 14px;
            border-radius: 6px;
            text-decoration: none;
            margin: 2px;
            font-weight: bold;
        }

        .btn-confirm {
            background-color: green;
            color: white;
        }

        .btn-reject {
            background-color: red;
            color: white;
        }

        .btn-disabled {
            background-color: grey;
            color: white;
            pointer-events: none;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">🚗 Car Booking Requests</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Car</th>
        <th>Customer</th>
        <th>Phone</th>
        <th>Date</th>
        <th>Message</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <%
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT b.*, c.owner FROM car_bookings b JOIN wedding_cars c ON b.car_id = c.id WHERE c.owner = ? ORDER BY b.created_at DESC"
            );
            stmt.setString(1, seller);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String status = rs.getString("status");
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("car_name") %></td>
        <td><%= rs.getString("customer_name") %></td>
        <td><%= rs.getString("customer_phone") %></td>
        <td><%= rs.getString("preferred_date") %></td>
        <td><%= rs.getString("message") == null ? "-" : rs.getString("message") %></td>
        <td><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></td>
        <td>
            <% if ("pending".equals(status)) { %>
                <a href="update_car_booking_status.jsp?id=<%= rs.getInt("id") %>&status=confirmed" class="btn btn-confirm">✔ Confirm</a>
                <a href="update_car_booking_status.jsp?id=<%= rs.getInt("id") %>&status=rejected" class="btn btn-reject">✘ Reject</a>
            <% } else { %>
                <span class="btn btn-disabled"><%= status %></span>
            <% } %>
        </td>
    </tr>
    <%
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            out.println("❌ Error: " + e.getMessage());
        }
    %>
</table>

</body>
</html>
