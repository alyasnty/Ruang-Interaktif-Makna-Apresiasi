# RIMA 2.0 — Admin + Database

Prototype ini mengubah RIMA menjadi aplikasi yang siap dihubungkan ke Supabase:
- Supabase Auth untuk login admin
- PostgreSQL untuk puisi, kuis, media, dan progress
- Supabase Storage untuk audio/video
- RLS untuk membatasi akses database
- Dashboard admin untuk menambah/menghapus konten

## 1. Buat project Supabase
Buka https://supabase.com dan buat satu project baru.

## 2. Buat database
Di Supabase:
SQL Editor → New query → tempel seluruh isi `supabase_schema.sql` → Run.

## 3. Buat akun admin
Supabase Dashboard → Authentication → Users → Add user.
Buat email dan password admin.

Catatan: versi prototype ini memperlakukan user yang berhasil login sebagai admin. Untuk produksi, sebaiknya dibuat role admin khusus dengan RLS/claims.

## 4. Hubungkan aplikasi
Buka `index.html` dengan editor teks.

Cari:
const CONFIG={url:"YOUR_SUPABASE_URL",key:"YOUR_SUPABASE_PUBLISHABLE_KEY"};

Ganti dengan:
- Project URL
- Publishable key (atau anon key pada project lama)

Jangan pernah memasukkan `service_role` / secret key ke file HTML atau browser.

## 5. Jalankan
Untuk uji cepat, buka index.html di browser.

Untuk penggunaan internet, upload folder ini ke hosting statis seperti GitHub Pages, Netlify, Vercel, atau hosting kampus. Supabase tetap menjadi backend.

## 6. Masuk Admin
Klik tombol `Admin` → masukkan email/password akun Supabase → dashboard.

Di dashboard:
- Video & Audio → upload media
- Kuis → tambah pertanyaan, opsi, jawaban, feedback, level
- Puisi → tambah puisi
- Progress Siswa → lihat data yang tersimpan

## Catatan keamanan
RLS adalah bagian penting. Jangan menggunakan service-role key di browser. Jika RIMA dipakai banyak kelas, buat role admin khusus sebelum produksi.

## Struktur
index.html            aplikasi siswa + admin
supabase_schema.sql   struktur database + RLS + Storage
README.md             panduan setup
