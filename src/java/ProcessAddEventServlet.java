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

@WebServlet(name = "ProcessAddEventServlet", urlPatterns = {"/process_add_event"})
public class ProcessAddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nama = request.getParameter("nama");
        String kategori = request.getParameter("kategori");
        String lokasi = request.getParameter("lokasi");
        String tanggal = request.getParameter("tanggal");
        String harga = request.getParameter("harga");
        String stok = request.getParameter("stok");
        String deskripsi = request.getParameter("deskripsi");
        String poster = request.getParameter("poster");
        
        if(poster == null || poster.trim().isEmpty()) {
            poster = "-"; 
        }

        try {
            Connection conn = Koneksi.getConnection();
            
            String sql = "INSERT INTO events (nama_event, kategori, lokasi, tanggal, harga, stok, deskripsi, poster_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setString(1, nama);
            ps.setString(2, kategori);
            ps.setString(3, lokasi);
            ps.setString(4, tanggal);
            ps.setDouble(5, Double.parseDouble(harga));
            ps.setInt(6, Integer.parseInt(stok));
            ps.setString(7, deskripsi);
            ps.setString(8, poster);
            
            int row = ps.executeUpdate();
            conn.close();
            
            if (row > 0) {
                response.sendRedirect("seller_dashboard.jsp?status=sukses");
            } else {
                response.sendRedirect("seller_dashboard.jsp?status=gagal");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("seller_dashboard.jsp?status=error");
        }
    }
}
