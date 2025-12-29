<%-- 
    Document   : checkout
    Created on : 29 Dec 2025, 07.15.27
    Author     : Alif
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    String id = request.getParameter("id");
    String qtyStr = request.getParameter("qty");
    
    int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;

    String namaEvent = "";
    String posterUrl = "";
    double hargaTiket = 0;
    
    if(id != null) {
        try {
            Connection conn = Koneksi.getConnection();
            String sql = "SELECT * FROM events WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                namaEvent = rs.getString("nama_event");
                hargaTiket = rs.getDouble("harga");
                posterUrl = rs.getString("poster_url");
                
                if(posterUrl == null || posterUrl.length() < 5) { 
                    posterUrl = "https://dummyimage.com/600x400/ccc/000&text=No+Image"; 
                }
            }
            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    double totalHargaTiket = hargaTiket * qty;
    double biayaLayanan = 5000;
    double totalBayar = totalHargaTiket + biayaLayanan;

    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Checkout - EventEase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <div class="bg-primary py-3 shadow-sm mb-5 text-white">
        <div class="container d-flex justify-content-between align-items-center">
            <h4 class="mb-0 fw-bold"><i class="fas fa-ticket-alt me-2"></i>EventEase Checkout</h4>
            <a href="detail_event.jsp?id=<%= id %>" class="text-white text-decoration-none fw-bold small">Batal</a>
        </div>
    </div>

    <div class="container">
        <form action="payment.jsp" method="POST">
            <input type="hidden" name="id_event" value="<%= id %>">
            <input type="hidden" name="qty" value="<%= qty %>">
            
            <input type="hidden" name="total_bayar" value="<%= (long)totalBayar %>">
            <input type="hidden" name="nama_event" value="<%= namaEvent %>">

            <div class="row g-5">
                
                <div class="col-md-7">
                    <h5 class="mb-3 fw-bold text-dark">Data Pemesan</h5>
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nama Lengkap</label>
                            <input type="text" class="form-control py-2" name="nama_pemesan" placeholder="Sesuai KTP" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Email (Untuk E-Ticket)</label>
                            <input type="email" class="form-control py-2" name="email_pemesan" placeholder="email@contoh.com" required>
                        </div>
                        
                        <h5 class="mb-3 mt-4 fw-bold text-dark">Metode Pembayaran</h5>
                        <div class="card p-3 border border-primary bg-light mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="metode" id="bank" value="Transfer Bank" checked>
                                <label class="form-check-label fw-bold" for="bank">
                                    Transfer Bank
                                </label>
                                <div class="small text-muted ps-0 mt-1">BCA, Mandiri, BNI, BRI</div>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow mt-3">
                            Bayar Sekarang (<%= fmt.format(totalBayar).replace(",00", "") %>)
                        </button>
                    </div>
                </div>

                <div class="col-md-5">
                    <h5 class="mb-3 fw-bold text-primary">Ringkasan Pesanan</h5>
                    <div class="card border-0 shadow-sm overflow-hidden">
                        <div style="height: 180px; overflow: hidden;">
                             <img src="<%= posterUrl %>" class="w-100" style="object-fit: cover; height: 100%;">
                        </div>
                        
                        <div class="card-body p-4">
                            <h5 class="card-title fw-bold mb-3"><%= namaEvent %></h5>
                            
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Harga Tiket</span>
                                    <span class="fw-bold"><%= fmt.format(hargaTiket).replace(",00", "") %></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Jumlah</span>
                                    <span class="fw-bold">x <%= qty %></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <span class="text-muted small">Biaya Layanan</span>
                                    <span class="fw-bold"><%= fmt.format(biayaLayanan).replace(",00", "") %></span>
                                </li>
                            </ul>
                            
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <span class="h6 fw-bold text-success mb-0">Total Bayar</span>
                                <span class="h5 fw-bold text-success mb-0"><%= fmt.format(totalBayar).replace(",00", "") %></span>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div> </form>
    </div>

</body>
</html>
