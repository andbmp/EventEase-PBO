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

@WebServlet(name = "ProcessPaymentServlet", urlPatterns = {"/process_payment"})
public class ProcessPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idEvent = request.getParameter("id_event");
        String qtyStr = request.getParameter("qty");
        
        int qty = 1;
        if(qtyStr != null && !qtyStr.isEmpty()) {
            qty = Integer.parseInt(qtyStr);
        }

        try {
            Connection conn = Koneksi.getConnection();
            
            String sql = "UPDATE events SET stok = stok - ?, terjual = terjual + ? WHERE id = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, qty); 
            ps.setInt(2, qty); 
            ps.setString(3, idEvent); 
            
            int hasil = ps.executeUpdate();
            conn.close();
            
            if(hasil > 0) {
                request.getRequestDispatcher("payment_success.jsp").forward(request, response);
            } else {
                response.sendRedirect("user_dashboard.jsp?msg=gagal_update");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user_dashboard.jsp?msg=error_payment");
        }
    }
}
