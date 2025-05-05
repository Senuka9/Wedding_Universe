<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Map<String, String>> users = new ArrayList<>();
    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users");

        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("id", rs.getString("id"));
            user.put("username", rs.getString("username"));
            user.put("email", rs.getString("email"));
            user.put("role", rs.getString("role"));
            users.add(user);
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
        <title>Manage Users - Admin</title>
        <style>
            :root {
                /* Color System */
                --primary: #4F46E5;
                --primary-light: #818CF8;
                --primary-dark: #3730A3;

                --neutral-50: #F9FAFB;
                --neutral-100: #F3F4F6;
                --neutral-200: #E5E7EB;
                --neutral-300: #D1D5DB;
                --neutral-500: #6B7280;
                --neutral-700: #374151;
                --neutral-900: #111827;

                --success: #10B981;
                --warning: #F59E0B;
                --error: #EF4444;
                --info: #3B82F6;

                /* Shadows */
                --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
                --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);

                /* Spacing (8px system) */
                --space-1: 0.25rem;  /* 4px */
                --space-2: 0.5rem;   /* 8px */
                --space-3: 0.75rem;  /* 12px */
                --space-4: 1rem;     /* 16px */
                --space-6: 1.5rem;   /* 24px */
                --space-8: 2rem;     /* 32px */
                --space-12: 3rem;    /* 48px */

                /* Transitions */
                --transition-fast: 150ms ease;
                --transition-normal: 250ms ease;
            }

            /* Typography & General Styles */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                line-height: 1.5;
                background-color: var(--neutral-100);
                color: var(--neutral-700);
                padding: var(--space-6);
                margin: 0;
            }

            h1, h2, h3, h4 {
                line-height: 1.2;
                color: var(--neutral-900);
                font-weight: 600;
            }

            h1 {
                font-size: 1.875rem;
                margin-bottom: var(--space-8);
                position: relative;
                padding-bottom: var(--space-4);
                text-align: left;
            }

            h1::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 64px;
                height: 4px;
                background-color: var(--primary);
                border-radius: 2px;
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

            /* Container Styles */
            .admin-container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 12px;
                box-shadow: var(--shadow);
                padding: var(--space-6);
                overflow: hidden;
            }

            /* Table Styles */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin-top: var(--space-6);
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: var(--shadow);
            }

            th, td {
                padding: var(--space-4) var(--space-4);
                text-align: left;
                border-bottom: 1px solid var(--neutral-200);
            }

            th {
                background: var(--neutral-900);
                color: white;
                font-weight: 500;
                letter-spacing: 0.02em;
                text-transform: uppercase;
                font-size: 0.8125rem;
            }

            th:first-child {
                border-top-left-radius: 8px;
            }

            th:last-child {
                border-top-right-radius: 8px;
            }

            tr:last-child td {
                border-bottom: none;
            }

            tr:hover {
                background: var(--neutral-50);
                transition: background-color var(--transition-fast);
            }

            td {
                vertical-align: middle;
                color: var(--neutral-700);
            }

            /* ID Column */
            td:first-child {
                font-family: SFMono-Regular, Menlo, Monaco, Consolas, monospace;
                font-size: 0.8125rem;
                color: var(--neutral-500);
            }

            /* Role Badge */
            td:nth-child(4) {
                position: relative;
            }

            td:nth-child(4)::before {
                content: '';
                display: inline-block;
                width: 8px;
                height: 8px;
                border-radius: 50%;
                margin-right: var(--space-2);
            }

            td:nth-child(4)[data-role="admin"]::before {
                background-color: var(--primary);
            }

            td:nth-child(4)[data-role="user"]::before {
                background-color: var(--info);
            }

            td:nth-child(4)[data-role="editor"]::before {
                background-color: var(--success);
            }

            td:nth-child(4)[data-role="guest"]::before {
                background-color: var(--neutral-300);
            }

            /* Action Links & Buttons */
            a {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                transition: color var(--transition-fast);
                padding: var(--space-2) var(--space-3);
                border-radius: 6px;
                display: inline-block;
            }

            a:hover {
                color: var(--primary-dark);
                background-color: var(--neutral-100);
            }

            .btn-delete {
                background: white;
                color: var(--error);
                padding: var(--space-2) var(--space-3);
                border: 1px solid var(--error);
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.875rem;
                transition: all var(--transition-normal);
            }

            .btn-delete:hover {
                background: var(--error);
                color: white;
                box-shadow: var(--shadow-sm);
            }

            /* Top Action Bar */
            .action-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: var(--space-6);
            }

            .btn-add {
                background: var(--primary);
                color: white;
                border: none;
                border-radius: 6px;
                padding: var(--space-2) var(--space-4);
                font-weight: 500;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: var(--space-2);
                transition: background-color var(--transition-normal), transform var(--transition-fast);
            }

            .btn-add:hover {
                background: var(--primary-dark);
                transform: translateY(-1px);
            }

            .btn-add:active {
                transform: translateY(0);
            }

            /* Search Box */
            .search-box {
                position: relative;
                max-width: 320px;
            }

            .search-box input {
                width: 100%;
                padding: var(--space-2) var(--space-4);
                padding-left: var(--space-8);
                border: 1px solid var(--neutral-300);
                border-radius: 6px;
                font-size: 0.875rem;
                transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
            }

            .search-box input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
            }

            .search-box::before {
                content: '🔍';
                position: absolute;
                left: var(--space-3);
                top: 50%;
                transform: translateY(-50%);
                color: var(--neutral-500);
                font-size: 0.875rem;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: var(--space-12);
                color: var(--neutral-500);
            }

            .empty-state p {
                margin-top: var(--space-4);
                margin-bottom: var(--space-6);
            }

            /* Loading State */
            .loading {
                text-align: center;
                padding: var(--space-8);
            }

            .loading-spinner {
                display: inline-block;
                width: 40px;
                height: 40px;
                border: 3px solid var(--neutral-200);
                border-radius: 50%;
                border-top-color: var(--primary);
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: var(--space-6);
                gap: var(--space-2);
            }

            .pagination button {
                background: white;
                border: 1px solid var(--neutral-300);
                border-radius: 6px;
                padding: var(--space-2) var(--space-3);
                cursor: pointer;
                transition: all var(--transition-normal);
            }

            .pagination button:hover {
                border-color: var(--primary);
                color: var(--primary);
            }

            .pagination button.active {
                background: var(--primary);
                color: white;
                border-color: var(--primary);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                body {
                    padding: var(--space-3);
                }

                .admin-container {
                    padding: var(--space-3);
                }

                table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }

                .action-bar {
                    flex-direction: column;
                    align-items: stretch;
                    gap: var(--space-3);
                }

                .search-box {
                    max-width: none;
                    margin-bottom: var(--space-3);
                }

                th, td {
                    padding: var(--space-3) var(--space-2);
                }

                .btn-delete, a {
                    padding: var(--space-1) var(--space-2);
                    font-size: 0.8125rem;
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


        <h1>Manage Users</h1>

        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Update</th>
                <th>Delete</th>
            </tr>
            <% for (Map<String, String> user : users) { %>
            <tr>
                <td><%= user.get("id") %></td>
                <td><%= user.get("username") %></td>
                <td><%= user.get("email") %></td>
                <td><%= user.get("role") %></td>
                <td>
                    <a href="update_user.jsp?id=<%= user.get("id") %>">Edit</a>
                </td>

                <td>
                    <form method="post" action="delete_user.jsp" style="display:inline;">
                        <input type="hidden" name="id" value="<%= user.get("id") %>">
                        <button type="submit" class="btn-delete">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    </body>
</html>
