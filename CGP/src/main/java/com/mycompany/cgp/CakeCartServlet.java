package com.mycompany.cgp;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CakeCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cakeCart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        String action = request.getParameter("action");
        String cakeId = request.getParameter("cakeId");
        String cakeName = request.getParameter("cakeName") != null ? request.getParameter("cakeName") : "";
        String price = request.getParameter("price") != null ? request.getParameter("price") : "0";
        String image = request.getParameter("image") != null ? request.getParameter("image") : "";

        if ("add".equals(action)) {
            // Add to cart
            Map<String, String> item = new HashMap<>();
            item.put("id", cakeId);
            item.put("name", cakeName);
            item.put("price", price);
            item.put("image", image);
            item.put("quantity", "1");

            boolean alreadyExists = false;
            for (Map<String, String> i : cart) {
                if (i.get("id").equals(cakeId)) {
                    int qty = Integer.parseInt(i.get("quantity")) + 1;
                    i.put("quantity", String.valueOf(qty));
                    alreadyExists = true;
                    break;
                }
            }

            if (!alreadyExists) {
                cart.add(item);
            }
        } else if ("remove".equals(action)) {
            // Remove from cart
            cart.removeIf(i -> i.get("id").equals(cakeId));
        } else if ("updateQty".equals(action)) {
            String qty = request.getParameter("quantity");
            try {
                int q = Integer.parseInt(qty);
                if (q > 0) {
                    for (Map<String, String> i : cart) {
                        if (i.get("id").equals(cakeId)) {
                            i.put("quantity", String.valueOf(q));
                            break;
                        }
                    }
                }
            } catch (NumberFormatException e) {
                // silently ignore invalid qty
            }
        } else if ("clear".equals(action)) {
            cart.clear(); // remove all cakes
        }

        session.setAttribute("cakeCart", cart);
        response.sendRedirect("Cake/cake_cart.jsp");
    }
}
