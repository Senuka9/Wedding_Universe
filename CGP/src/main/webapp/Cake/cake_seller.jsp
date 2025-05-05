<%@ page import="java.sql.*" %>
<%@ include file="../db.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("seller")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String rating = request.getParameter("rating");
        String image = request.getParameter("image");
        String contact = request.getParameter("contact");
        String sellerUsername = (String) session.getAttribute("username");

        try {
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO cakes (name, description, price, rating, image, contact, owner) VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setDouble(3, Double.parseDouble(price));
            stmt.setDouble(4, Double.parseDouble(rating));
            stmt.setString(5, image);
            stmt.setString(6, contact);
            stmt.setString(7, sellerUsername); // Save owner

            int result = stmt.executeUpdate();
            message = (result > 0) ? "✅ Cake added successfully." : "❌ Error adding cake.";
            stmt.close();
        } catch (Exception e) {
            message = "⚠️ Error: " + e.getMessage();
        }
    }
%>

<html>
<head>
    <title>Seller Page - Add Cake</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .navbar {
            width: 100%;
            background-color: #0099cc;
            padding: 15px;
            text-align: center;
        }

        .navbar a {
            color: white;
            font-weight: bold;
            text-decoration: none;
            margin: 0 20px;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            width: 100%;
            background-color: #28a745;
            color: white;
            padding: 10px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
        }

        button:hover {
            background-color: #218838;
        }

        .message {
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
            color: #333;
        }

        #imagePreview {
            display: none;
            margin-top: 10px;
            max-width: 100%;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        table {
            margin-top: 30px;
            width: 90%;
            background: white;
            border-collapse: collapse;
        }

        th, td {
            padding: 8px 12px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #0099cc;
            color: white;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="../index.jsp">🏠 Home</a>
    <a href="CAKE.jsp">🛍️ View Cakes</a>
</div>

<div class="form-container">
    <h2>Add a New Cake</h2>
    <form method="post">
        Name:
        <input type="text" name="name" required>

        Description:
        <textarea name="description" rows="4" required></textarea>

        Price:
        <input type="number" step="0.01" name="price" required>

        Rating:
        <input type="number" step="0.1" name="rating" min="0" max="5" required>

        Contact Number:
        <input type="text" name="contact" id="contact" maxlength="10" required placeholder="07X XXX XXXX">
        <span id="contactError" style="color: red; display: none;">Must start with 07 and be 10 digits.</span>

        Image URL:
        <input type="text" name="image" id="imageURL" required>
        <img id="imagePreview" alt="Image Preview" />

        <button type="submit">Add Cake</button>
    </form>

    <% if (!message.isEmpty()) { %>
    <div class="message"><%= message %></div>
    <% } %>
</div>

<%
    String seller = (String) session.getAttribute("username");
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM cakes WHERE owner = '" + seller + "'");
%>

<div>
    <h3>Your Cakes</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Actions</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td>Rs. <%= rs.getDouble("price") %></td>
            <td>
                <a href="update_cake.jsp?id=<%= rs.getInt("id") %>">Edit</a> |
                <a href="delete_cake.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
        <% } rs.close(); stmt.close(); %>
    </table>
</div>

<script>
    const imageURLInput = document.getElementById("imageURL");
    const imagePreview = document.getElementById("imagePreview");
    imageURLInput.addEventListener("input", function () {
        const url = this.value.trim();
        imagePreview.src = url;
        imagePreview.style.display = url.length > 5 ? "block" : "none";
    });

    const contactInput = document.getElementById("contact");
    const contactError = document.getElementById("contactError");
    const form = document.querySelector("form");


    form.addEventListener("submit", function (e) {
        let raw = contactInput.value.replace(/\D/g, "");
        const validPattern = /^07\d{8}$/;
        if (!validPattern.test(raw)) {
            e.preventDefault();
            contactError.style.display = "block";
            contactInput.focus();
        } else {
            contactError.style.display = "none";
            contactInput.value = "+94" + raw.slice(1);
        }
    });
</script>

</body>
</html>
