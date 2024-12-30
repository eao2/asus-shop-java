<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%
    // Get the username from session
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!-- Database connection -->
<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/asus"
                   user="root" password="12345679"/>

<sql:query var="cartCount" dataSource="${dataSource}">
    SELECT COUNT(*) AS item_count FROM cart WHERE user_id = (SELECT user_id FROM users WHERE username = ?);
    <sql:param value="${username}"/>
</sql:query>

<header>
    <div class="navbar">
        <div class="links">
            <a href="/">Latest</a>
            <a href="Upload_Product.jsp">Upload Product</a>
            <a href="purchases.jsp">Purchases</a>
            <a class="cart" href="/cart.jsp">
                Cart
                <span class="cart-count">${cartCount.rows[0].item_count}</span>
            </a>
        </div>
        <div class="user">
            <span>${username}</span>
            <input type="text" class="search-input" placeholder="Search..." id="searchInput">
            <button onclick="searchProducts()">Search</button>
            <a class="logout" href="logout.jsp">Logout</a>
        </div>
    </div>
</header>

<style>
    /* General Styles */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Orbitron', sans-serif;
    }

    button{
        background-color: #1e1e1e;
        outline: none;
        border: none;
        border-radius: 4px;
        padding: 4px 6px;
        margin: 4px 6px;
        color: #e0e0e0;
        font-size: 1rem;
    }

    header {
        background-color: #333;
        width: 100%;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 100;
        padding: 15px 20px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.8);
    }

    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
        max-width: 960px;
        margin: auto;
        color: #e0e0e0;
    }

    .navbar a {
        color: #e0e0e0;
        text-decoration: none;
        margin: 0 15px;
        font-size: 16px;
        transition: color 0.3s ease;
    }

    .navbar a:hover {
        color: #ff6347;
        text-shadow: 0 0 10px #ff6347, 0 0 20px #ff6347;
    }

    .navbar .user {
        display: flex;
        align-items: center;
    }

    .navbar .user span {
        margin-right: 10px;
    }

    .navbar .search-input {
        border: none;
        background: none;
        color: #e0e0e0;
        border-bottom: 2px solid #ff6347;
        transition: border-color 0.3s ease;
        padding: 5px;
    }

    .navbar .search-input:focus {
        outline: none;
        border-color: #ff4500;
    }

    .navbar .cart {
        position: relative;
        cursor: pointer;
    }

    .navbar .cart .cart-count {
        background: #ff6347;
        border-radius: 1rem;
        padding: 2px 6px;
        font-size: 12px;
        color: #fff;
    }

    /* Additional Styles for Layout and Responsiveness */
    @media (max-width: 768px) {
        .navbar {
            flex-direction: column;
            align-items: flex-start;
        }
    }

    @media (max-width: 480px) {
        .navbar .user {
            flex-direction: column;
            align-items: flex-start;
        }
    }
</style>

<script>
    function searchProducts() {
        var query = document.getElementById('searchInput').value;
        if (query) {
            window.location.href = 'search.jsp?query=' + encodeURIComponent(query);
        }
    }
</script>
