<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String bookingId = request.getParameter("id");
    String newStatus = request.getParameter("status");

    if (bookingId != null && newStatus != null) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE attire_bookings SET status = ? WHERE id = ?"
            );
            stmt.setString(1, newStatus);
            stmt.setString(2, bookingId);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            out.println("❌ Error: " + e.getMessage());
        }
    }

    response.sendRedirect("attire_booking_view.jsp");
%>
