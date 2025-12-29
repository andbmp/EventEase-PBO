/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.eventease.servlet;

import com.eventease.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // Jika menggunakan Tomcat 7+
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try {
            Connection conn = Koneksi.getConnection();
            
            String sql = "INSERT INTO users (nama, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            
            int row = ps.executeUpdate();
            
            if (row > 0) {
                response.sendRedirect("index.jsp?status=sukses");
            } else {
                response.sendRedirect("index.jsp?status=gagal");
            }
            
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?status=error");
        }
    }
}
