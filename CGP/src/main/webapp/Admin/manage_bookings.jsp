<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String service = request.getParameter("service");
    if (service == null || service.isEmpty()) {
        service = "attire"; // Default service
    }

    String tableName = "";
    String heading = "";

    switch (service) {
        case "attire":
            tableName = "attire_bookings";
            heading = "Attire Bookings";
            break;
        case "beautician":
            tableName = "beautician_bookings";
            heading = "Beautician Bookings";
            break;
        case "decoration":
            tableName = "decoration_bookings";
            heading = "Decoration Bookings";
            break;
        case "photography":
            tableName = "photography_bookings";
            heading = "Photography Bookings";
            break;
        case "venue":
            tableName = "venue_bookings";
            heading = "Venue Bookings";
            break;
        case "car":
            tableName = "car_bookings";
            heading = "Wedding Car Bookings";
            break;
        case "cake":
            tableName = "cake_orders";
            heading = "Cake Orders";
            break;
        default:
            tableName = "attire_bookings";
            heading = "Attire Bookings";
    }

    List<Map<String, String>> bookings = new ArrayList<>();
    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName);
        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();

        while (rs.next()) {
            Map<String, String> row = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                row.put(meta.getColumnName(i), rs.getString(i));
            }
            bookings.add(row);
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Bookings - Admin Panel</title>
        <link rel="stylesheet" href="../../css/styles.css">
        <style>
            :root {
                /* Color palette */
                --primary: #7B1FA2;
                --primary-light: #9C27B0;
                --primary-dark: #4A148C;
                --secondary: #FF9800;
                --success: #4CAF50;
                --info: #2196F3;
                --warning: #FFC107;
                --danger: #F44336;

                /* Neutral colors */
                --white: #FFFFFF;
                --gray-100: #F5F5F5;
                --gray-200: #EEEEEE;
                --gray-300: #E0E0E0;
                --gray-500: #9E9E9E;
                --gray-700: #616161;
                --gray-900: #212121;

                /* Spacing */
                --space-xs: 0.5rem;
                --space-sm: 1rem;
                --space-md: 1.5rem;
                --space-lg: 2rem;
                --space-xl: 3rem;

                /* Border radius */
                --radius-sm: 4px;
                --radius-md: 8px;
                --radius-lg: 12px;

                /* Shadows */
                --shadow-sm: 0 1px 3px rgba(0,0,0,0.12);
                --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
                --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);

                /* Transitions */
                --transition-fast: 0.15s ease;
                --transition-normal: 0.3s ease;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--gray-100);
                color: var(--gray-900);
                line-height: 1.6;
                padding: var(--space-md);
            }

            h2 {
                color: var(--primary-dark);
                font-size: 1.8rem;
                font-weight: 600;
                margin-bottom: var(--space-lg);
                display: flex;
                align-items: center;
                gap: var(--space-xs);
            }

            /* Navigation Bar Styles */
            .admin-navbar {
                background-color: var(--neutral-900);
                padding: var(--space-4) var(--space-6);
                margin-bottom: var(--space-6);
                border-radius: 8px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .admin-navbar-brand {
                color: white;
                font-weight: 600;
                font-size: 1.25rem;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: var(--space-3);
            }

            .admin-navbar-brand:hover {
                color: var(--neutral-200);
            }

            .admin-navbar-nav {
                display: flex;
                gap: var(--space-4);
                align-items: center;
            }

            .admin-nav-link {
                color: var(--neutral-200);
                text-decoration: none;
                font-weight: 500;
                padding: var(--space-2) var(--space-3);
                border-radius: 4px;
                transition: all var(--transition-fast);
                display: flex;
                align-items: center;
                gap: var(--space-2);
            }

            .admin-nav-link:hover {
                color: white;
                background-color: rgba(255, 255, 255, 0.1);
            }

            .admin-nav-link i {
                font-size: 1rem;
            }

            .admin-nav-link.active {
                color: white;
                background-color: var(--primary);
            }

            form {
                display: flex;
                align-items: center;
                gap: var(--space-sm);
                margin-bottom: var(--space-lg);
                background: var(--white);
                padding: var(--space-sm);
                border-radius: var(--radius-md);
                box-shadow: var(--shadow-sm);
                max-width: fit-content;
            }

            form label {
                font-weight: 500;
                color: var(--gray-700);
            }

            form select {
                padding: var(--space-xs) var(--space-sm);
                border: 1px solid var(--gray-300);
                border-radius: var(--radius-sm);
                font-size: 1rem;
                color: var(--gray-900);
                background-color: var(--white);
                transition: all var(--transition-fast);
                cursor: pointer;
            }

            form select:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 2px rgba(123, 31, 162, 0.2);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: var(--white);
                border-radius: var(--radius-md);
                box-shadow: var(--shadow-md);
                overflow: hidden;
            }

            th {
                background-color: var(--primary);
                color: var(--white);
                font-weight: 500;
                text-align: left;
                padding: var(--space-sm);
                text-transform: capitalize;
                position: sticky;
                top: 0;
            }

            td {
                padding: var(--space-sm);
                border-bottom: 1px solid var(--gray-200);
                vertical-align: middle;
            }

            tr:last-child td {
                border-bottom: none;
            }

            tr:nth-child(even) {
                background-color: var(--gray-100);
            }

            tr:hover {
                background-color: rgba(123, 31, 162, 0.05);
            }

            /* Status indicators */
            .status {
                display: inline-flex;
                align-items: center;
                padding: 0.25rem 0.5rem;
                border-radius: 2rem;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-pending {
                background-color: rgba(255, 152, 0, 0.1);
                color: var(--warning);
            }

            .status-confirmed {
                background-color: rgba(76, 175, 80, 0.1);
                color: var(--success);
            }

            .status-rejected {
                background-color: rgba(244, 67, 54, 0.1);
                color: var(--danger);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                body {
                    padding: var(--space-sm);
                }

                form {
                    flex-direction: column;
                    align-items: stretch;
                    max-width: 100%;
                }

                table {
                    display: block;
                    overflow-x: auto;
                }
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

                <a href='manage_services.jsp' style="
                   color: white;
                   text-decoration: none;
                   padding: 8px 12px;
                   background-color: #10B981;
                   border-radius: 6px;
                   font-weight: bold;
                   transition: 0.2s ease;
                   ">
                    🧰 Services
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
            </div>
        </nav>



        <h2><%= heading %></h2>

        <form method="get">
            <label>Select Service:</label>
            <select name="service" onchange="this.form.submit()">
                <option value="attire" <%= service.equals("attire") ? "selected" : "" %>>Attire</option>
                <option value="beautician" <%= service.equals("beautician") ? "selected" : "" %>>Beautician</option>
                <option value="decoration" <%= service.equals("decoration") ? "selected" : "" %>>Decoration</option>
                <option value="photography" <%= service.equals("photography") ? "selected" : "" %>>Photography</option>
                <option value="venue" <%= service.equals("venue") ? "selected" : "" %>>Venue</option>
                <option value="car" <%= service.equals("car") ? "selected" : "" %>>Car</option>
                <option value="cake" <%= service.equals("cake") ? "selected" : "" %>>Cake</option>
            </select>
        </form>

        <table>
            <tr>
                <% if (!bookings.isEmpty()) {
                for (String key : bookings.get(0).keySet()) { %>
                <th><%= key.replace("_", " ").toUpperCase() %></th>
                    <%  }
            } else { %>
                <th>No records found.</th>
                    <% } %>
            </tr>

            <% for (Map<String, String> row : bookings) { %>
            <tr>
                <% for (String value : row.values()) { %>
                <td><%= value %></td>
                <% } %>
            </tr>
            <% } %>
        </table>

    </body>
</html>
