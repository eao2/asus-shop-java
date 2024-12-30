<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Redirect to login page if username is not in session
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!-- Database Connection -->
<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/asus"
                   user="root" password="12345679" />

<!-- Query to get purchases -->
<sql:query dataSource="${dataSource}" var="purchases">
    SELECT
    p.purchase_id,
    p.user_id,
    u.username,
    p.product_id,
    pr.product_name,
    p.quantity,
    p.total_price,
    p.purchase_date
    FROM purchases p
    JOIN users u ON p.user_id = u.user_id
    JOIN products pr ON p.product_id = pr.product_id
    WHERE u.username = ?;
    <sql:param value="${username}" />
</sql:query>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Purchases</title>
    <style>
        /* Include the same styles from your home page */
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
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<h1 style="text-align: center; margin-top: 80px;">Your Purchases</h1>

<div class="grid-container">
    <c:forEach var="purchase" items="${purchases.rows}">
        <div class="grid-item">
            <img src="image?id=${purchase.product_id}" alt="${purchase.product_name}">
            <h3>${purchase.product_name}</h3>
            <p>Quantity: ${purchase.quantity}</p>
            <p>Total Price: $${purchase.total_price}</p>
            <p>Purchase Date: ${purchase.purchase_date}</p>
        </div>
    </c:forEach>
    <c:if test="${empty purchases.rows}">
        <p style="text-align: center; color: #ff6347;">No purchases found.</p>
    </c:if>
</div>

</body>
</html>
