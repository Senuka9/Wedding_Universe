<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Ensure only sellers can edit
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("seller")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");
    String owner = (String) session.getAttribute("username");
    String message = "";

    // Initialize attire fields
    String name = "", gender = "", category = "", image = "", contact = "";
    double price = 0.0, rating = 0.0;
    int reviews = 0;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE attire SET name=?, gender=?, category=?, price=?, rating=?, image=?, contact=? WHERE id=? AND owner=?"
            );
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("gender"));
            stmt.setString(3, request.getParameter("category"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
            stmt.setDouble(5, Double.parseDouble(request.getParameter("rating")));
            stmt.setString(6, request.getParameter("image"));     // ✅ Correct index
            stmt.setString(7, request.getParameter("contact"));   // ✅ Correct index
            stmt.setInt(8, Integer.parseInt(id));                 // ✅ Correct index
            stmt.setString(9, owner);                             // ✅ Correct index


            int result = stmt.executeUpdate();
            message = (result > 0) ? "✅ Updated successfully." : "❌ Update failed.";
            stmt.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }

    // Load data to pre-fill form
    try {
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM attire WHERE id=? AND owner=?");
        stmt.setString(1, id);
        stmt.setString(2, owner);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            gender = rs.getString("gender");
            category = rs.getString("category");
            price = rs.getDouble("price");
            rating = rs.getDouble("rating");
            image = rs.getString("image");
            contact = rs.getString("contact");
        } else {
            out.println("<h3>❌ Attire not found or unauthorized access.</h3>");
            return;
        }
    } catch (Exception e) {
        out.println("❌ Error: " + e.getMessage());
    }
%>

<html>
<head>
    <title>Update Attire</title>
    <link rel="stylesheet" href="styles.css" />
</head>
<style>
    body {
        font-family: 'Poppins', sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    .form-container {
        max-width: 600px;
        margin: 50px auto;
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    h2 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
    }

    form {
        display: flex;
        flex-direction: column;
    }

    input, select {
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 15px;
    }

    button {
        padding: 12px;
        background-color: #8B4513;
        color: white;
        font-weight: bold;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: 0.3s;
    }

    button:hover {
        background-color: #6d3610;
    }

    .message {
        text-align: center;
        margin-top: 15px;
        font-weight: bold;
        color: green;
    }

    a {
        display: inline-block;
        margin-top: 20px;
        text-align: center;
        text-decoration: none;
        color: #8B4513;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }
</style>

<body>
<div class="form-container">
    <h2>Update Wedding Attire</h2>
    <form method="post">
        Name: <input type="text" name="name" value="<%= name %>" required><br>
        Gender:
        <select name="gender">
            <option value="Women" <%= gender.equals("Women") ? "selected" : "" %>>Women</option>
            <option value="Men" <%= gender.equals("Men") ? "selected" : "" %>>Men</option>
        </select><br>
        Category:
        <select name="category" id="category">
            <option <%= category.equals("Bridal Gowns") ? "selected" : "" %>>Bridal Gowns</option>
            <option <%= category.equals("Flower Girl Dresses") ? "selected" : "" %>>Flower Girl Dresses</option>
            <option <%= category.equals("Groom Suits") ? "selected" : "" %>>Groom Suits</option>
            <option <%= category.equals("Ring Bearer Outfits") ? "selected" : "" %>>Ring Bearer Outfits</option>
        </select><br>
        Price: <input type="number" step="0.01" name="price" value="<%= price %>" required><br>
        Rating: <input type="number" step="0.1" name="rating" value="<%= rating %>" required><br>
        Image URL: <input type="text" name="image" value="<%= image %>" required><br>
        Contact: <input type="text" name="contact" value="<%= contact %>" required><br>
        <button type="submit">Update</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <br>
    <a href="attire_seller.jsp">⬅️ Back to Seller Page</a>
</div>
    <script>
    const categoriesByGender = {
        Men: ["Groom Suits", "Ring Bearer Outfits"],
        Women: ["Bridal Gowns", "Flower Girl Dresses"]
    };

    const genderSelect = document.querySelector("select[name='gender']");
    const categorySelect = document.getElementById("category");

    function updateCategoryOptions() {
        const selectedGender = genderSelect.value;
        const categories = categoriesByGender[selectedGender] || [];

        categorySelect.innerHTML = "";

        categories.forEach(cat => {
            const option = document.createElement("option");
            option.value = cat;
            option.textContent = cat;
            categorySelect.appendChild(option);
        });
    }

    genderSelect.addEventListener("change", updateCategoryOptions);
    document.addEventListener("DOMContentLoaded", updateCategoryOptions); // Load default
</script>

</body>
</html>
