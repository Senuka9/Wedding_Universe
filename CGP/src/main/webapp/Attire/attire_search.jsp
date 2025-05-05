<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String term = request.getParameter("term");
    List<Map<String, String>> results = new ArrayList<>();

    try {
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT * FROM attire WHERE status = 'active' AND name LIKE ?"
        );
        stmt.setString(1, term + "%");
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("image", rs.getString("image"));
            item.put("rating", rs.getString("rating"));
            item.put("price", rs.getString("price"));
            results.add(item);
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
        <title>Search Results - Wedding Attire</title>
        <style>
            /* Enhanced Wedding Theme Styles */
            :root {
                --primary: #9333ea;
                --primary-light: #f8f4ff;
                --text-dark: #1e293b;
                --text-light: #64748b;
                --bg-light: #f8fafc;
                --border: #e2e8f0;
            }

            /* Base Styles */
            body {
                font-family: 'Inter', system-ui, -apple-system, sans-serif;
                line-height: 1.5;
                color: var(--text-dark);
                background-color: var(--bg-light);
                margin: 0;
            }

            /* Navigation */
            .navbar {
                background: white;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 50;
            }

            .nav-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 1rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .logo {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                color: var(--primary);
                margin: 0;
            }

            .nav-links {
                display: flex;
                gap: 2rem;
                align-items: center;
            }

            .nav-link {
                color: var(--text-dark);
                text-decoration: none;
                font-weight: 500;
                transition: color 0.2s;
            }

            .nav-link:hover {
                color: var(--primary);
            }

            /* Hero Section */
            .hero {
                background: linear-gradient(to right, rgba(147, 51, 234, 0.05), rgba(147, 51, 234, 0.1));
                padding: 3rem 1rem;
                text-align: center;
                margin-bottom: 2rem;
            }

            .hero h1 {
                font-family: 'Playfair Display', serif;
                font-size: 2.5rem;
                color: var(--text-dark);
                margin: 0;
            }

            /* Main Container */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            /* Attire Grid */
            .attire-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 2rem;
                padding: 2rem 0;
            }

            /* Item Cards */
            .item-card {
                background: white;
                border-radius: 1rem;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .item-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 12px rgba(0, 0, 0, 0.1);
            }

            .item-image {
                width: 100%;
                height: 300px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .item-card:hover .item-image {
                transform: scale(1.05);
            }

            .item-details {
                padding: 1.5rem;
            }

            .item-name {
                font-size: 1.25rem;
                font-weight: 600;
                margin: 0 0 0.75rem;
                color: var(--text-dark);
                line-height: 1.4;
            }

            .item-rating {
                color: #eab308;
                font-weight: 500;
                margin-bottom: 0.75rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .item-rating::before {
                content: '★';
                color: #eab308;
            }

            .item-price {
                font-size: 1.375rem;
                font-weight: 600;
                color: var(--primary);
                margin-bottom: 1.25rem;
            }

            .view-details {
                display: inline-block;
                width: 100%;
                padding: 0.75rem 0.5rem;
                background: var(--primary);
                color: white;
                text-decoration: none;
                border-radius: 9999px;
                font-weight: 500;
                text-align: center;
                transition: all 0.2s ease;
            }

            .view-details:hover {
                background: #7e22ce;
                transform: translateY(-2px);
            }

            /* Empty State */
            .container p {
                text-align: center;
                color: var(--text-light);
                font-size: 1.125rem;
                padding: 3rem 1rem;
                background: white;
                border-radius: 1rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .hero h1 {
                    font-size: 2rem;
                }

                .nav-container {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }

                .nav-links {
                    flex-direction: column;
                    gap: 1rem;
                }

                .attire-grid {
                    grid-template-columns: 1fr;
                    padding: 1rem 0;
                }

                .item-image {
                    height: 250px;
                }
            }

           </style>
    </head>
    <body>

        <div class="navbar">
            <div class="nav-container">
                <h1 class="logo">Dream Weddings</h1>
                <div class="nav-links">
                    <a href="attire_customer.jsp" class="nav-link">Back to Attire</a>
                </div>
            </div>
        </div>

        <header class="hero">
            <h1>Search Results for "<%= term %>"</h1>
        </header>

        <main class="container">
            <% if (results.isEmpty()) { %>
            <p style="text-align:center; margin-top: 30px;">No matching attire found.</p>
            <% } else { %>
            <div class="attire-grid">
                <% for (Map<String, String> item : results) { %>
                <div class="item-card">
                    <img src="<%= item.get("image") %>" class="item-image">
                    <div class="item-details">
                        <h4 class="item-name"><%= item.get("name") %></h4>
                        <div class="item-rating">★ <%= item.get("rating") %></div>
                        <div class="item-price">$<%= item.get("price") %></div>
                        <a href="attire_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </main>

    </body>
</html>
