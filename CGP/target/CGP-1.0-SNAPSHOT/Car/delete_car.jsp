<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String seller = (String) session.getAttribute("username");

    try {
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM wedding_cars WHERE id = ? AND owner = ?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        stmt.executeUpdate();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error deleting car: " + e.getMessage());
    }

    response.sendRedirect("car_seller.jsp");
%>
