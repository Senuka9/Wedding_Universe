<%@ page import="java.sql.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>

<%
    ResultSet rs = null;
    Statement stmt = null;

    // Prepare lists for each category
    List<Map<String, String>> bridalGowns = new ArrayList<>();
    List<Map<String, String>> flowerGirlDresses = new ArrayList<>();
    List<Map<String, String>> groomSuits = new ArrayList<>();
    List<Map<String, String>> ringBearerOutfits = new ArrayList<>();

    try {
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM attire WHERE status = 'active'");

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("image", rs.getString("image"));
            item.put("rating", rs.getString("rating"));
            item.put("price", rs.getString("price"));

            String category = rs.getString("category");
            switch (category) {
                case "Bridal Gowns": bridalGowns.add(item); break;
                case "Flower Girl Dresses": flowerGirlDresses.add(item); break;
                case "Groom Suits": groomSuits.add(item); break;
                case "Ring Bearer Outfits": ringBearerOutfits.add(item); break;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Dream Weddings - Wedding Attire</title>
        <link rel="stylesheet" href="styles.css" />
        <style>
            .autocomplete-item {
                padding: 10px;
                cursor: pointer;
                border-bottom: 1px solid #ddd;
                background-color: white;
            }
            .autocomplete-item:hover {
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
                    <form action="attire_search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="attireSearchBar" placeholder="Search attire..." 
                               autocomplete="off" style="padding: 10px; width: 250px; border-radius: 6px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 10px 16px; background: #a15c38; color: white; border-radius: 6px; border: none;">Search</button>
                        <div id="attireSuggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
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
            <h1>Wedding Attire</h1>
            <p>Find the perfect attire for your special day</p>
        </header>

        <main class="container">
            <div class="attire-count"><%= bridalGowns.size() + flowerGirlDresses.size() + groomSuits.size() + ringBearerOutfits.size() %> items found</div>

            <!-- Women's Collection -->
            <div class="attire-section">
                <h2>Women's Collection</h2>
                <div class="attire-grid">
                    <!-- Bridal Gowns -->
                    <div class="attire-category">
                        <h3>Bridal Gowns</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : bridalGowns) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="item-image">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <div class="item-rating">
                                        <%= "★".repeat((int)Math.floor(Double.parseDouble(item.get("rating")))) %>
                                    </div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <a href="attire_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Flower Girl Dresses -->
                    <div class="attire-category">
                        <h3>Flower Girl Dresses</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : flowerGirlDresses) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="item-image">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <div class="item-rating">
                                        <%= "★".repeat((int)Math.floor(Double.parseDouble(item.get("rating")))) %>
                                    </div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <a href="attire_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Men's Collection -->
            <div class="attire-section">
                <h2>Men's Collection</h2>
                <div class="attire-grid">
                    <!-- Groom Suits -->
                    <div class="attire-category">
                        <h3>Groom Suits</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : groomSuits) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="item-image">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <div class="item-rating">
                                        <%= "★".repeat((int)Math.floor(Double.parseDouble(item.get("rating")))) %>
                                    </div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <a href="attire_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Ring Bearer Outfits -->
                    <div class="attire-category">
                        <h3>Ring Bearer Outfits</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : ringBearerOutfits) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="item-image">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <div class="item-rating">
                                        <%= "★".repeat((int)Math.floor(Double.parseDouble(item.get("rating")))) %>
                                    </div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <a href="attire_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
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
                const searchInput = document.getElementById("attireSearchBar");
                const suggestionBox = document.getElementById("attireSuggestionBox");

                function fetchSuggestions(term = "") {
                    fetch("attire_suggestions.jsp?term=" + encodeURIComponent(term))
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
                        fetchSuggestions();
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
    </body>
</html>