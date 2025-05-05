<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%
    String id = request.getParameter("id");
    String service = request.getParameter("service");
    String table = "";
    switch(service) {
        case "cake": table = "cakes"; break;
        case "attire": table = "attire"; break;
        case "car": table = "wedding_cars"; break;
        // Add others
    }

    if (id != null && table != null) {
        Statement stmt = conn.createStatement();
        stmt.executeUpdate("DELETE FROM " + table + " WHERE id = " + id);
        stmt.close();
    }

    response.sendRedirect("manage_services.jsp?service=" + service);
%>
