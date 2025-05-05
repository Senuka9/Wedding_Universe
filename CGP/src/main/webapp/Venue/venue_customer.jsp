<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

    List<Map<String, String>> hotels = new ArrayList<>();
    List<Map<String, String>> resorts = new ArrayList<>();
    List<Map<String, String>> gardens = new ArrayList<>();
    List<Map<String, String>> historic = new ArrayList<>();

    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM venues WHERE status = 'active'");

        while (rs.next()) {
            Map<String, String> venue = new HashMap<>();
            venue.put("id", rs.getString("id"));
            venue.put("name", rs.getString("name"));
            venue.put("image", rs.getString("image"));
            venue.put("rating", rs.getString("rating"));
            venue.put("reviews", rs.getString("reviews"));
            venue.put("price", rs.getString("price"));
            venue.put("type", rs.getString("type"));

            switch (rs.getString("type")) {
                case "hotel": hotels.add(venue); break;
                case "resort": resorts.add(venue); break;
                case "garden": gardens.add(venue); break;
                case "historic": historic.add(venue); break;
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
        <title>Dream Weddings - Venues</title>
        <link rel="stylesheet" href="style.css" />
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
                    <form action="venue_search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="venueSearchBar" placeholder="Search venues..." 
                               autocomplete="off" style="padding: 10px; width: 250px; border-radius: 6px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 10px 16px; background: #a15c38; color: white; border-radius: 6px; border: none;">Search</button>
                        <div id="venueSuggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
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
            <h1>Wedding Venues</h1>
            <p>Browse luxury hotels, resorts, gardens and historic locations</p>
        </header>

        <main class="container">

            <!-- Hotel Section -->
            <div class="attire-section">
                <h2>Hotels</h2>
                <div class="items-grid">
                    <% for (Map<String, String> v : hotels) { %>
                    <div class="item-card">
                        <img src="<%= v.get("image") %>" alt="<%= v.get("name") %>" class="item-image">
                        <div class="item-details">
                            <h4 class="item-name"><%= v.get("name") %></h4>
                            <div class="item-rating">★ <%= v.get("rating") %> (<%= v.get("reviews") %>)</div>
                            <div class="item-price"><%= v.get("price") %></div>
                            <a href="venue_detail.jsp?id=<%= v.get("id") %>" class="view-details">View Details</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Resort Section -->
            <div class="attire-section">
                <h2>Resorts</h2>
                <div class="items-grid">
                    <% for (Map<String, String> v : resorts) { %>
                    <div class="item-card">
                        <img src="<%= v.get("image") %>" alt="<%= v.get("name") %>" class="item-image">
                        <div class="item-details">
                            <h4 class="item-name"><%= v.get("name") %></h4>
                            <div class="item-rating">★ <%= v.get("rating") %> (<%= v.get("reviews") %>)</div>
                            <div class="item-price"><%= v.get("price") %></div>
                            <a href="venue_detail.jsp?id=<%= v.get("id") %>" class="view-details">View Details</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Garden Section -->
            <div class="attire-section">
                <h2>Gardens</h2>
                <div class="items-grid">
                    <% for (Map<String, String> v : gardens) { %>
                    <div class="item-card">
                        <img src="<%= v.get("image") %>" alt="<%= v.get("name") %>" class="item-image">
                        <div class="item-details">
                            <h4 class="item-name"><%= v.get("name") %></h4>
                            <div class="item-rating">★ <%= v.get("rating") %> (<%= v.get("reviews") %>)</div>
                            <div class="item-price"><%= v.get("price") %></div>
                            <a href="venue_detail.jsp?id=<%= v.get("id") %>" class="view-details">View Details</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Historic Section -->
            <div class="attire-section">
                <h2>Historic Locations</h2>
                <div class="items-grid">
                    <% for (Map<String, String> v : historic) { %>
                    <div class="item-card">
                        <img src="<%= v.get("image") %>" alt="<%= v.get("name") %>" class="item-image">
                        <div class="item-details">
                            <h4 class="item-name"><%= v.get("name") %></h4>
                            <div class="item-rating">★ <%= v.get("rating") %> (<%= v.get("reviews") %>)</div>
                            <div class="item-price"><%= v.get("price") %></div>
                            <a href="venue_detail.jsp?id=<%= v.get("id") %>" class="view-details">View Details</a>
                        </div>
                    </div>
                    <% } %>
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
                const searchInput = document.getElementById("venueSearchBar");
                const suggestionBox = document.getElementById("venueSuggestionBox");

                function fetchSuggestions(term = "") {
                    fetch("venue_suggestions.jsp?term=" + encodeURIComponent(term))
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
