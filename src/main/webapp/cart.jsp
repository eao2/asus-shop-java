<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%
    // Get the username from session
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("userId");

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

%>

<%--<c:if test="${empty userId}">--%>
<%--    <p>User ID is missing or invalid.</p>--%>
<%--</c:if>--%>


<!-- Database connection -->
<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/asus"
                   user="root" password="12345679"/>

<!-- Query to fetch cart items -->
<sql:query var="cartItems" dataSource="${dataSource}">
    SELECT p.product_id, p.product_name, p.price, c.quantity
    FROM cart c
    JOIN products p ON c.product_id = p.product_id
    WHERE c.user_id = ?
    <sql:param value="${userId}"/>
</sql:query>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <style>
        /* Your styles here */
        body {
            font-family: 'Arial', sans-serif;
            color: #e0e0e0;
            background-color: #0c0c0c;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #333;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }

        .cart-container {
            width: 80%;
            margin: 20px auto;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }

        .cart-table th, .cart-table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .cart-table .forms {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .cart-table th {
            background-color: #000;
            color: white;
        }

        .cart-table tr:nth-child(odd) {
            background-color: #2c2c2c;
        }

        .cart-table tr:nth-child(even) {
            background-color: #1c1c1c;
        }

        .total-price {
            font-size: 1.5em;
            text-align: right;
            margin-top: 20px;
        }

        .checkout-button {
            padding: 10px 20px;
            background-color: #ff6347;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 1.2em;
            margin-top: 20px;
        }

        .checkout-button:hover {
            background-color: #ff4500;
        }

        .cart-table{
            margin-top: 5rem ;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />
<div class="cart-container">
    <table class="cart-table">
        <thead>
        <tr>
            <th>Product Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${cartItems.rows}">
            <tr>
                <td>${item.product_name}</td>
                <td>${item.price}</td>
                <td>${item.quantity}</td>
                <td>${item.price * item.quantity}</td>
                <td class="forms">
                    <form action="removeFromCart" method="post">
                        <input type="hidden" name="productId" value="${item.product_id}">
                        <button type="submit">Remove</button>
                    </form>
                    <form action="purchaseFromCart" method="post">
                        <input type="hidden" name="productId" value="${item.product_id}">
                        <input type="hidden" name="productQuantity" value="${item.quantity}">
                        <button type="submit">Purchase</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${empty cartItems.rows}">
        <p>Your cart is empty.</p>
    </c:if>

    <c:if test="${not empty cartItems.rows}">
        <div class="total-price">
            <c:set var="totalAmount" value="0" />
            <c:forEach var="item" items="${cartItems.rows}">
                <c:set var="totalAmount" value="${totalAmount + item.price * item.quantity}" />
            </c:forEach>
            Total: $${totalAmount}
        </div>
    </c:if>
</div>

</body>
</html>
