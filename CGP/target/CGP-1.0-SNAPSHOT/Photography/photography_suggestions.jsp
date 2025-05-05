<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="application/json" %>

<%
    String term = request.getParameter("term");
    List<String> results = new ArrayList<>();

    try {
        PreparedStatement stmt;
        if (term != null && !term.trim().isEmpty()) {
            stmt = conn.prepareStatement("SELECT name FROM photography_services WHERE name LIKE ? AND status = 'active' LIMIT 5");
            stmt.setString(1, term + "%");
        } else {
            stmt = conn.prepareStatement("SELECT name FROM photography_services WHERE status = 'active' LIMIT 5");
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            results.add(rs.getString("name").replace("\"", "\\\""));
        }
        rs.close();
        stmt.close();
    } catch (Exception e) {
        results.add("Error: " + e.getMessage());
    }

    out.print("[" + String.join(",", results.stream().map(s -> "\"" + s + "\"").toArray(String[]::new)) + "]");
%>
