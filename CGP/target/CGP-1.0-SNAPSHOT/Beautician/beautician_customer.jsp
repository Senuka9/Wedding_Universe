<%@ page import="java.sql.*, java.util.*, java.text.DecimalFormat" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>
<%
    List<Map<String, String>> bridalMakeup = new ArrayList<>();
    List<Map<String, String>> hairStyling = new ArrayList<>();
    List<Map<String, String>> bridesmaidPackages = new ArrayList<>();
    List<Map<String, String>> familyPackages = new ArrayList<>();

    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM beautician_services");

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("description", rs.getString("description"));
            item.put("duration", rs.getString("duration"));
            item.put("price", rs.getString("price"));
            item.put("rating", rs.getString("rating"));
            item.put("image", rs.getString("image"));
            item.put("status", rs.getString("status"));

            String category = rs.getString("category");
            switch (category) {
                case "Bridal Makeup": bridalMakeup.add(item); break;
                case "Hair Styling": hairStyling.add(item); break;
                case "Bridesmaid Packages": bridesmaidPackages.add(item); break;
                case "Family Packages": familyPackages.add(item); break;
            }
        }

    } catch (Exception e) {
        out.println("❌ Database Error: " + e.getMessage());
    }

    int totalServices = bridalMakeup.size() + hairStyling.size() + bridesmaidPackages.size() + familyPackages.size();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Dream Weddings - Beautician Services</title>
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
                    <form action="beautician_search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="beauticianSearchBar" placeholder="Search services..." 
                               autocomplete="off" style="padding: 10px; width: 250px; border-radius: 6px; border: 1px solid #ccc;">
                        <button type="submit" style="padding: 10px 16px; background: #a15c38; color: white; border-radius: 6px; border: none;">Search</button>
                        <div id="beauticianSuggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
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
            <h1>Bridal Beauty Services</h1>
            <p>Look and feel your absolute best on your special day</p>
        </header>

        <main class="container">
            <div class="services-count"><%= totalServices %> services available</div>

            <!-- Bridal Services -->
            <div class="services-section">
                <h2>Bridal Services</h2>
                <div class="services-grid">

                    <div class="service-category">
                        <h3>Bridal Makeup</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : bridalMakeup) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image" alt="">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <p class="item-description"><%= item.get("description") %></p>
                                    <p class="item-duration">⏱ <%= item.get("duration") %></p>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <% if ("active".equals(item.get("status"))) { %>
                                    <a href="beautician_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                    <% } else { %>
                                    <span class="view-details" style="background:#ccc; pointer-events:none;">Unavailable</span>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <div class="service-category">
                        <h3>Hair Styling</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : hairStyling) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image" alt="">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <p class="item-description"><%= item.get("description") %></p>
                                    <p class="item-duration">⏱ <%= item.get("duration") %></p>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <% if ("active".equals(item.get("status"))) { %>
                                    <a href="beautician_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                    <% } else { %>
                                    <span class="view-details" style="background:#ccc; pointer-events:none;">Unavailable</span>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Party Services -->
            <div class="services-section">
                <h2>Party Services</h2>
                <div class="services-grid">

                    <div class="service-category">
                        <h3>Bridesmaid Packages</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : bridesmaidPackages) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image" alt="">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <p class="item-description"><%= item.get("description") %></p>
                                    <p class="item-duration">⏱ <%= item.get("duration") %></p>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <% if ("active".equals(item.get("status"))) { %>
                                    <a href="beautician_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                    <% } else { %>
                                    <span class="view-details" style="background:#ccc; pointer-events:none;">Unavailable</span>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <div class="service-category">
                        <h3>Family Packages</h3>
                        <div class="items-grid">
                            <% for (Map<String, String> item : familyPackages) { %>
                            <div class="item-card">
                                <img src="<%= item.get("image") %>" class="item-image" alt="">
                                <div class="item-details">
                                    <h4 class="item-name"><%= item.get("name") %></h4>
                                    <p class="item-description"><%= item.get("description") %></p>
                                    <p class="item-duration">⏱ <%= item.get("duration") %></p>
                                    <div class="item-rating">★ <%= item.get("rating") %></div>
                                    <div class="item-price">$<%= item.get("price") %></div>
                                    <% if ("active".equals(item.get("status"))) { %>
                                    <a href="beautician_detail.jsp?id=<%= item.get("id") %>" class="view-details">View Details</a>
                                    <% } else { %>
                                    <span class="view-details" style="background:#ccc; pointer-events:none;">Unavailable</span>
                                    <% } %>
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
                const searchInput = document.getElementById("beauticianSearchBar");
                const suggestionBox = document.getElementById("beauticianSuggestionBox");

                function fetchSuggestions(term = "") {
                    fetch("beautician_suggestions.jsp?term=" + encodeURIComponent(term))
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