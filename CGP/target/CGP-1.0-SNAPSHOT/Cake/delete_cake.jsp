<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%
    String id = request.getParameter("id");
    String currentUser = (String) session.getAttribute("username");

    if (id != null && currentUser != null) {
        PreparedStatement ps = conn.prepareStatement("DELETE FROM cakes WHERE id = ? AND owner = ?");
        ps.setInt(1, Integer.parseInt(id));
        ps.setString(2, currentUser);
        int deleted = ps.executeUpdate();
        ps.close();
    }
    response.sendRedirect("cake_seller.jsp");
%>
