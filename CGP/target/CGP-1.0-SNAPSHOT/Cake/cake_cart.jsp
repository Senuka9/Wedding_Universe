<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cakeCart");
    if (cart == null) cart = new ArrayList<>();
    double total = 0;
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Cake Cart</title>
        <link rel="stylesheet" href="cake.css">
        <style>button {
                padding: 5px 10px;
                background-color: var(--primary, #B37CD9);
                border: none;
                color: white;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
            }

            button:disabled {
                background-color: grey;
                cursor: not-allowed;
            }

            form span {
                min-width: 25px;
                display: inline-block;
                text-align: center;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <h2 style="text-align:center;">🛒 Your Cake Cart</h2>

        <table border="1" style="margin:auto; width:90%; text-align:center;">
            <tr>
                <th>Image</th>
                <th>Cake</th>
                <th>Price</th>
                <th>Qty</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
            <% for (Map<String, String> item : cart) {
                double itemTotal = Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity"));
                total += itemTotal;
            %>
            <tr>
                <td><img src="<%= item.get("image") %>" width="80" /></td>
                <td><%= item.get("name") %></td>
                <td>$<%= item.get("price") %></td>
                <td><%= item.get("quantity") %></td>
                <td>$<%= String.format("%.2f", itemTotal) %></td>
                <td>
                    <form method="post" action="../CakeCartServlet" style="display: flex; justify-content: center; align-items: center; gap: 5px;">
                        <input type="hidden" name="action" value="updateQty" />
                        <input type="hidden" name="cakeId" value="<%= item.get("id") %>" />

                        <button type="submit" name="quantity" value="<%= Integer.parseInt(item.get("quantity")) - 1 %>" <%= Integer.parseInt(item.get("quantity")) <= 1 ? "disabled" : "" %>>−</button>

                        <span><%= item.get("quantity") %></span>

                        <button type="submit" name="quantity" value="<%= Integer.parseInt(item.get("quantity")) + 1 %>">+</button>
                    </form>

                </td>
            </tr>
            <% } %>
            <tr>
                <td colspan="4" style="text-align:right;"><strong>Grand Total:</strong></td>
                <td colspan="2"><strong>$<%= String.format("%.2f", total) %></strong></td>
            </tr>
            <tr>
                <td colspan="6" style="text-align:center; padding: 20px;">
                    <form method="post" action="../CakeCartServlet" style="display:inline;">
                        <input type="hidden" name="action" value="clear" />
                        <button type="submit" style="background:red; color:white; padding:8px 16px; border:none; border-radius:5px;">🗑️ Clear Cart</button>
                    </form>

                    <a href="cake_checkout.jsp" style="background:green; color:white; padding:8px 16px; border-radius:5px; text-decoration:none; margin-left: 10px;">✅ Proceed to Checkout</a>
                </td>
            </tr>

        </table>

        <div style="text-align:center; margin-top: 20px;">
            <a href="CAKE.jsp">← Continue Shopping</a>
        </div>
    </body>
</html>
