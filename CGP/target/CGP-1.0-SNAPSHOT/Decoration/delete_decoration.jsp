<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !"seller".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String seller = (String) session.getAttribute("username");

    try {
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM decoration_services WHERE id = ? AND owner = ?");
        stmt.setString(1, id);
        stmt.setString(2, seller);
        stmt.executeUpdate();
        stmt.close();

        response.sendRedirect("decoration_seller.jsp");
    } catch (Exception e) {
        out.println("❌ Error deleting: " + e.getMessage());
    }
%>
