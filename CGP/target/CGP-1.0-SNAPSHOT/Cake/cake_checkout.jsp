<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cakeCart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cake_cart.jsp");
        return;
    }

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("customer_phone");

        for (Map<String, String> item : cart) {
            String id = item.get("id");
            String name = item.get("name");
            int qty = Integer.parseInt(item.get("quantity"));
            double price = Double.parseDouble(item.get("price"));
            double total = qty * price;
            String seller = "admin"; // replace with actual seller if stored

            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO cake_orders (cake_id, cake_name, quantity, price, total, customer_name, customer_phone, seller) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, id);
            stmt.setString(2, name);
            stmt.setInt(3, qty);
            stmt.setDouble(4, price);
            stmt.setDouble(5, total);
            stmt.setString(6, customerName);
            stmt.setString(7, phone);
            stmt.setString(8, seller); // optional: track which seller

            stmt.executeUpdate();
            stmt.close();
        }

        session.removeAttribute("cakeCart");
        message = "✅ Your cake order has been placed!";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <link rel="stylesheet" href="cake.css">
</head>
<body>
<div class="form-box">
    <h2 style="text-align:center;">Checkout - Confirm Order</h2>

    <% if (message.isEmpty()) { %>
        <form method="post">
            <label>Your Name</label>
            <input type="text" name="customer_name" required />

            <label>Phone Number</label>
            <input type="text" name="customer_phone" required maxlength="15" />

            <button type="submit">Place Order</button>
        </form>
    <% } else { %>
        <h3 style="text-align: center; color: green;"><%= message %></h3>
        <div style="text-align: center; margin-top: 20px;">
            <a href="CAKE.jsp" style="color: #B37CD9;">← Back to Cakes</a>
        </div>
    <% } %>
</div>
</body>
</html>
