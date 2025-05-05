<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="../db.jsp" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dream Weddings - Wedding Cakes</title>
        <link rel="stylesheet" href="cake.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .autocomplete-item {
                padding: 10px;
                cursor: pointer;
                border-bottom: 1px solid #ddd;
                background-color: white;
            }
            .autocomplete-item:hover {
                background-color: #f0f0f0;
            }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link active">Home</a>
                    <form action="cake_search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="cakeSearchBar" placeholder="Search wedding cakes..." 
                               autocomplete="off" class="search-input">
                        <div id="cakeSuggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
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
            <h1>Wedding Cakes</h1>
            <p>Find the perfect cake for your special day</p>
        </header><br><br>

        <div class="cakes-grid" id="cakes-container">
            <% 
              if (conn == null) {
                out.println("<p style='color:red;'>Database connection failed ❌</p>");
              } else {
                try {
                  Statement stmt = conn.createStatement();
                  ResultSet rs = stmt.executeQuery("SELECT * FROM cakes");

                  while (rs.next()) {
                    String name = rs.getString("name");
                    String desc = rs.getString("description");
                    double price = rs.getDouble("price");
                    double rating = rs.getDouble("rating");
                    String image = rs.getString("image");
            %>
            <div class="cake-card">
                <img src="<%= image %>" alt="cake" class="cake-image">
                <div class="cake-info">
                    <h3 class="cake-name"><%= name %></h3>
                    <div class="rating">
                        ⭐ <%= rating %>
                    </div>
                    <div class="price">
                        $<%= price %>
                    </div>
                    <p><%= desc %></p>
                    <a href="cake_detail.jsp?id=<%= rs.getInt("id") %>"><button class="view-details-btn">View Details</button></a>
                </div>
            </div>
            <% 
                  }
                  rs.close();
                  stmt.close();
                } catch (Exception e) {
                  out.println("<p>Error: " + e.getMessage() + "</p>");
                }
              } 
            %>
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
                const searchInput = document.getElementById("cakeSearchBar");
                const suggestionBox = document.getElementById("cakeSuggestionBox");

                function fetchSuggestions(term = "") {
                    fetch("cake_suggestions.jsp?term=" + encodeURIComponent(term))
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
                                console.error("Error loading suggestions", err);
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