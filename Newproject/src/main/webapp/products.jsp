<%@ page import="java.util.List" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jspf" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
    <link rel="stylesheet" href="styles.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $("#addProductBtn").click(function() {
                $("#addProductModal").show();
            });

            $(".close").click(function() {
                $("#addProductModal").hide();
            });

            $(window).click(function(event) {
                if (event.target.id == "addProductModal") {
                    $("#addProductModal").hide();
                }
            });
        });
    </script>
</head>
<body>
    <main>
        <div class="container">
            <h1>Products</h1>
            <button id="addProductBtn">Add Product</button>
            <div id="addProductModal" class="modal">
                <div class="modal-content">
                    <span class="close">&times;</span>
                    <h2>Add Product</h2>
                    <form action="addProduct" method="post" enctype="multipart/form-data">
                        <label for="productName">Product Name:</label>
                        <input type="text" id="productName" name="productName" required>
                        <label for="productPrice">Price:</label>
                        <input type="number" id="productPrice" name="productPrice" required>
                        <label for="productDescription">Description:</label> <!-- Add description field -->
                        <textarea id="productDescription" name="productDescription" required></textarea>
                        <label for="productImage">Product Image:</label>
                        <input type="file" id="productImage" name="productImage" accept="image/*" required>
                        <input type="submit" value="Add Product">
                    </form>
                </div>
            </div>

            <div class="products-list">
                <%
                    List<Product> products = new ArrayList<Product>();
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "Kunal@123");
                        String query = "SELECT * FROM products";
                        PreparedStatement ps = con.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();
                        
                        while (rs.next()) {
                            Product product = new Product();
                            product.setId(rs.getInt("id"));
                            product.setName(rs.getString("name"));
                            product.setPrice(rs.getDouble("price"));
                            product.setImage(rs.getString("image"));
                            product.setDescription(rs.getString("description"));  // Get description
                            products.add(product);
                        }

                        rs.close();
                        ps.close();
                        con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    request.setAttribute("products", products);
                %>
                <c:forEach var="product" items="${products}">
                    <div class="product-item">
                        <img src="uploads/${product.image}" alt="${product.name}">
                        <h3>${product.name}</h3>
                        <p>Price: ${product.price}</p>
                        <p>${product.description}</p>  <!-- Display description -->
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
    <footer>
        <p>My Website &copy; 2024</p>
    </footer>
</body>
</html>