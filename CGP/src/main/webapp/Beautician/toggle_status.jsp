<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("seller")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String newStatus = request.getParameter("status");
    String owner = (String) session.getAttribute("username");

    try {
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE beautician_services SET status=? WHERE id=? AND owner=?"
        );
        stmt.setString(1, newStatus);
        stmt.setString(2, id);
        stmt.setString(3, owner);

        stmt.executeUpdate();
        stmt.close();

        response.sendRedirect("beautician_seller.jsp");
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }
%>
