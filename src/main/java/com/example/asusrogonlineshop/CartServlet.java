package com.example.asusrogonlineshop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters.");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check current stock
            String checkStockQuery = "SELECT stock_quantity FROM products WHERE product_id = ?";
            try (PreparedStatement checkStockStmt = conn.prepareStatement(checkStockQuery)) {
                checkStockStmt.setInt(1, productId);
                ResultSet stockResult = checkStockStmt.executeQuery();

                if (stockResult.next()) {
                    int currentStock = stockResult.getInt("stock_quantity");

                    if (currentStock < quantity) {
                        response.sendRedirect("index.jsp?message=Not enough stock available");
                        return;
                    }
                } else {
                    response.sendRedirect("index.jsp?message=Product not found");
                    return;
                }
            }

            // Check if the product is already in the cart
            String checkCartQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
            try (PreparedStatement checkCartStmt = conn.prepareStatement(checkCartQuery)) {
                checkCartStmt.setInt(1, userId);
                checkCartStmt.setInt(2, productId);
                ResultSet cartResult = checkCartStmt.executeQuery();

                if (cartResult.next()) {
                    // Update quantity in cart
                    int currentQuantity = cartResult.getInt("quantity");
                    String updateCartQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
                    try (PreparedStatement updateCartStmt = conn.prepareStatement(updateCartQuery)) {
                        updateCartStmt.setInt(1, currentQuantity + quantity);
                        updateCartStmt.setInt(2, userId);
                        updateCartStmt.setInt(3, productId);
                        updateCartStmt.executeUpdate();
                    }
                } else {
                    // Insert new item into cart
                    String insertCartQuery = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                    try (PreparedStatement insertCartStmt = conn.prepareStatement(insertCartQuery)) {
                        insertCartStmt.setInt(1, userId);
                        insertCartStmt.setInt(2, productId);
                        insertCartStmt.setInt(3, quantity);
                        insertCartStmt.executeUpdate();
                    }
                }
            }

            // Update stock in products table
            String updateStockQuery = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
            try (PreparedStatement updateStockStmt = conn.prepareStatement(updateStockQuery)) {
                updateStockStmt.setInt(1, quantity);
                updateStockStmt.setInt(2, productId);
                updateStockStmt.executeUpdate();
            }

            response.sendRedirect("index.jsp?message=Item added to cart successfully");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
