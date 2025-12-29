/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.eventease.servlet;

import com.eventease.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil Input dari Form Login
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = Koneksi.getConnection();

            // 2. Cek apakah Email & Password cocok di Database
            // Catatan: Di aplikasi nyata, password harusnya di-hash (bukan plain text)
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // --- LOGIN BERHASIL ---
                
                // Ambil data user dari database
                String nama = rs.getString("nama");
                String role = rs.getString("role"); // 'user', 'penjual', atau 'admin'
                int id = rs.getInt("id");

                // 3. Buat Session (PENTING!)
                HttpSession session = request.getSession();
                session.setAttribute("userId", id);
                session.setAttribute("namaUser", nama);
                session.setAttribute("role", role);
                session.setAttribute("status", "login");

                // 4. Arahkan ke Dashboard sesuai Role
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin_dashboard.jsp");
                    
                } else if ("penjual".equalsIgnoreCase(role)) {
                    response.sendRedirect("seller_dashboard.jsp");
                    
                } else {
                    // Default role 'user'
                    response.sendRedirect("user_dashboard.jsp");
                }

            } else {
                // --- LOGIN GAGAL ---
                // Redirect kembali ke index dengan pesan error
                response.sendRedirect("index.jsp?error=invalid");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=server");
        }
    }
}
