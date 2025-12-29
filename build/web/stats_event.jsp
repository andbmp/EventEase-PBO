<%-- 
    Document   : stats_event
    Created on : 29 Dec 2025, 10.58.11
    Author     : Nabil
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    String id = request.getParameter("id");
    
    String nama="", poster="", statusEvent="Draft";
    int terjual=0, stok=0;
    double harga=0, pendapatan=0;
    boolean found = false;
    
    String badgeClass = "bg-secondary"; 

    if(id != null) {
        try {
            Connection conn = Koneksi.getConnection();
            String sql = "SELECT * FROM events WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                found = true;
                nama = rs.getString("nama_event");
                terjual = rs.getInt("terjual");
                stok = rs.getInt("stok");
                harga = rs.getDouble("harga");
                poster = rs.getString("poster_url");
                statusEvent = rs.getString("status");
               
                pendapatan = terjual * harga;
                
                if(poster == null || poster.length() < 5) {
                     poster = "https://dummyimage.com/600x400/ccc/000&text=No+Image"; 
                }
                
                if("Aktif".equalsIgnoreCase(statusEvent)) {
                    badgeClass = "bg-success"; 
                } else if("Pending".equalsIgnoreCase(statusEvent)) {
                    badgeClass = "bg-warning text-dark"; 
                } else if("Ditolak".equalsIgnoreCase(statusEvent)) {
                    badgeClass = "bg-danger"; 
                }
            }
            conn.close();
        } catch(Exception e) { e.printStackTrace(); }
    }

    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
    String pendapatanFmt = fmt.format(pendapatan).replace(",00", "");
    String hargaFmt = fmt.format(harga).replace(",00", "");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Statistik - <%= nama %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <a href="seller_dashboard.jsp" class="btn btn-outline-secondary mb-4 rounded-pill fw-bold">
            <i class="fas fa-arrow-left me-2"></i> Kembali ke Dashboard
        </a>

        <% if(found) { %>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <img src="<%= poster %>" class="card-img-top" style="height: 250px; object-fit: cover;">
                        <div class="card-body">
                            <h4 class="fw-bold mb-3"><%= nama %></h4>
                            <p class="text-muted mb-1">Harga Tiket:</p>
                            <h5 class="text-primary fw-bold mb-4"><%= hargaFmt %></h5>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between mb-2">
                                <span class="fw-bold text-muted">Status</span>
                                <span class="badge <%= badgeClass %> rounded-pill px-3"><%= statusEvent %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card border-0 shadow-sm h-100 p-4">
                        <h4 class="fw-bold mb-4"><i class="fas fa-chart-bar me-2 text-primary"></i> Data Penjualan</h4>
                        
                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <div class="p-4 bg-primary text-white rounded-3 text-center h-100">
                                    <i class="fas fa-ticket-alt fs-1 mb-2 opacity-50"></i>
                                    <h2 class="fw-bold mb-0"><%= terjual %></h2>
                                    <small class="opacity-75">Tiket Terjual</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-4 bg-warning text-dark rounded-3 text-center h-100">
                                    <i class="fas fa-box-open fs-1 mb-2 opacity-50"></i>
                                    <h2 class="fw-bold mb-0"><%= stok %></h2>
                                    <small class="opacity-75 fw-bold">Sisa Kuota</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-4 bg-success text-white rounded-3 text-center h-100">
                                    <i class="fas fa-coins fs-1 mb-2 opacity-50"></i>
                                    <h4 class="fw-bold mb-0 mt-2"><%= pendapatanFmt %></h4>
                                    <small class="opacity-75">Total Pendapatan</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-light border d-flex align-items-center mt-3">
                            <i class="fas fa-info-circle fs-4 me-3 text-secondary"></i>
                            <div class="text-muted small">
                                <strong>Catatan:</strong> Data pendapatan dihitung otomatis (Jumlah Terjual x Harga Tiket). Data ini diperbarui secara <em>real-time</em> saat user melakukan pembayaran.
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger">Event tidak ditemukan!</div>
        <% } %>
    </div>

</body>
</html>
