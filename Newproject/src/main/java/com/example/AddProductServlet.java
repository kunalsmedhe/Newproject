package com.example;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productName = request.getParameter("productName");
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));
        String productDescription = request.getParameter("productDescription");  // Get description
        Part filePart = request.getPart("productImage");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Save the uploaded file to a directory
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        filePart.write(uploadPath + File.separator + fileName);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "Kunal@123");
            String query = "INSERT INTO products (name, price, image, description) VALUES (?, ?, ?, ?)";  // Include description
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, productName);
            ps.setDouble(2, productPrice);
            ps.setString(3, fileName);
            ps.setString(4, productDescription);  // Set description
            ps.executeUpdate();

            ps.close();
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("products.jsp");
    }
}