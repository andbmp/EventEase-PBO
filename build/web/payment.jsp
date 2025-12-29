<%-- 
    Document   : payment
    Created on : 29 Dec 2025, 07.16.44
    Author     : Edgar
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // 1. AMBIL DATA DARI HALAMAN CHECKOUT
    String idEvent = request.getParameter("id_event");
    String qtyStr = request.getParameter("qty");
    String totalStr = request.getParameter("total_bayar");
    String namaEvent = request.getParameter("nama_event");
    String metode = request.getParameter("metode");
    String namaPemesan = request.getParameter("nama_pemesan");

    // 2. KONVERSI DATA (String ke Angka)
    long total = 0;
    if(totalStr != null && !totalStr.isEmpty()) {
        try {
            // Hapus titik/koma jika ada, ambil angkanya saja
            total = Long.parseLong(totalStr.replaceAll("[^0-9]", ""));
        } catch(Exception e) {
            total = 0;
        }
    }

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
    String totalFmt = fmt.format(total).replace(",00", "");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Pembayaran - EventEase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #e9ecef; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .payment-card { max-width: 400px; width: 100%; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .header-bg { background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%); color: white; padding: 30px 20px; text-align: center; }
    </style>
</head>
<body>

    <div class="card payment-card border-0">
        <div class="header-bg">
            <h6 class="opacity-75 mb-1">Total Tagihan</h6>
            <h1 class="fw-bold mb-2"><%= totalFmt %></h1>
            <span class="badge bg-light text-primary rounded-pill px-3 py-2">
                <%= (namaEvent != null) ? namaEvent : "Event Tidak Diketahui" %>
            </span>
        </div>

        <div class="card-body p-4 bg-white">
            <div class="text-center mb-4">
                <small class="text-muted fw-bold text-uppercase">Metode Pembayaran</small>
                <h6 class="fw-bold text-dark mt-1"><%= (metode != null) ? metode : "-" %></h6>
                <small class="text-muted">Pemesan: <%= (namaPemesan != null) ? namaPemesan : "-" %></small>
            </div>

            <form action="process_payment" method="POST" onsubmit="return validasiBayar()">

                <input type="hidden" name="id_event" value="<%= idEvent %>">
                <input type="hidden" name="qty" value="<%= qtyStr %>">
                
                <input type="hidden" name="nama_event" value="<%= namaEvent %>">
                <input type="hidden" name="total_bayar" value="<%= total %>">
                <input type="hidden" name="nama_pemesan" value="<%= namaPemesan %>">

                <div class="mb-3">
                    <label class="fw-bold small mb-2 text-primary">Masukkan Nominal Uang Anda</label>
                    <div class="input-group input-group-lg">
                        <span class="input-group-text bg-light border-0 fw-bold">Rp</span>
                        <input type="number" id="inputUang" class="form-control bg-light border-0 fw-bold text-dark" 
                               placeholder="0" required oninput="hitungKembalian(<%= total %>)">
                    </div>
                    <div id="infoKembalian" class="text-end mt-2 small fw-bold text-muted">
                        Menunggu input...
                    </div>
                </div>

                <button type="submit" class="btn btn-success w-100 py-3 rounded-pill fw-bold shadow mt-3">
                    <i class="fas fa-paper-plane me-2"></i> Konfirmasi Bayar
                </button>
                
                <a href="user_dashboard.jsp" class="btn btn-link w-100 text-decoration-none text-muted mt-2 small">Batal</a>
            </form>
        </div>
        
        <div class="card-footer bg-light text-center py-3 border-0">
            <small class="text-muted"><i class="fas fa-lock me-1"></i> Pembayaran Aman & Terenkripsi</small>
        </div>
    </div>

    <script>
        function hitungKembalian(totalTagihan) {
            let uangMasuk = document.getElementById("inputUang").value;
            let info = document.getElementById("infoKembalian");
            
            if(uangMasuk >= totalTagihan) {
                let kembalian = uangMasuk - totalTagihan;
                // Format Rupiah sederhana
                let formatted = new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(kembalian);
                info.innerHTML = "<span class='text-success'>Kembalian: " + formatted + "</span>";
            } else {
                info.innerHTML = "<span class='text-danger'>Uang kurang!</span>";
            }
        }

        function validasiBayar() {
            let uang = document.getElementById("inputUang").value;
            let total = <%= total %>; // Ambil nilai dari Java
            
            if(uang < total) {
                alert("Maaf, uang yang Anda masukkan kurang!");
                return false; // Mencegah form terkirim
            }
            return true; // Lanjut ke halaman sukses
        }
    </script>

</body>
</html>
