package com.example.asusrogonlineshop;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;



@WebServlet("/removeFromCart")
public class RemoveFromCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get productId and userId from request parameters
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Database connection details
        Connection conn = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psRemoveFromCart = null;
        try {
            // Set up DB connection
            String dbUrl = "jdbc:mysql://localhost:3306/asus";
            String dbUser = "root";
            String dbPassword = "12345679";
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Get the quantity of the product in the cart
            String query = "SELECT quantity FROM cart WHERE product_id = ? AND user_id = ?";
            psRemoveFromCart = conn.prepareStatement(query);
            psRemoveFromCart.setInt(1, productId);
            psRemoveFromCart.setInt(2, userId);

            ResultSet rs = psRemoveFromCart.executeQuery();
            int quantityInCart = 0;
            if (rs.next()) {
                quantityInCart = rs.getInt("quantity");
            }

            // Add the quantity back to the products table
            String updateStockQuery = "UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
            psUpdateStock = conn.prepareStatement(updateStockQuery);
            psUpdateStock.setInt(1, quantityInCart);
            psUpdateStock.setInt(2, productId);
            psUpdateStock.executeUpdate();

            // Remove the product from the cart
            String removeFromCartQuery = "DELETE FROM cart WHERE product_id = ? AND user_id = ?";
            psRemoveFromCart = conn.prepareStatement(removeFromCartQuery);
            psRemoveFromCart.setInt(1, productId);
            psRemoveFromCart.setInt(2, userId);
            psRemoveFromCart.executeUpdate();

            // Redirect to the cart page
            response.sendRedirect("cart.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } finally {
            try {
                if (psUpdateStock != null) psUpdateStock.close();
                if (psRemoveFromCart != null) psRemoveFromCart.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
