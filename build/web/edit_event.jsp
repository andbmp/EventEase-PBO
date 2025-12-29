<%-- 
    Document   : edit_event
    Created on : 29 Dec 2025, 09.00.06
    Author     : Wildan
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.eventease.config.Koneksi" %>

<%
    String id = request.getParameter("id");
    
    String nama="", kat="", lok="", tgl="", hrg="", stok="", desc="", poster="";
    
    if(id != null) {
        try {
            Connection conn = Koneksi.getConnection();
            String sql = "SELECT * FROM events WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                nama = rs.getString("nama_event");
                kat = rs.getString("kategori");
                lok = rs.getString("lokasi");
                tgl = rs.getString("tanggal");
                hrg = String.valueOf((long)rs.getDouble("harga")); // Konversi ke angka bulat
                stok = rs.getString("stok");
                desc = rs.getString("deskripsi");
                poster = rs.getString("poster_url");
            }
            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Event</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5" style="max-width: 600px;">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-warning text-white fw-bold">
                Edit Event
            </div>
            <div class="card-body">
                <form action="process_edit_event" method="POST">
                    <input type="hidden" name="id" value="<%= id %>">

                    <div class="mb-3">
                        <label class="form-label small fw-bold">Nama Event</label>
                        <input type="text" name="nama" class="form-control" value="<%= nama %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Kategori</label>
                        <select class="form-select" name="kategori">
                            <option value="Musik" <%= "Musik".equals(kat) ? "selected" : "" %>>Musik</option>
                            <option value="Seminar" <%= "Seminar".equals(kat) ? "selected" : "" %>>Seminar</option>
                            <option value="Olahraga" <%= "Olahraga".equals(kat) ? "selected" : "" %>>Olahraga</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Lokasi</label>
                        <input type="text" name="lokasi" class="form-control" value="<%= lok %>" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold">Tanggal</label>
                            <input type="date" name="tanggal" class="form-control" value="<%= tgl %>" required>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label small fw-bold">Harga</label>
                            <input type="number" name="harga" class="form-control" value="<%= hrg %>" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Stok</label>
                        <input type="number" name="stok" class="form-control" value="<%= stok %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Deskripsi</label>
                        <textarea name="deskripsi" class="form-control" rows="3"><%= desc %></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold">URL Poster</label>
                        <input type="text" name="poster" class="form-control" value="<%= poster %>">
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-warning text-white fw-bold">Simpan Perubahan</button>
                        <a href="seller_dashboard.jsp" class="btn btn-secondary">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
