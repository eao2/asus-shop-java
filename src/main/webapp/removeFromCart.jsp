<%@ page import="com.example.asusrogonlineshop.CartItem" %><%
    String productId = request.getParameter("id");
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    cartItems.removeIf(item -> item.getId().equals(productId));
    session.setAttribute("cart", cartItems);

    response.sendRedirect("cart.jsp");
%>
