<%-- 
    Document   : payment_success
    Created on : 29 Dec 2025, 07.17.34
    Author     : Edgar
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID" %>

<%
    // 1. AMBIL DATA DARI HALAMAN PAYMENT
    String namaEvent = request.getParameter("namaEvent");
    
    // Default data (jika halaman dibuka langsung tanpa proses bayar)
    if (namaEvent == null) namaEvent = "Contoh Event";

    // 2. TENTUKAN LOKASI & TANGGAL (Logika Simulasi)
    // Di aplikasi nyata, data ini diambil dari database berdasarkan ID Event
    String lokasi = "Lokasi Belum Ditentukan";
    String tanggal = "-";

    if (namaEvent.contains("Jazz")) {
        lokasi = "GBK, Jakarta";
        tanggal = "20 Des 2025";
    } else if (namaEvent.contains("Tech")) {
        lokasi = "Online Zoom";
        tanggal = "15 Jan 2026";
    } else if (namaEvent.contains("Marathon")) {
        lokasi = "Monas, Jakarta";
        tanggal = "10 Feb 2026";
    }

    // 3. GENERATE TICKET ID UNIK (Random String)
    // UUID menghasilkan string acak panjang, kita ambil 8 karakter pertama saja agar rapi
    String ticketId = "TICKET-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

    // 4. GENERATE QR CODE (Menggunakan API Google Chart / QRServer)
    // Kita masukkan ticketId ke dalam URL API ini agar gambar QR berubah sesuai kode tiket
    String qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + ticketId;
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pembayaran Berhasil - EventEase</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #e9ecef; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .ticket-card { max-width: 400px; width: 100%; border-radius: 20px; overflow: hidden; position: relative; }
        .ticket-header { background: #198754; color: white; padding: 30px 20px; text-align: center; border-radius: 0 0 50% 50% / 20px; }
        .ticket-body { background: white; padding: 30px; text-align: center; position: relative; }
        
        /* Garis putus-putus tiket */
        .dashed-line { border-top: 3px dashed #dee2e6; margin: 20px 0; position: relative; }
        .dashed-line::before, .dashed-line::after {
            content: ''; position: absolute; top: -10px; width: 20px; height: 20px;
            background-color: #e9ecef; border-radius: 50%;
        }
        .dashed-line::before { left: -40px; }
        .dashed-line::after { right: -40px; }
    </style>
</head>
<body>

    <div class="container d-flex justify-content-center">
        <div class="ticket-card shadow-lg">
            <div class="ticket-header">
                <div class="mb-2">
                    <i class="fas fa-check-circle fa-4x text-white"></i>
                </div>
                <h4 class="fw-bold">Pembayaran Berhasil!</h4>
                <p class="mb-0 small opacity-75">Tiket Anda telah terbit</p>
            </div>

            <div class="ticket-body">
                <h5 class="fw-bold text-primary mb-1" id="suksesEvent"><%= namaEvent %></h5>
                <p class="text-muted small mb-4" id="suksesLokasi"><%= lokasi %></p>

                <img id="suksesQR" src="<%= qrUrl %>" class="img-fluid mb-3 border p-2 rounded" width="180" alt="QR Code">
                
                <div class="dashed-line"></div>

                <div class="row text-start mt-3">
                    <div class="col-6 mb-3">
                        <small class="text-muted d-block">Tanggal</small>
                        <strong class="text-dark" id="suksesTanggal"><%= tanggal %></strong>
                    </div>
                    <div class="col-6 mb-3">
                        <small class="text-muted d-block">Kode Tiket</small>
                        <strong class="text-dark" id="suksesId"><%= ticketId %></strong>
                    </div>
                    <div class="col-12 text-center mt-2">
                         <small class="text-muted">Status</small><br>
                         <span class="badge bg-success rounded-pill px-3">LUNAS</span>
                    </div>
                </div>

                <div class="d-grid gap-2 mt-4">
                    <a href="user_dashboard.jsp" class="btn btn-primary fw-bold rounded-pill">
                        <i class="fas fa-home me-2"></i> Kembali ke Dashboard
                    </a>
                    
                    <button onclick="window.print()" class="btn btn-outline-secondary fw-bold rounded-pill">
                        <i class="fas fa-download me-2"></i> Simpan Tiket
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
