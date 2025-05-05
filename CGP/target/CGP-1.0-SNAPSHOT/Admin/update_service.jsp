<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%
    String service = request.getParameter("service");
    String id = request.getParameter("id");
    String table = "";

    // Correct table names
    switch (service) {
        case "cake": table = "cakes"; break;
        case "attire": table = "attire"; break;
        case "car": table = "wedding_cars"; break;
        case "beautician": table = "beautician_services"; break;
        case "photography": table = "photography_services"; break;
        case "venue": table = "venues"; break;
        case "decoration": table = "decoration_services"; break;
    }

    if (table != null && id != null) {
        Enumeration<String> paramNames = request.getParameterNames();
        List<String> columns = new ArrayList<>();
        List<String> values = new ArrayList<>();

        while (paramNames.hasMoreElements()) {
            String param = paramNames.nextElement();
            if (!param.equals("id") && !param.equals("service")) {
                columns.add(param);
                values.add(request.getParameter(param));
            }
        }

        if (!columns.isEmpty()) {
            StringBuilder sql = new StringBuilder("UPDATE " + table + " SET ");

            for (int i = 0; i < columns.size(); i++) {
                sql.append(columns.get(i)).append("=?");
                if (i < columns.size() - 1) {
                    sql.append(", ");
                }
            }

            sql.append(" WHERE id=?");

            try {
                PreparedStatement pstmt = conn.prepareStatement(sql.toString());

                // Bind the parameters
                for (int i = 0; i < values.size(); i++) {
                    pstmt.setString(i + 1, values.get(i));
                }

                pstmt.setInt(values.size() + 1, Integer.parseInt(id));
                pstmt.executeUpdate();
                pstmt.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    response.sendRedirect("manage_services.jsp?service=" + service);
%>
