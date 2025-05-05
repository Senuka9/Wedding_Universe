<%@ include file="../db.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String userId = request.getParameter("id");

    try {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?");
        ps.setString(1, userId);
        ps.executeUpdate();
        response.sendRedirect("manage_users.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error deleting user.");
    }
%>
