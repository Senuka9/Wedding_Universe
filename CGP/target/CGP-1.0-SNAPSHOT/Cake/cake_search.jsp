<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String term = request.getParameter("term");
    List<Map<String, String>> cakes = new ArrayList<>();

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cakes WHERE name LIKE ?");
        stmt.setString(1, term + "%");
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> cake = new HashMap<>();
            cake.put("id", rs.getString("id"));
            cake.put("name", rs.getString("name"));
            cake.put("description", rs.getString("description"));
            cake.put("price", rs.getString("price"));
            cake.put("rating", rs.getString("rating"));
            cake.put("image", rs.getString("image"));
            cakes.add(cake);
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Wedding Cake Search Results</title>
    <link rel="stylesheet" href="cake.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f6fd;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin-top: 30px;
            font-size: 28px;
            color: #1d1d1f;
        }

        .subtitle {
            text-align: center;
            color: #5D1D88;
            font-weight: bold;
            font-size: 18px;
        }

        .back-link {
            text-align: right;
            margin: 20px;
        }

        .back-link a {
            color: #5D1D88;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        .cakes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            padding: 2rem;
            max-width: 1200px;
            margin: auto;
        }

        .cake-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .cake-card:hover {
            transform: translateY(-5px);
        }

        .cake-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .cake-info {
            padding: 15px;
        }

        .cake-name {
            font-size: 18px;
            margin-bottom: 5px;
            color: #333;
        }

        .rating {
            font-size: 14px;
            color: #f0b429;
            margin-bottom: 6px;
        }

        .price {
            font-size: 16px;
            color: #9b59b6;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .view-details-btn {
            background-color: #9b59b6;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .view-details-btn:hover {
            background-color: #7a3da3;
        }
    </style>
</head>
<body>
            <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Dream Weddings</h1>
                <div class="nav-links">
                    <a href="CAKE.jsp" class="nav-link">Back to Cake</a>
                </div>
            </div>
        </div>


    <h1>Search Results for "<%= term %>"</h1>

    <div class="cakes-grid" id="cakes-container">
        <% if (cakes.isEmpty()) { %>
            <p style="text-align:center; color:#999;">No cakes found for "<%= term %>"</p>
        <% } else {
            for (Map<String, String> cake : cakes) { %>
            <div class="cake-card">
                <img src="<%= cake.get("image") %>" alt="cake" class="cake-image">
                <div class="cake-info">
                    <h3 class="cake-name"><%= cake.get("name") %></h3>
                    <div class="rating">⭐ <%= cake.get("rating") %></div>
                    <div class="price">$<%= cake.get("price") %></div>
                    <p><%= cake.get("description").length() > 60 
                            ? cake.get("description").substring(0, 60) + "..." 
                            : cake.get("description") %></p>
                    <a href="cake_detail.jsp?id=<%= cake.get("id") %>">
                        <button class="view-details-btn">View Details</button>
                    </a>
                </div>
            </div>
        <% }} %>
    </div>

</body>
</html>
