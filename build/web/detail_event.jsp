<%-- 
    Document   : detail_event
    Created on : 29 Dec 2025, 07.13.30
    Author     : Andhika
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    // 1. AMBIL ID DARI URL
    String id = request.getParameter("id");
    
    // Variabel penampung data
    String nama="", lokasi="", tanggal="", deskripsi="", poster="";
    double harga = 0;
    boolean found = false;

    // 2. QUERY KE DATABASE
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
                lokasi = rs.getString("lokasi");
                tanggal = rs.getString("tanggal");
                deskripsi = rs.getString("deskripsi");
                poster = rs.getString("poster_url");
                harga = rs.getDouble("harga");
                
                // Cek jika poster kosong atau strip
                if(poster == null || poster.equals("-") || poster.isEmpty()) {
                    poster = "https://dummyimage.com/600x400/ccc/000&text=No+Image";
                }
            }
            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
    String hargaFmt = fmt.format(harga).replace(",00", "");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title><%= found ? nama : "Event Tidak Ditemukan" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-primary shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold"><i class="fas fa-info-circle me-2"></i> Detail Event</span>
            <a href="user_dashboard.jsp" class="text-white text-decoration-none fw-bold">
                <i class="fas fa-arrow-left"></i> Kembali
            </a>
        </div>
    </nav>

    <div class="container mb-5">
        <% if(found) { %>
            <div class="card shadow-sm border-0 overflow-hidden">
                <div class="row g-0">
                    <div class="col-md-6 bg-dark d-flex align-items-center justify-content-center">
                        <img src="<%= poster %>" class="img-fluid" alt="<%= nama %>" style="width:100%; max-height: 500px; object-fit: cover;">
                    </div>
                    
                    <div class="col-md-6">
                        <div class="card-body p-4 p-md-5">
                            <span class="badge bg-primary mb-2">Event Terbaru</span>
                            <h2 class="fw-bold text-dark mb-3"><%= nama %></h2>
                            
                            <p class="text-muted mb-1"><i class="fas fa-map-marker-alt text-danger me-2"></i> <%= lokasi %></p>
                            <p class="text-muted mb-4"><i class="far fa-calendar-alt text-primary me-2"></i> <%= tanggal %></p>
                            
                            <h3 class="text-primary fw-bold mb-4"><%= hargaFmt %> <small class="text-muted fs-6 fw-normal">/ tiket</small></h3>
                            
                            <h5 class="fw-bold">Deskripsi Event</h5>
                            <p class="text-muted mb-5" style="line-height: 1.8;">
                                <%= (deskripsi != null) ? deskripsi : "Belum ada deskripsi." %>
                            </p>
                            
                            <form action="checkout.jsp" method="GET">
                                <input type="hidden" name="id" value="<%= id %>">
                                
                                <div class="mb-3">
                                    <label class="fw-bold small mb-1">Jumlah Tiket</label>
                                    <div class="input-group" style="width: 150px;">
                                        <button class="btn btn-outline-secondary" type="button" onclick="this.parentNode.querySelector('input[type=number]').stepDown()">-</button>
                                        <input type="number" name="qty" class="form-control text-center" value="1" min="1" max="10">
                                        <button class="btn btn-outline-secondary" type="button" onclick="this.parentNode.querySelector('input[type=number]').stepUp()">+</button>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow-sm">
                                    Beli Tiket Sekarang <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="text-center py-5">
                <img src="https://cdn-icons-png.flaticon.com/512/2748/2748558.png" width="150" class="mb-3 opacity-50">
                <h3 class="fw-bold text-muted">Event Tidak Ditemukan</h3>
                <p>Maaf, event yang Anda cari tidak tersedia atau telah dihapus.</p>
                <a href="user_dashboard.jsp" class="btn btn-primary rounded-pill">Kembali ke Beranda</a>
            </div>
        <% } %>
    </div>

</body>
</html>
