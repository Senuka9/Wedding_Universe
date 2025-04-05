<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/cgp";
    String username = "root";
    String password = ""; // Add password if needed

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        application.setAttribute("conn", conn);
    } catch (Exception e) {
        out.println("Connection Error: " + e.getMessage());
    }
%>
