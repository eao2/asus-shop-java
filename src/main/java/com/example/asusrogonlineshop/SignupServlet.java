package com.example.asusrogonlineshop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    // Create a BCryptPasswordEncoder instance
    private static final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone_number");

        // Hash the password using BCrypt
        String hashedPassword = passwordEncoder.encode(password);

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/asus", "root", "12345679")) {
                // SQL query to insert user details
                String sql = "INSERT INTO users (username, email, password, phone_number) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, username);
                    ps.setString(2, email);
                    ps.setString(3, hashedPassword); // Save hashed password
                    ps.setString(4, phoneNumber);
                    ps.executeUpdate();
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace(); // Handle error: JDBC Driver not found
        } catch (SQLException e) {
            e.printStackTrace(); // Handle SQL error
        }

        // Redirect to the signup page
        response.sendRedirect("login.jsp");
    }
}
