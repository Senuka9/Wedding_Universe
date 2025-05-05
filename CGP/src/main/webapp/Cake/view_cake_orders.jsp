<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Cake Orders</title>
    <link rel="stylesheet" href="cake.css">
</head>
<body>
<h2 style="text-align:center;">🎂 Cake Orders Received</h2>
<table border="1" style="width: 95%; margin: auto;">
    <tr>
        <th>Order ID</th>
        <th>Cake</th>
        <th>Qty</th>
        <th>Price</th>
        <th>Total</th>
        <th>Customer</th>
        <th>Phone</th>
        <th>Ordered At</th>
    </tr>
<%
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM cake_orders ORDER BY ordered_at DESC");

    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("cake_name") %></td>
        <td><%= rs.getInt("quantity") %></td>
        <td>$<%= rs.getDouble("price") %></td>
        <td>$<%= rs.getDouble("total") %></td>
        <td><%= rs.getString("customer_name") %></td>
        <td><%= rs.getString("customer_phone") %></td>
        <td><%= rs.getTimestamp("ordered_at") %></td>
    </tr>
<% } rs.close(); stmt.close(); %>
</table>
</body>
</html>
