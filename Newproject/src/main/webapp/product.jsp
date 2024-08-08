<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.example.Product" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <jsp:include page="header.jspf" />
    </header>
    <main>
        <div class="container">
            <%
                int productId = Integer.parseInt(request.getParameter("id"));
                Product product = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "Kunal@123");
                    String query = "SELECT * FROM products WHERE id = ?";
                    PreparedStatement ps = con.prepareStatement(query);
                    ps.setInt(1, productId);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        product = new Product();
                        product.setId(rs.getInt("id"));
                        product.setName(rs.getString("name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getDouble("price"));
                    }

                    rs.close();
                    ps.close();
                    con.close();
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                }

                if (product != null) {
            %>
                <h2><%= product.getName() %></h2>
                <p><%= product.getDescription() %></p>
                <p>Price: <%= product.getPrice() %></p>

                <form action="order" method="post">
                    <input type="hidden" name="userId" value="<%= session.getAttribute("userId") %>">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                    <label for="quantity">Quantity:</label>
                    <input type="number" id="quantity" name="quantity" min="1" required>
                    <input type="submit" value="Order">
                </form>
            <%
                } else {
            %>
                <p>Product not found.</p>
            <%
                }
            %>
        </div>
    </main>
    <footer>
        <p>My Website &copy; 2024</p>
    </footer>
</body>
</html>