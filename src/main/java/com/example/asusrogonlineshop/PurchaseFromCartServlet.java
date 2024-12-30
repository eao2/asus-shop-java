package com.example.asusrogonlineshop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/purchaseFromCart")
public class PurchaseFromCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int productId = Integer.parseInt(request.getParameter("productId"));
        int productQuantity = Integer.parseInt(request.getParameter("productQuantity"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // Retrieve product price and stock
            String productQuery = "SELECT price, stock_quantity FROM products WHERE product_id = ?";
            try (PreparedStatement psProduct = conn.prepareStatement(productQuery)) {
                psProduct.setInt(1, productId);
                ResultSet rsProduct = psProduct.executeQuery();

                if (rsProduct.next()) {
                    double price = rsProduct.getDouble("price");
                    int stockQuantity = rsProduct.getInt("stock_quantity");

                    if (stockQuantity < productQuantity) {
                        response.sendRedirect("cart.jsp?error=InsufficientStock");
                        return;
                    }

                    // Calculate total price
                    double totalPrice = price * productQuantity;

                    // Insert into purchases table
                    String purchaseQuery = "INSERT INTO purchases (user_id, product_id, quantity, total_price) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement psPurchase = conn.prepareStatement(purchaseQuery)) {
                        psPurchase.setInt(1, userId);
                        psPurchase.setInt(2, productId);
                        psPurchase.setInt(3, productQuantity);
                        psPurchase.setDouble(4, totalPrice);
                        psPurchase.executeUpdate();
                    }

                    // Update product stock
                    String updateStockQuery = "Delete from cart WHERE product_id = ?";
                    try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockQuery)) {
                        psUpdateStock.setInt(1, productId);
                        psUpdateStock.executeUpdate();
                    }

                    conn.commit(); // Commit transaction
                    response.sendRedirect("purchases.jsp");
                } else {
                    response.sendRedirect("cart.jsp?error=ProductNotFound");
                }
            } catch (SQLException e) {
                conn.rollback(); // Rollback transaction on error
                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=ServerError");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=ServerError");
        }
    }
}


