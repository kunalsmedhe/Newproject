<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.example.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="header.jspf" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main>
        <div class="container">
            <h1>Welcome to the Home Page</h1>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <p>Welcome, ${sessionScope.user}!</p>
                    <p><a href="logout">Logout</a></p>
                </c:when>
                <c:otherwise>
                    <p>This is a cool project with a professional look and feel.</p>
                </c:otherwise>
            </c:choose>
            <h2>Our Products</h2>
            <div class="products-list">
                <%
                    List<Product> products = new ArrayList<Product>();
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "password");
                        String query = "SELECT * FROM products";
                        PreparedStatement ps = con.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();
                        
                        while (rs.next()) {
                            Product product = new Product();
                            product.setId(rs.getInt("id"));
                            product.setName(rs.getString("name"));
                            product.setPrice(rs.getDouble("price"));
                            product.setImage(rs.getString("image"));
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