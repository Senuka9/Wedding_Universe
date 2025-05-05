<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Ensure only sellers can delete
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("seller")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // No duplicate variable declaration here
    String id = request.getParameter("id");

    try {
        String owner = (String) session.getAttribute("username");

        PreparedStatement stmt = conn.prepareStatement(
            "DELETE FROM attire WHERE id = ? AND owner = ?"
        );
        stmt.setString(1, id);
        stmt.setString(2, owner);

        int result = stmt.executeUpdate();
        stmt.close();

        response.sendRedirect("attire_seller.jsp");
    } catch (Exception e) {
        out.println("❌ Error deleting attire: " + e.getMessage());
    }
%>

