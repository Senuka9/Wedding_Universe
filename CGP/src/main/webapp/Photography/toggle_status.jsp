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
    String seller = (String) session.getAttribute("username");

    try {
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE photography_services SET status = ? WHERE id = ? AND owner = ?"
        );
        stmt.setString(1, newStatus);
        stmt.setString(2, id);
        stmt.setString(3, seller);
        stmt.executeUpdate();
        stmt.close();

        response.sendRedirect("photography_seller.jsp");
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }
%>
