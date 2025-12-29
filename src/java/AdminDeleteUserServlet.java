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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDeleteUserServlet", urlPatterns = {"/admin_delete_user"})
public class AdminDeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        try {
            Connection conn = Koneksi.getConnection();
            String sql = "DELETE FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            
            ps.executeUpdate();
            conn.close();
            
            response.sendRedirect("admin_dashboard.jsp?msg=user_deleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?msg=error");
        }
    }
}
