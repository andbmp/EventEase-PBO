/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.eventease.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Koneksi {
    
    // URL Standar untuk Driver Lama (5.1.x)
    private static final String URL = "jdbc:mysql://localhost:3306/eventease_db"; 
    private static final String USER = "root";
    private static final String PASS = ""; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // DRIVER VERSI 5 (Sesuai gambar Anda)
            Class.forName("com.mysql.jdbc.Driver"); 
            
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("DEBUG: Koneksi Berhasil!"); // Cek di Output NetBeans
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // Ini akan mencetak error merah di Output NetBeans
            System.out.println("DEBUG: Koneksi Gagal: " + e.getMessage());
        }
        return conn;
    }
}
