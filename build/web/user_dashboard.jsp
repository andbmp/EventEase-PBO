<%-- 
    Document   : user_dashboard
    Created on : 29 Dec 2025, 07.11.44
    Author     : Edgar
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.eventease.config.Koneksi" %> <%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Cek Login Session (Biarkan kode session login yang lama)
    String namaUser = (String) session.getAttribute("namaUser");
    if (namaUser == null) namaUser = "Tamu";
    
    // SIAPKAN FORMAT RUPIAH
    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EventEase</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#"><i class="fas fa-ticket-alt"></i> EventEase</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link active" href="#">Beranda</a></li>
                    <li class="nav-item"><a class="nav-link" href="#events">Cari Event</a></li>
                    
                    <li class="nav-item ms-3 d-flex align-items-center bg-white rounded-pill px-3 py-1">
                        <img src="https://ui-avatars.com/api/?name=<%= namaUser %>&background=random" class="rounded-circle me-2" width="30" height="30">
                        
                        <span class="text-dark fw-bold small me-3">Halo, <%= namaUser %>!</span>
                        
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger rounded-circle" title="Keluar / Logout">
                            <i class="fas fa-power-off"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div id="content-area">
        
        <header class="hero-section text-center">
            <div class="container">
                <h1 class="display-4 fw-bold text-white">Temukan Event Seru di Sekitarmu</h1>
                <p class="lead text-white-50 mb-4">Konser, Seminar, Olahraga, dan pengalaman tak terlupakan lainnya.</p>
                
                <div class="card p-4 shadow border-0 mx-auto" style="max-width: 800px; border-radius: 15px;">
                    <form action="search.jsp" method="GET"> <div class="row g-2">
                            <div class="col-md-4">
                                <input type="text" name="keyword" class="form-control border-0 bg-light py-2" placeholder="🔍 Cari nama event...">
                            </div>
                            <div class="col-md-3">
                                <select name="kategori" class="form-select border-0 bg-light py-2">
                                    <option selected value="">Semua Kategori</option>
                                    <option value="Musik">Musik</option>
                                    <option value="Teknologi">Teknologi</option>
                                    <option value="Olahraga">Olahraga</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <input type="date" name="tanggal" class="form-control border-0 bg-light py-2">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100 fw-bold py-2">Cari</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </header>

        <section id="events" class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold border-start border-4 border-primary ps-3">🔥 Event Populer</h3>
            <a href="#" class="text-decoration-none fw-bold">Lihat Semua</a>
        </div>

        <div class="row g-4">
    <%
        try {
            Connection conn = Koneksi.getConnection();
            // Ambil semua data event dari database
            // HANYA TAMPILKAN EVENT YANG STATUSNYA 'Aktif'
            String sql = "SELECT * FROM events WHERE status = 'Aktif'";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            // LOOPING: Kode ini akan mengulang pembuatan kartu sebanyak jumlah data di DB
            while(rs.next()) {
                String id = rs.getString("id");
                String nama = rs.getString("nama_event");
                String tgl = rs.getString("tanggal");
                String loc = rs.getString("lokasi");
                String img = rs.getString("poster_url");
                String kat = rs.getString("kategori");
                double hrg = rs.getDouble("harga");
                
                String hargaFmt = fmt.format(hrg).replace(",00", "");
    %>
            <div class="col-md-4">
                <div class="card event-card h-100 shadow-sm border-0">
                    
                    <img src="<%= img %>" class="card-img-top" alt="Poster" 
                         style="height: 200px; width: 100%; object-fit: cover;">
                         
                    <div class="card-body">
                        <span class="badge bg-primary mb-2"><%= kat %></span>
                        <h5 class="card-title fw-bold text-truncate"><%= nama %></h5>
                        <p class="text-muted small mb-3">
                            <i class="fas fa-map-marker-alt text-danger"></i> <%= loc %> | <%= tgl %>
                        </p>
                        <h5 class="text-primary fw-bold"><%= hargaFmt %></h5>
                    </div>
                    <div class="card-footer bg-white border-0 pb-4 pt-0">
                        <a href="detail_event.jsp?id=<%= id %>" class="btn btn-outline-primary w-100 fw-bold rounded-pill">
                            Lihat Detail & Pesan
                        </a>
                    </div>
                </div>
            </div>
    <%
            } // Tutup Kurawal While
            
            conn.close();
        } catch(Exception e) {
            out.println("<div class='alert alert-danger w-100'>Gagal memuat data: " + e.getMessage() + "</div>");
        }
    %>
    </div>

                </div>
            </div>
        </div>
    </section>
    </div>

    <footer class="bg-dark text-white text-center py-3 mt-5">
        <p class="mb-0">&copy; 2025 EventEase. All Rights Reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
