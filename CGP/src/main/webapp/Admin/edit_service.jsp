<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="../db.jsp" %>
<%
    String service = request.getParameter("service");
    String id = request.getParameter("id");
    String table = "";
    switch(service) {
        case "cake": table = "cakes"; break;
        case "attire": table = "attire"; break;
        case "car": table = "wedding_cars"; break;
        case "beautician": table = "beautician_services"; break;
        case "photography": table = "photography_services"; break;
        case "venue": table = "venues"; break;
        case "decoration": table = "decoration_services"; break;
    }

    Map<String, String> record = new HashMap<>();
    if (id != null && table != "") {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " WHERE id = " + id);
        ResultSetMetaData meta = rs.getMetaData();
        if (rs.next()) {
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                record.put(meta.getColumnName(i), rs.getString(i));
            }
        }
        rs.close();
        stmt.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit <%= service %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            --gray-50: #FAFAFA;
            --gray-100: #F5F5F5;
            --gray-200: #EEEEEE;
            --gray-300: #E0E0E0;
            --gray-400: #BDBDBD;
            --gray-500: #9E9E9E;
            --gray-600: #757575;
            --gray-700: #616161;
            --gray-800: #424242;
            --gray-900: #212121;
            
            /* Spacing */
            --space-xs: 0.25rem;
            --space-sm: 0.5rem;
            --space-md: 1rem;
            --space-lg: 1.5rem;
            --space-xl: 2rem;
            
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--gray-50);
            color: var(--gray-800);
            line-height: 1.6;
            padding: var(--space-xl);
        }

        .edit-container {
            max-width: 800px;
            margin: 0 auto;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .edit-header {
            background-color: var(--primary);
            color: var(--white);
            padding: var(--space-lg);
            text-align: center;
        }

        .edit-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: var(--space-sm);
        }

        .edit-header i {
            font-size: 1.25rem;
        }

        .edit-form {
            padding: var(--space-xl);
        }

        .form-group {
            margin-bottom: var(--space-lg);
        }

        .form-group label {
            display: block;
            margin-bottom: var(--space-sm);
            font-weight: 500;
            color: var(--gray-700);
        }

        .form-control {
            width: 100%;
            padding: var(--space-md);
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            transition: all var(--transition-fast);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(123, 31, 162, 0.2);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: var(--space-md);
            margin-top: var(--space-xl);
        }

        .btn {
            padding: var(--space-md) var(--space-lg);
            border-radius: var(--radius-sm);
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-normal);
            border: none;
            display: inline-flex;
            align-items: center;
            gap: var(--space-sm);
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-secondary {
            background-color: var(--gray-200);
            color: var(--gray-800);
        }

        .btn-secondary:hover {
            background-color: var(--gray-300);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            body {
                padding: var(--space-md);
            }

            .edit-container {
                border-radius: 0;
            }

            .edit-form {
                padding: var(--space-lg);
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <div class="edit-header">
            <h2>
                <i class="fas fa-edit"></i>
                Edit <%= service.substring(0, 1).toUpperCase() + service.substring(1) %> #<%= id %>
            </h2>
        </div>

        <form method="post" action="update_service.jsp" class="edit-form">
            <input type="hidden" name="service" value="<%= service %>">
            <input type="hidden" name="id" value="<%= id %>">
            
            <% for (Map.Entry<String, String> entry : record.entrySet()) {
                String key = entry.getKey();
                if (!key.equals("id")) {
            %>
                <div class="form-group">
                    <label for="<%= key %>"><%= key.substring(0, 1).toUpperCase() + key.substring(1).replace("_", " ") %></label>
                    <input type="text" id="<%= key %>" name="<%= key %>" value="<%= entry.getValue() %>" class="form-control">
                </div>
            <% }} %>
            
            <div class="form-actions">
                <a href="manage_services.jsp?service=<%= service %>" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update
                </button>
            </div>
        </form>
    </div>
</body>
</html>