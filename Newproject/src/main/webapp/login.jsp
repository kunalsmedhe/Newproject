<%@ include file="header.jspf" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <main>
        <div class="container">
            <h1>Login</h1>
            <form action="login" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <input type="submit" value="Login">
                <c:if test="${param.error == 1}">
                    <p style="color: red;">Invalid username or password</p>
                </c:if>
            </form>
        </div>
    </main>
    <footer>
        <p>My Website &copy; 2024</p>
    </footer>
</body>
</html>