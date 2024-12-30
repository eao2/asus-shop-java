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

<!-- Query to fetch products -->
<sql:query var="products" dataSource="${dataSource}">
    SELECT product_id, product_name, description, price, stock_quantity, image FROM products;
</sql:query>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asus ROG Laptop Shop</title>
    <style>
        /* General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Orbitron', sans-serif;
        }

        body {
            background: #1a1a1a;
            height: 100vh;
            color: #e0e0e0;
        }

        /* Navbar */
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

        /* Grid container */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 100px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .grid-item {
            position: relative;
            overflow: hidden;
            border: 2px solid #444;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
            padding: 10px;
        }

        .grid-item:hover {
            transform: scale(1.05);
            box-shadow: 0 0 15px rgba(255, 99, 71, 0.7);
        }

        .grid-item img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease, filter 0.5s ease;
            border-radius: 5px;
        }

        .grid-item img:hover {
            transform: scale(1.1);
            filter: brightness(1.2);
        }

        .grid-item h3 {
            margin: 10px 0;
            color: #ff6347;
        }

        .grid-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #e0e0e0;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .grid-container {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .navbar .search-input {
                width: 100%;
                margin-top: 10px;
            }
        }

        @media (max-width: 480px) {
            .grid-container {
                grid-template-columns: 1fr;
            }

            .navbar .user {
                flex-direction: column;
                align-items: flex-start;
            }

            .navbar .search-input {
                width: calc(100% - 40px);
            }

            .navbar .cart {
                margin-left: 0;
                margin-top: 10px;
            }
        }
        .cartServlet{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        input{
            width: 100%;
            outline: none;
            border: none;
            background-color: #1e1e1e;
            color: #e0e0e0;
            margin: 4px 6px;
            padding: 4px 6px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="header.jsp" />
<!-- Grid container -->
<div class="grid-container">
    <c:forEach var="product" items="${products.rows}">
        <div class="grid-item">
            <!-- Assuming image column is Base64 encoded -->
            <img src="image?id=${product.product_id}" alt="${product.product_name}">
            <h3>${product.product_name}</h3>
            <p>${product.description}</p>
            <p>Stock: ${product.stock_quantity}</p>
            <p>Price: $${product.price}</p>

            <!-- Add to Cart -->
            <form action="CartServlet" method="post" class="cartServlet">
                <input type="hidden" name="productId" value="${product.product_id}" />
                <input type="number" name="quantity" value="1" min="1" />
                <button type="submit">Add to Cart</button>
            </form>
        </div>
    </c:forEach>
    <c:if test="${empty products.rows}">
        <p>No products available.</p>
    </c:if>
</div>

<script>
    function searchProducts() {
        var query = document.getElementById('searchInput').value;
        if (query) {
            window.location.href = 'search.jsp?query=' + encodeURIComponent(query);
        }
    }
</script>

</body>
</html>
