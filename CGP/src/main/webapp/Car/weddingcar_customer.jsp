<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String loggedUser = session.getAttribute("username") != null ? (String) session.getAttribute("username") : "";

%>
<%
    List<Map<String, String>> cars = new ArrayList<>();
    try {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM wedding_cars WHERE status = 'active'");
        while (rs.next()) {
            Map<String, String> car = new HashMap<>();
            car.put("id", rs.getString("id"));
            car.put("name", rs.getString("name"));
            car.put("image", rs.getString("image"));
            car.put("price", rs.getString("price"));
            car.put("rating", rs.getString("rating"));
            car.put("car_type", rs.getString("car_type"));
            car.put("features", rs.getString("features"));
            car.put("description", rs.getString("description"));
            cars.add(car);
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
        <meta charset="UTF-8">
        <title>Wedding Cars</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                background-color: #f8f8f8;
                margin: 0;
                padding: 0;
            }

            .navbar {
                background-color: white;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .nav-container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 1rem;
                height: 4rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-family: serif;
                font-size: 1.5rem;
                color: #5D1D88;
                margin: 0;
                letter-spacing: 0.5px;
                transition: color 0.3s ease;
            }

            .logo:hover {
                color: #7B2DAE;
            }

            .nav-links {
                display: flex;
                align-items: center;
                gap: 2rem;
            }

            .nav-link {
                color: #666;
                text-decoration: none;
                transition: color 0.3s ease;
                font-size: 0.9rem;
                position: relative;
                padding: 0.5rem 0;
            }

            .nav-link:hover,
            .nav-link.active {
                color: #5D1D88;
            }

            .nav-link:after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 100%;
                height: 2px;
                background-color: #5D1D88;
                transform: scaleX(0);
                transform-origin: left;
                transition: transform 0.3s ease;
            }

            .nav-link:hover:after,
            .nav-link.active:after {
                transform: scaleX(1);
            }

            .search-input {
                padding: 0.5rem 2.5rem 0.5rem 1rem;
                border: 1px solid #E5E7EB;
                border-radius: 9999px;
                font-size: 0.875rem;
                outline: none;
                width: 200px;
                background-color: #F9FAFB;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: #5D1D88;
                box-shadow: 0 0 0 2px rgba(93, 29, 136, 0.1);
                background-color: white;
                width: 220px;
            }

            .account-btn {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 1.2rem;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #F3F4F6;
                transition: all 0.3s ease;
            }

            .account-btn:hover {
                background-color: #E5E7EB;
                transform: translateY(-1px);
            }

            .container {
                max-width: 1280px;
                margin: 2rem auto;
                padding: 0 1rem;
            }

            .car-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 2rem;
                padding: 2rem;
            }

            .car-item {
                background: white;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
                display: flex;
                flex-direction: column;
                border: 1px solid rgba(0, 0, 0, 0.05);
            }

            .car-item:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            }

            .car-item img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 16px 16px 0 0;
                transition: transform 0.3s ease;
            }

            .car-item:hover img {
                transform: scale(1.05);
            }

            .car-item h3 {
                color: #1A1A1A;
                font-size: 1.25rem;
                margin: 1rem 0 0.5rem;
                padding: 0 1rem;
            }

            .car-item p {
                margin: 0.5rem 0;
                padding: 0 1rem;
                color: #666;
            }

            .car-item span {
                display: inline-block;
                background: #F3F4F6;
                padding: 0.25rem 0.75rem;
                margin: 0.25rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                color: #666;
                transition: all 0.3s ease;
            }

            .car-item span:hover {
                background: #5D1D88;
                color: white;
            }

            .car-item button {
                background-color: #5D1D88;
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                margin: 1rem;
                cursor: pointer;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .car-item button:hover {
                background-color: #4A1769;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(93, 29, 136, 0.2);
            }

            .autocomplete-item {
                padding: 10px;
                cursor: pointer;
                border-bottom: 1px solid #ddd;
                background-color: white;
            }
            .autocomplete-item:hover {
                background-color: #f0f0f0;
            }

            @media (max-width: 768px) {
                .nav-links {
                    gap: 1rem;
                }

                .search-input {
                    width: 150px;
                }

                .search-input:focus {
                    width: 170px;
                }

                .car-list {
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                    gap: 1rem;
                    padding: 1rem;
                }

            }

            @media (max-width: 640px) {
                .nav-container {
                    height: 3.5rem;
                }

                .logo {
                    font-size: 1.25rem;
                }

                .nav-links a:not(.active) {
                    display: none;
                }

                .car-item {
                    margin: 0.5rem 0;
                }

                .car-item img {
                    height: 180px;
                }
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="nav-container">
                <h1 class="logo">Wedding Universe</h1>
                <div class="nav-links">
                    <a href="../index.jsp" class="nav-link active">Home</a>
                    <form action="car_search.jsp" method="get" style="position: relative; display: inline-block;">
                        <input type="text" name="term" id="carSearchBar" placeholder="Search wedding cars..." 
                               autocomplete="off" class="search-input">
                        <div id="carSuggestionBox" style="position: absolute; top: 42px; left: 0; width: 100%; background: white; border: 1px solid #ccc; display: none; z-index: 999;"></div>
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

        <div class="car-list">
            <% for (Map<String, String> car : cars) { %>
            <div class="car-item">
                <img src="<%= car.get("image") %>" alt="<%= car.get("name") %>">
                <h3><%= car.get("name") %></h3>
                <p><strong>Type:</strong> <%= car.get("car_type") %></p>

                <div style="margin: 5px 0;">
                    <% for (String tag : car.get("features").split(",")) { %>
                    <span style="display:inline-block; background:#eee; padding:4px 8px; margin:2px; border-radius:4px; font-size:12px;">
                        <%= tag.trim() %>
                    </span>
                    <% } %>
                </div>

                <p style="font-size: 14px; color: #444;">
                    <%= car.get("description").length() > 60 
                        ? car.get("description").substring(0, 60) + "..." 
                        : car.get("description") %>
                </p>

                <p>⭐ <%= car.get("rating") %></p>
                <p style="font-weight: bold;">$<%= car.get("price") %></p>

                <a href="car_detail.jsp?id=<%= car.get("id") %>">
                    <button>View Details</button>
                </a>
            </div>
            <% } %>
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
                const searchInput = document.getElementById("carSearchBar");
                const suggestionBox = document.getElementById("carSuggestionBox");

                function fetchSuggestions(term = "") {
                    fetch("car_suggestions.jsp?term=" + encodeURIComponent(term))
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
