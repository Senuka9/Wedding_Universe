<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String selectedService = request.getParameter("service");
    if (selectedService == null || selectedService.isEmpty()) {
        selectedService = "attire"; // default service
    }

    String tableName = "";
    Map<String, String> columnMap = new LinkedHashMap<>();
    String heading = "";

    switch (selectedService) {
        case "attire":
            tableName = "attire";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Price", "price");
            columnMap.put("Category", "category");
            heading = "Manage Attire";
            break;
        case "cake":
            tableName = "cakes";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Price", "price");
            columnMap.put("Category", "category");
            columnMap.put("Description", "description");
            heading = "Manage Cakes";
            break;
        case "beautician":
            tableName = "beautician_services";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Price", "price");
            columnMap.put("Package Type", "package");
            heading = "Manage Beautician";
            break;
        case "decoration":
            tableName = "decoration_services";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Theme", "theme");
            columnMap.put("Price", "price");
            columnMap.put("Location", "location");
            heading = "Manage Decorations";
            break;
        case "photography":
            tableName = "photography_services";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Package", "package");
            columnMap.put("Price", "price");
            heading = "Manage Photography";
            break;
        case "venue":
            tableName = "venues";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Type", "type");
            columnMap.put("Capacity", "capacity");
            columnMap.put("Price", "price");
            heading = "Manage Venues";
            break;
        case "car":
            tableName = "wedding_cars";
            columnMap.put("ID", "id");
            columnMap.put("Name", "name");
            columnMap.put("Car Type", "car_type");
            columnMap.put("Price", "price");
            columnMap.put("Features", "features");
            heading = "Manage Wedding Cars";
            break;
    }

    List<Map<String, String>> records = new ArrayList<>();

    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName);

        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();

        while (rs.next()) {
            Map<String, String> record = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                record.put(meta.getColumnName(i), rs.getString(i));
            }
            records.add(record);
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Services</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            table {
                width: 90%;
                border-collapse: collapse;
                margin: auto;
            }
            th, td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: purple;
                color: white;
            }
            td button {
                padding: 6px 10px;
                border: none;
                color: white;
                cursor: pointer;
            }
            .edit-btn {
                background-color: #4CAF50;
            }
            .delete-btn {
                background-color: #E53935;
            }
            h2 {
                text-align: center;
                color: purple;
            }
            form {
                text-align: center;
                margin-bottom: 20px;
            }
            select {
                padding: 6px 12px;
            }
        </style>
    </head>
    <body>
        <nav style="
             background-color: #111827;
             padding: 16px 32px;
             margin-bottom: 30px;
             border-radius: 8px;
             display: flex;
             justify-content: space-between;
             align-items: center;
             font-family: Arial, sans-serif;
             ">
            <a href='admin_home.jsp' style="
               color: white;
               text-decoration: none;
               font-size: 1.25rem;
               font-weight: bold;
               ">
                🛠 Admin Dashboard
            </a>

            <div style="display: flex; gap: 16px;">
                <a href='admin_home.jsp' style="
                   color: white;
                   text-decoration: none;
                   padding: 8px 12px;
                   background-color: #4F46E5;
                   border-radius: 6px;
                   font-weight: bold;
                   transition: 0.2s ease;
                   ">
                    🏠 Home
                </a>

                <a href='manage_users.jsp' style="
                   color: white;
                   text-decoration: none;
                   padding: 8px 12px;
                   background-color: #2196F3;
                   border-radius: 6px;
                   font-weight: bold;
                   transition: 0.2s ease;
                   ">
                    👤 Users
                </a>

                <a href='manage_bookings.jsp' style="
                   color: white;
                   text-decoration: none;
                   padding: 8px 12px;
                   background-color: #E91E63;
                   border-radius: 6px;
                   font-weight: bold;
                   transition: 0.2s ease;
                   ">
                    📋 Bookings
                </a>
            </div>
        </nav>


        <h2><%= heading %></h2>

        <form method="get">
            <label>Select Service: </label>
            <select name="service" onchange="this.form.submit()">
                <option value="attire" <%= selectedService.equals("attire") ? "selected" : "" %>>Attire</option>
                <option value="cake" <%= selectedService.equals("cake") ? "selected" : "" %>>Cake</option>
                <option value="beautician" <%= selectedService.equals("beautician") ? "selected" : "" %>>Beautician</option>
                <option value="decoration" <%= selectedService.equals("decoration") ? "selected" : "" %>>Decoration</option>
                <option value="photography" <%= selectedService.equals("photography") ? "selected" : "" %>>Photography</option>
                <option value="venue" <%= selectedService.equals("venue") ? "selected" : "" %>>Venue</option>
                <option value="car" <%= selectedService.equals("car") ? "selected" : "" %>>Car</option>
            </select>
        </form>

        <table>
            <tr>
                <% for (String displayCol : columnMap.keySet()) { %>
                <th><%= displayCol %></th>
                    <% } %>
                <th>Actions</th>
            </tr>

            <% for (Map<String, String> row : records) { %>
            <tr>
                <% for (String dbCol : columnMap.values()) { %>
                <td><%= row.getOrDefault(dbCol, "-") %></td>
                <% } %>
                <td>
                    <a href="edit_service.jsp?service=<%= selectedService %>&id=<%= row.get("id") %>">
                        <button class="edit-btn">Edit</button>
                    </a>
                    <a href="delete_service.jsp?service=<%= selectedService %>&id=<%= row.get("id") %>" onclick="return confirm('Are you sure you want to delete this item?');">
                        <button class="delete-btn">Delete</button>
                    </a>
                </td>
            </tr>
            <% } %>
        </table>
    </body>
</html>
