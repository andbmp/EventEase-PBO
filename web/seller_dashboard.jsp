<%-- 
    Document   : seller_dashboard
    Created on : 29 Dec 2025, 07.20.11
    Author     : Edgar
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    // 1. CEK SESSION
    String sellerName = (String) session.getAttribute("namaUser");
    if (sellerName == null) sellerName = "Organizer Event"; 

    // 2. SIAPKAN VARIABEL STATISTIK
    int totalEvent = 0;
    int totalTiketTerjual = 0;
    double totalPendapatan = 0;
    
    // List untuk menampung data event dari Database
    List<Map<String, String>> listEvent = new ArrayList<>();

    // 3. AMBIL DATA DARI DATABASE
    try {
        Connection conn = Koneksi.getConnection();
        Statement stmt = conn.createStatement();
        
        // Query ambil semua event (Nanti bisa ditambah WHERE seller_id = ...)
        String sql = "SELECT * FROM events ORDER BY id DESC"; 
        ResultSet rs = stmt.executeQuery(sql);

        while(rs.next()) {
            Map<String, String> ev = new HashMap<>();
            
            String id = rs.getString("id");
            String nama = rs.getString("nama_event");
            String tgl = rs.getString("tanggal");
            String loc = rs.getString("lokasi");
            double harga = rs.getDouble("harga");
            int stok = rs.getInt("stok");
            int terjual = rs.getInt("terjual");
            String status = rs.getString("status");
            String poster = rs.getString("poster_url");

            // Masukkan ke Map
            ev.put("id", id);
            ev.put("nama", nama);
            ev.put("tanggal", tgl);
            ev.put("lokasi", loc);
            ev.put("harga", String.valueOf(harga));
            ev.put("stok", String.valueOf(stok));
            ev.put("terjual", String.valueOf(terjual));
            ev.put("status", status);
            ev.put("poster", poster);

            listEvent.add(ev);

            // Hitung Statistik
            totalEvent++;
            totalTiketTerjual += terjual;
            totalPendapatan += (terjual * harga);
        }
        
        conn.close();
        
    } catch(Exception e) {
        e.printStackTrace();
    }

    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
    String pendapatanFmt = fmt.format(totalPendapatan).replace(",00", "");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Penjual - EventEase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-success sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="fas fa-briefcase"></i> EventEase <span class="badge bg-light text-success ms-1">SELLER</span>
            </a>
            <div class="d-flex align-items-center bg-white rounded-pill px-2 py-1 shadow-sm">
                <span class="text-dark fw-bold small mx-3">Halo, <%= sellerName %>!</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm rounded-circle"><i class="fas fa-power-off"></i></a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card text-center border-0 shadow-sm p-3 h-100">
                    <h3 class="fw-bold text-success"><%= totalEvent %></h3>
                    <small class="text-muted fw-bold">Total Event</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center border-0 shadow-sm p-3 h-100">
                    <h3 class="fw-bold text-primary"><%= totalTiketTerjual %></h3>
                    <small class="text-muted fw-bold">Tiket Terjual</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center border-0 shadow-sm p-3 h-100">
                    <h3 class="fw-bold text-warning"><%= pendapatanFmt %></h3>
                    <small class="text-muted fw-bold">Estimasi Pendapatan</small>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold text-dark"><i class="fas fa-calendar-alt me-2"></i>Daftar Event Saya</h4>
            <button class="btn btn-success fw-bold shadow-sm" onclick="bukaModalTambah()">
                <i class="fas fa-plus-circle me-2"></i> Tambah Event
            </button>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-success">
                            <tr>
                                <th class="ps-4">Poster</th>
                                <th>Info Event</th>
                                <th>Harga</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                for (Map<String, String> ev : listEvent) {
                                    String status = ev.get("status");
                                    String statusClass = "bg-secondary"; // Default (Pending/Draft)
                                    
                                    if("Aktif".equalsIgnoreCase(status)) statusClass = "bg-success";
                                    else if("Ditolak".equalsIgnoreCase(status)) statusClass = "bg-danger";
                                    else if("Pending".equalsIgnoreCase(status)) statusClass = "bg-warning text-dark";

                                    double hrg = Double.parseDouble(ev.get("harga"));
                                    String hargaShow = fmt.format(hrg).replace(",00", "");
                            %>
                            <tr>
                                <td class="ps-4">
                                    <img src="<%= ev.get("poster") %>" class="rounded shadow-sm" width="60" height="60" style="object-fit: cover;" onerror="this.src='https://dummyimage.com/60x60/ccc/000&text=No+Img'">
                                </td>
                                <td>
                                    <h6 class="fw-bold mb-0 text-dark"><%= ev.get("nama") %></h6>
                                    <small class="text-muted"><i class="far fa-calendar me-1"></i> <%= ev.get("tanggal") %></small><br>
                                    <small class="text-muted"><i class="fas fa-map-marker-alt me-1"></i> <%= ev.get("lokasi") %></small>
                                </td>
                                <td class="fw-bold text-primary"><%= hargaShow %></td>
                                <td>
                                    <span class="badge <%= statusClass %> rounded-pill"><%= status %></span>
                                </td>
                                <td class="text-center">
                                    <a href="stats_event.jsp?id=<%= ev.get("id") %>" class="btn btn-sm btn-info text-white me-1" title="Lihat Statistik">
                                        <i class="fas fa-chart-line"></i>
                                    </a>

                                    <a href="edit_event.jsp?id=<%= ev.get("id") %>" class="btn btn-sm btn-warning text-white me-1">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <a href="process_delete_event?id=<%= ev.get("id") %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Apakah Anda yakin ingin menghapus event ini? Data yang dihapus tidak bisa dikembalikan.')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                            
                            <% if(listEvent.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center py-5">
                                        <p class="text-muted">Belum ada event di Database.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="eventModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="process_add_event" method="POST">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title fw-bold">Buat Event Baru</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3"><label class="fw-bold small">Nama Event</label><input type="text" name="nama" class="form-control" required></div>
                        <div class="mb-3">
                            <label class="fw-bold small">Kategori</label>
                            <select class="form-select" name="kategori">
                                <option value="Musik">Musik</option><option value="Seminar">Seminar</option><option value="Olahraga">Olahraga</option>
                            </select>
                        </div>
                        <div class="mb-3"><label class="fw-bold small">Lokasi</label><input type="text" name="lokasi" class="form-control" required></div>
                        <div class="row">
                            <div class="col-6 mb-3"><label class="fw-bold small">Tanggal</label><input type="date" name="tanggal" class="form-control" required></div>
                            <div class="col-6 mb-3"><label class="fw-bold small">Harga (Rp)</label><input type="number" name="harga" class="form-control" required></div>
                        </div>
                        <div class="mb-3"><label class="fw-bold small">Stok Tiket</label><input type="number" name="stok" class="form-control" value="100" required></div>
                        <div class="mb-3"><label class="fw-bold small">Deskripsi</label><textarea class="form-control" name="deskripsi" rows="3" required></textarea></div>
                        <div class="mb-3"><label class="fw-bold small">URL Poster</label><input type="text" name="poster" class="form-control" placeholder="https://..." ></div>
                    </div>
                    <div class="modal-footer"><button type="submit" class="btn btn-success fw-bold w-100">Simpan Event</button></div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function bukaModalTambah() {
            var myModal = new bootstrap.Modal(document.getElementById('eventModal'));
            myModal.show();
        }
    </script>
</body>
</html>
