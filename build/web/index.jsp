<%-- 
    Document   : index
    Created on : 29 Dec 2025, 07.06.27
    Author     : Nyoman Kimi
--%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk / Daftar - EventEase</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card { width: 100%; max-width: 420px; }
        .nav-pills .nav-link { color: #6c757d; font-weight: 600; }
        .nav-pills .nav-link.active { background-color: #0d6efd; color: white; border-radius: 50px; }
    </style>
</head>
<body>

    <div class="card shadow-lg login-card p-4 border-0 rounded-4">
        <div class="text-center mb-4">
            <h2 class="fw-bold text-primary"><i class="fas fa-ticket-alt"></i> EventEase</h2>
            <p class="text-muted small">Platform Tiket Event Terpercaya</p>
        </div>

        <ul class="nav nav-pills nav-fill mb-4 bg-light rounded-pill p-1" id="pills-tab" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="pills-login-tab" data-bs-toggle="pill" data-bs-target="#pills-login" type="button">Masuk</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="pills-register-tab" data-bs-toggle="pill" data-bs-target="#pills-register" type="button">Daftar Akun</button>
            </li>
        </ul>

        <div class="tab-content" id="pills-tabContent">
            
            <div class="tab-pane fade show active" id="pills-login">
                <%
    String status = request.getParameter("status");
    String error = request.getParameter("error");

    if ("sukses".equals(status)) {
%>
    <div class="alert alert-success text-center">
        <i class="fas fa-check-circle"></i> Registrasi Berhasil! Silakan Login.
    </div>
<%
    } else if ("gagal".equals(status)) {
%>
    <div class="alert alert-warning text-center">
        Registrasi Gagal! Silakan coba lagi.
    </div>
<%
    } else if ("error".equals(status)) {
%>
    <div class="alert alert-danger text-center">
        Terjadi Kesalahan Sistem! Cek Output NetBeans.
    </div>
<%
    }
    
    // Pesan Error Login (Yang sudah ada sebelumnya)
    if ("invalid".equals(error)) {
%>
<%
    } else if ("server".equals(error)) {
%>
    <div class="alert alert-danger text-center">
        Koneksi Database Error!
    </div>
<%
    }
%>
                <form id="loginForm" action="login" method="post">
    
    <% if("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger p-2 small text-center mb-3">
            Email atau Password salah!
        </div>
    <% } %>

    <div class="mb-3">
        <label class="fw-bold small">Email</label>
        <div class="input-group">
            <span class="input-group-text bg-white"><i class="fas fa-envelope text-muted"></i></span>
            <input type="email" name="email" class="form-control" id="emailLogin" placeholder="email@contoh.com" required>
        </div>
    </div>
    <div class="mb-3">
        <label class="fw-bold small">Password</label>
        <div class="input-group">
            <span class="input-group-text bg-white"><i class="fas fa-lock text-muted"></i></span>
            <input type="password" name="password" class="form-control" id="passwordLogin" placeholder="********" required>
        </div>
    </div>
    <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-bold shadow-sm">Masuk Sekarang</button>
</form>
            </div>

            <div class="tab-pane fade" id="pills-register">
    <form id="registerForm" action="register" method="post">
        
        <div class="mb-3">
            <label class="fw-bold small">Nama Lengkap</label>
            <input type="text" name="nama" class="form-control" id="regNama" placeholder="Nama Anda" required>
        </div>

        <div class="mb-3">
            <label class="fw-bold small">Email</label>
            <input type="email" name="email" class="form-control" id="regEmail" placeholder="email@contoh.com" required>
        </div>
        
        <div class="mb-3">
            <label class="fw-bold small">Daftar Sebagai:</label>
            <select class="form-select" name="role" id="regRole">
                <option value="user">User (Pembeli Tiket)</option>
                <option value="penjual">Event Organizer (Penjual)</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="fw-bold small">Password</label>
            <input type="password" name="password" class="form-control" id="regPassword" placeholder="Buat password" required>
        </div>

        <button type="submit" class="btn btn-success w-100 py-2 rounded-pill fw-bold shadow-sm">Buat Akun Baru</button>
    </form>
</div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>
