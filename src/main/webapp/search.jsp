<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<!-- Retrieve the search query parameter from the request -->
<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/asus"
                   user="root" password="12345679"/>
<sql:query var="products" dataSource="${dataSource}">
    SELECT product_id, product_name, description, price, image FROM products WHERE product_name LIKE ?
    <sql:param value="%${param.query}%" />
</sql:query>

<html>
<jsp:include page="header.jsp" />
<body>
<h1 style="text-align: center; margin-top: 80px; color: #ff6347;">Search Results for "${param.query}"</h1>

<div class="grid-container">
    <c:forEach var="product" items="${products.rows}">
        <div class="grid-item">
            <!-- Assuming image column is Base64 encoded -->
            <img src="image?id=${product.product_id}" alt="${product.product_name}">
            <h3>${product.product_name}</h3>
            <p>${product.description}</p>
            <p>Price: $${product.price}</p>
        </div>
    </c:forEach>

    <c:if test="${empty products.rows}">
        <p style="text-align: center; color: #ff6347;">No products found for "${param.query}".</p>
    </c:if>
</div>

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
        .grid-container {
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
    }

    @media (max-width: 480px) {
        .grid-container {
            grid-template-columns: 1fr;
        }
    }
</style>
</body>
</html>
