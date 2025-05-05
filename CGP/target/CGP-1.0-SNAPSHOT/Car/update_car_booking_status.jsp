<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String newStatus = request.getParameter("status");

    try {
        PreparedStatement stmt = conn.prepareStatement("UPDATE car_bookings SET status = ? WHERE id = ?");
        stmt.setString(1, newStatus);
        stmt.setString(2, id);
        stmt.executeUpdate();
        stmt.close();

        response.sendRedirect("view_car_bookings.jsp");
    } catch (Exception e) {
        out.println("❌ Error updating booking: " + e.getMessage());
    }
%>
