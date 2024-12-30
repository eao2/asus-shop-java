package com.example.asusrogonlineshop;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UploadProductServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1MB
        maxFileSize = 1024 * 1024 * 10,   // 10MB
        maxRequestSize = 1024 * 1024 * 15  // 15MB
)
public class UploadProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        Integer quantity = Integer.valueOf(request.getParameter("quantity"));
        Part imagePart = request.getPart("image");  // Get the uploaded image file

        double price = 0;
        try {
            price = Double.parseDouble(priceStr); // Parse price
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid price format.");
            return;
        }

        // InputStream to store the image as BLOB
        InputStream imageInputStream = null;

        if (imagePart != null) {
            imageInputStream = imagePart.getInputStream(); // Get input stream from image file
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image file is required.");
            return;
        }

        // Store data in the database
        try (Connection connection = DatabaseConnection.getConnection()) {
            // SQL Query to insert product details and image into the database
            String sql = "INSERT INTO products (product_name, description, price, stock_quantity, image) VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                // Set parameters for SQL query
                statement.setString(1, name);
                statement.setString(2, description);
                statement.setDouble(3, price);
                statement.setDouble(4, quantity);
                statement.setBlob(5, imageInputStream);  // Set the BLOB value for the image

                // Execute the query
                int rowsAffected = statement.executeUpdate();
                if (rowsAffected > 0) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.sendRedirect("/index.jsp");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to upload product.");
                }
            } catch (SQLException e) {
                log("SQL Error: ", e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            }
        } catch (SQLException e) {
            log("Database Connection Error: ", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to connect to the database.");
        }
    }
}
