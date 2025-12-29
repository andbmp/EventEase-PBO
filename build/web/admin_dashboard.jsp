<%-- 
    Document   : admin_dashboard
    Created on : 29 Dec 2025, 07.21.54
    Author     : Edgar
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    // 1. CEK SESSION ADMIN
    String adminName = (String) session.getAttribute("namaUser");
    String role = (String) session.getAttribute("role");
    
    // Jika bukan admin, tendang ke login
    if (adminName == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
        return;
    }

    // SIAPKAN DATA DARI DATABASE
    List<Map<String, String>> pendingEvents = new ArrayList<>();
    List<Map<String, String>> allUsers = new ArrayList<>();
    double totalRevenue = 0;
    int totalTiketTerjual = 0;
    int totalUser = 0;

    try {
        Connection conn = Koneksi.getConnection();
        Statement stmt = conn.createStatement();
        
        // A. AMBIL EVENT PENDING (Untuk Verifikasi)
        String sqlEvent = "SELECT * FROM events WHERE status = 'Pending'";
        ResultSet rsEvent = stmt.executeQuery(sqlEvent);
        while(rsEvent.next()) {
            Map<String, String> map = new HashMap<>();
            map.put("id", rsEvent.getString("id"));
            map.put("nama", rsEvent.getString("nama_event"));
            map.put("lokasi", rsEvent.getString("lokasi"));
            map.put("tanggal", rsEvent.getString("tanggal"));
            pendingEvents.add(map);
        }
        
        // B. AMBIL DATA USER
        Statement stmt2 = conn.createStatement();
        ResultSet rsUser = stmt2.executeQuery("SELECT * FROM users");
        while(rsUser.next()) {
            Map<String, String> map = new HashMap<>();
            map.put("id", rsUser.getString("id"));
            map.put("nama", rsUser.getString("nama"));
            map.put("email", rsUser.getString("email"));
            map.put("role", rsUser.getString("role"));
            allUsers.add(map);
            totalUser++;
        }

        // C. HITUNG STATISTIK (Dari tabel events yg sudah aktif)
        // Kita hitung (harga * terjual) sebagai simulasi pendapatan
        Statement stmt3 = conn.createStatement();
        ResultSet rsStats = stmt3.executeQuery("SELECT harga, terjual FROM events WHERE status='Aktif'");
        while(rsStats.next()){
            double h = rsStats.getDouble("harga");
            int t = rsStats.getInt("terjual");
            totalTiketTerjual += t;
            totalRevenue += (h * t);
        }

        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    // Format Rupiah
    Locale indonesia = new Locale("id", "ID");
    NumberFormat fmt = NumberFormat.getCurrencyInstance(indonesia);
    String revenueFmt = fmt.format(totalRevenue).replace(",00", "");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - EventEase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .sidebar { min-height: 100vh; background-color: #212529; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px 20px; display: block; border-left: 4px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background-color: #343a40; color: white; border-left-color: #0d6efd; }
        .content-section { display: none; } 
        .content-section.active { display: block; animation: fadeIn 0.5s; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body class="bg-light">

    <div class="d-flex">
        <div class="sidebar col-md-2 d-none d-md-block">
            <div class="p-3 text-center fw-bold fs-5 border-bottom border-secondary">
                <i class="fas fa-user-shield me-2"></i> Admin Panel
            </div>
            <nav class="mt-3">
                <a href="#" onclick="switchMenu('verifikasi')" class="active" id="menu-verifikasi">
                    <i class="fas fa-check-circle me-2"></i> Verifikasi Event
                    <% if(pendingEvents.size() > 0) { %>
                        <span class="badge bg-danger rounded-pill float-end"><%= pendingEvents.size() %></span>
                    <% } %>
                </a>
                <a href="#" onclick="switchMenu('users')" id="menu-users">
                    <i class="fas fa-users-cog me-2"></i> Kelola User
                </a>
                <a href="#" onclick="switchMenu('laporan')" id="menu-laporan">
                    <i class="fas fa-chart-line me-2"></i> Lihat Laporan
                </a>
            </nav>
        </div>

        <div class="col-md-10 col-12">
            <nav class="navbar navbar-dark bg-primary shadow-sm px-4 mb-4">
                <span class="navbar-brand mb-0 h1 fw-bold"><i class="fas fa-user-shield me-2"></i> Dashboard Admin</span>
                <div class="d-flex align-items-center bg-white rounded-pill px-2 py-1 shadow-sm">
                    <span class="text-dark fw-bold small mx-3">Halo, <%= adminName %>!</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm rounded-circle"><i class="fas fa-power-off"></i></a>
                </div>
            </nav>

            <div class="px-4">
                
                <div id="section-verifikasi" class="content-section active">
                    <h4 class="fw-bold mb-3">Verifikasi Pengajuan Event</h4>
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="ps-4">Event</th>
                                        <th>Tanggal & Lokasi</th>
                                        <th>Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(Map<String, String> ev : pendingEvents) { %>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%= ev.get("nama") %></td>
                                        <td><%= ev.get("tanggal") %> | <%= ev.get("lokasi") %></td>
                                        <td>
                                            <a href="admin_process?action=approve&id=<%= ev.get("id") %>" class="btn btn-sm btn-success me-1" title="Setujui"><i class="fas fa-check"></i></a>
                                            <a href="admin_process?action=reject&id=<%= ev.get("id") %>" class="btn btn-sm btn-danger" title="Tolak"><i class="fas fa-times"></i></a>
                                        </td>
                                    </tr>
                                    <% } %>
                                    <% if(pendingEvents.isEmpty()) { %>
                                        <tr><td colspan="3" class="text-center py-4 text-muted">Tidak ada event pending.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div id="section-users" class="content-section">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold">Manajemen User</h4>
        </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-striped align-middle mb-0">
                <thead class="bg-dark text-white">
                    <tr>
                        <th class="ps-4">Nama</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, String> u : allUsers) { %>
                    <tr>
                        <td class="ps-4 fw-bold"><%= u.get("nama") %></td>
                        <td><%= u.get("email") %></td>
                        <td>
                            <% String r = u.get("role"); String badge = "bg-secondary";
                               if("admin".equalsIgnoreCase(r)) badge="bg-danger";
                               else if("penjual".equalsIgnoreCase(r)) badge="bg-success";
                               else badge="bg-primary";
                            %>
                            <span class="badge <%= badge %> rounded-pill"><%= r %></span>
                        </td>
                        <td class="text-center">
                            <% if(!u.get("email").equals(adminName) && !"admin".equalsIgnoreCase(u.get("role"))) { %>
                                <a href="admin_delete_user?id=<%= u.get("id") %>" 
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Yakin ingin menghapus user <%= u.get("nama") %>? Data tidak bisa dikembalikan.')">
                                    <i class="fas fa-trash-alt"></i> Hapus
                                </a>
                            <% } else { %>
                                <span class="text-muted small"><i class="fas fa-lock"></i></span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

                <div id="section-laporan" class="content-section">
                    <h4 class="fw-bold mb-3">Laporan Statistik</h4>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm p-4 text-center">
                                <h2 class="text-success fw-bold"><%= revenueFmt %></h2>
                                <p class="text-muted">Total Pendapatan</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm p-4 text-center">
                                <h2 class="text-primary fw-bold"><%= totalTiketTerjual %></h2>
                                <p class="text-muted">Tiket Terjual</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm p-4 text-center">
                                <h2 class="text-warning fw-bold"><%= totalUser %></h2>
                                <p class="text-muted">Total User</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function switchMenu(menu) {
            document.querySelectorAll('.content-section').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.sidebar a').forEach(el => el.classList.remove('active'));
            document.getElementById('section-' + menu).classList.add('active');
            document.getElementById('menu-' + menu).classList.add('active');
        }
    </script>
</body>
</html>
