<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>
<%
    String season = request.getParameter("season");
    if (season == null || season.isEmpty()) {
        season = "all";
    }

    // Prepare maps for categories by location
    Map<String, List<Map<String, String>>> indoor = new HashMap<>();
    Map<String, List<Map<String, String>>> outdoor = new HashMap<>();

    indoor.put("Elegant Themes", new ArrayList<>());
    indoor.put("Modern Designs", new ArrayList<>());
    outdoor.put("Garden Themes", new ArrayList<>());
    outdoor.put("Beach & Resort", new ArrayList<>());

    try {
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT * FROM decoration_services WHERE status = 'active' AND (season = ? OR season = 'all')"
        );
        stmt.setString(1, season);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("description", rs.getString("description"));
            item.put("price", rs.getString("price"));
            item.put("rating", rs.getString("rating"));
            item.put("image", rs.getString("image"));
            item.put("features", rs.getString("features"));

            String location = rs.getString("location");
            String category = rs.getString("category");

            if ("Indoor".equals(location)) {
                indoor.get(category).add(item);
            } else {
                outdoor.get(category).add(item);
            }
        }

        rs.close();
        stmt.close();
    } catch (Exception e) {
        out.println("❌ Error loading decorations: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Decoration Services</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            .tag {
                display: inline-block;
                background: #eee;
                padding: 5px 10px;
                margin: 2px 4px 2px 0;
                border-radius: 4px;
                font-size: 13px;
            }
            .btn {
                background: var(--brown);
                color: white;
                padding: 8px 12px;
                border-radius: 6px;
                display: inline-block;
                margin-top: 10px;
                text-decoration: none;
            }
            #suggestionBox .autocomplete-item {
                padding: 10px;
                cursor: pointer;
                border-bottom: 1px solid #ddd;
                background-color: white;
            }
            #suggestionBox .autocomplete-item:hover {
                background-color: #f2f2f2;
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link active">Home</a>
                    <form action="search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="searchBar" placeholder="Search decorations..." 
                               autocomplete="off" style="padding: 10px; width: 300px; border-radius: 8px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 10px 16px; background: #a15c38; color: white; border-radius: 6px; border: none;">Search</button>
                        <div id="suggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
                    </form>


                    <% if (role == null) { %>
                    <!-- 👤 Login Icon Button (when logged out) -->
                    <a href="login.jsp">
                        <button class="account-btn" title="Login">👤</button>
                    </a>
                    <% } else { %>
                    <!-- User Dropdown (when logged in) -->
                    <div style="position: relative;">
                        <button class="account-btn" id="userDropdownBtn">👤</button>
                        <div id="userDropdownMenu" style="display: none; position: absolute; right: 0; top: 35px; background-color: white; box-shadow: 0 2px 6px rgba(0,0,0,0.2); border-radius: 5px; width: 150px;">
                            <div style="padding: 10px; border-bottom: 1px solid #eee;">
                                <strong><%= loggedUser %></strong><br>
                                <small><%= role %></small>
                            </div>
                            <a href="#" style="display: block; padding: 10px; text-decoration: none; color: black;" onmouseover="this.style.background = '#f0f0f0'" onmouseout="this.style.background = 'white'">Settings</a>
                            <a href="logout.jsp" style="display: block; padding: 10px; text-decoration: none; color: black;" onmouseover="this.style.background = '#f0f0f0'" onmouseout="this.style.background = 'white'">Logout</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </nav>

        <header class="hero">
            <h1>Decoration Services</h1>
            <p>Explore seasonal themes and signature styles for your wedding</p>
        </header>

        <main class="container">

            <div class="services-section">
                <h2>Indoor Decoration</h2>
                <div class="services-grid">

                    <% for (String cat : indoor.keySet()) {
                        List<Map<String, String>> items = indoor.get(cat);
                        if (!items.isEmpty()) {
                    %>
                    <div class="service-category">
                        <h3><%= cat %></h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : items) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image">
                                <div class="item-details">
                                    <h4><%= item.get("name") %></h4>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>

                                    <div>
                                        <% for (String tag : item.get("features").split(",")) { %>
                                        <span class="tag"><%= tag.trim() %></span>
                                        <% } %>
                                    </div>

                                    <a href="decoration_detail.jsp?id=<%= item.get("id") %>" class="btn">Book Now</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% }} %>

                </div>
            </div>

            <div class="services-section">
                <h2>Outdoor Decoration</h2>
                <div class="services-grid">

                    <% for (String cat : outdoor.keySet()) {
                        List<Map<String, String>> items = outdoor.get(cat);
                        if (!items.isEmpty()) {
                    %>
                    <div class="service-category">
                        <h3><%= cat %></h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : items) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image">
                                <div class="item-details">
                                    <h4><%= item.get("name") %></h4>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>

                                    <div>
                                        <% for (String tag : item.get("features").split(",")) { %>
                                        <span class="tag"><%= tag.trim() %></span>
                                        <% } %>
                                    </div>

                                    <a href="decoration_detail.jsp?id=<%= item.get("id") %>" class="btn">Book Now</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% }} %>

                </div>
            </div>
            <script>
                // User dropdown toggle
                document.addEventListener("DOMContentLoaded", function () {
                    const userBtn = document.getElementById("userDropdownBtn");
                    const menu = document.getElementById("userDropdownMenu");

                    if (userBtn && menu) {
                        userBtn.addEventListener("click", function (e) {
                            e.stopPropagation();
                            menu.style.display = menu.style.display === "block" ? "none" : "block";
                        });

                        document.addEventListener("click", function () {
                            menu.style.display = "none";
                        });
                    }
                });
                document.addEventListener("DOMContentLoaded", function () {
                    const searchInput = document.getElementById("searchBar");
                    const suggestionBox = document.getElementById("suggestionBox");

                    function fetchSuggestions(term = "") {
                        fetch("decoration_suggestions.jsp?term=" + encodeURIComponent(term))
                                .then(res => res.json())
                                .then(data => {
                                    suggestionBox.innerHTML = "";
                                    if (data.length === 0) {
                                        suggestionBox.style.display = "none";
                                        return;
                                    }

                                    data.forEach(name => {
                                        const item = document.createElement("div");
                                        item.textContent = name;
                                        item.className = "autocomplete-item";
                                        item.addEventListener("click", () => {
                                            searchInput.value = name;
                                            suggestionBox.style.display = "none";
                                            searchInput.form.submit();
                                        });
                                        suggestionBox.appendChild(item);
                                    });
                                    suggestionBox.style.display = "block";
                                })
                                .catch(err => {
                                    console.error("Suggestion error:", err);
                                    suggestionBox.style.display = "none";
                                });
                    }

                    searchInput.addEventListener("click", () => fetchSuggestions());
                    searchInput.addEventListener("input", function () {
                        if (this.value.trim() === "") {
                            fetchSuggestions(); // show top 5 if nothing typed
                        } else {
                            fetchSuggestions(this.value);
                        }
                    });

                    document.addEventListener("click", function (e) {
                        if (!suggestionBox.contains(e.target) && e.target !== searchInput) {
                            suggestionBox.style.display = "none";
                        }
                    });
                });
            </script>
        </main>

    </body>
</html>
