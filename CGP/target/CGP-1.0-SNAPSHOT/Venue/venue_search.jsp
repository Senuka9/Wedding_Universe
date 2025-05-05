<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String term = request.getParameter("term");
    List<Map<String, String>> venues = new ArrayList<>();

    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM venues WHERE status = 'active' AND name LIKE ?");
        stmt.setString(1, term + "%");
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> v = new HashMap<>();
            v.put("id", rs.getString("id"));
            v.put("name", rs.getString("name"));
            v.put("image", rs.getString("image"));
            v.put("rating", rs.getString("rating"));
            v.put("reviews", rs.getString("reviews"));
            v.put("price", rs.getString("price"));
            venues.add(v);
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error during search: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Search Venues</title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>

<div class="navbar">
    <div class="nav-container">
        <h1 class="logo">Dream Weddings</h1>
        <div class="nav-links">
            <a href="venue_customer.jsp" class="nav-link">Back to Venues</a>
        </div>
    </div>
</div>

<header class="hero">
    <h1>Search Results for "<%= term %>"</h1>
</header>

<main class="container">
    <% if (venues.isEmpty()) { %>
        <p style="text-align:center; margin-top: 30px;">No matching venues found.</p>
    <% } else { %>
        <div class="items-grid">
            <% for (Map<String, String> v : venues) { %>
            <div class="item-card">
                <img src="<%= v.get("image") %>" class="item-image">
                <div class="item-details">
                    <h4 class="item-name"><%= v.get("name") %></h4>
                    <div class="item-rating">★ <%= v.get("rating") %> (<%= v.get("reviews") %>)</div>
                    <div class="item-price"><%= v.get("price") %></div>
                    <a href="venue_detail.jsp?id=<%= v.get("id") %>" class="view-details">View Details</a>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</main>

</body>
</html>
