# Anggota Kelompok

Citra Andini Hermawan - 2206830012 <br>
Eryawan Presma Yulianrifat - 2206041335 <br>
Ellisha Natasha - 2206028516 <br>
Dian Fathur Rahman - 2206082096 <br>
Joy Debora Sitorus - 2206082991 <br>
Veronica Kylie - 2206029563

# Deskripsi Aplikasi

Kelompok kami akan membuat aplikasi bernama BookMates. Aplikasi ini berfungsi sebagai katalog buku untuk anak-anak. Pada aplikasi ini, pengguna dapat mencari buku, memberi rating untuk buku, dan bersaing dengan pengguna lain untuk memberi rating terbanyak. Selain itu, pengguna tertentu juga dapat menambahkan buku baru ke dalam katalog.

# Daftar Modul yang Diimplementasikan

1. Login + Register (Citra Andini Hermawan)

Halaman untuk user registrasi akun (bila belum punya) atau login jika sudah punya akun. Adapula akun user dapat berupa pembaca maupun penulis.

2. Dashboard/Landing Page + Navbar (Ellisha Natasha)

Halaman yang menampilkan profil pengguna dan seluruh katalog buku. Jika ia merupakan seorang guru, maka akan ada tombol untuk mengarahkan ke halaman untuk mengelola buku yang diunggah dan menambah buku baru. Navigation bar akan berada di sebelah kiri dan berfungsi untuk navigasi ke halaman-halaman lain, seperti search katalog, leaderboard, dan rating buku. 

3. Search Katalog (Joy Debora Sitorus)

Modul ini menampilkan katalog-katalog buku yang dikelompokkan berdasarkan genre dan penulis buku. Halaman web ini juga dilengkapi dengan fitur search atau pencarian di mana user dapat melakukan pencarian dalam bentuk tag genre maupun nama penulis. Hasil pencarian akan menampilkan buku-buku yang sesuai dengan permintaan user. 

4. Leaderboard (Dian Fathur Rahman)

Modul ini akan menampilkan peringkat pembaca yang paling rajin memberikan rating pada buku. Selain itu leaderboard juga berisi buku-buku populer dengan rating terbanyak.

5. Rating Buku (Eryawan Presma Yulianrifat)

Pada modul ini, pembaca dapat memberikan rating pada buku yang telah dibaca. Saat memberi rating, pembaca akan memberikan bintang 1 hingga 5 dan kesan setelah membaca buku tersebut. Selain bintang, pembaca juga bisa menambahkan komentar.

6. Mengelola Buku (Veronica Kylie)

Modul dimana penulis dapat menambahkan dan menghapus buku. Buku yang ditambahkan penulis dapat dilihat oleh semua pengguna aplikasi, tetapi tidak bisa dihapus oleh penulis lain.

# Role Pengguna
1. Penulis
    * Menambahkan buku baru dalam katalog
    * Menghapus buku yang ditambahkan
    * Melakukan hal-hal yang dilakukan pengguna biasa

2. Pembaca
    * Explore buku baru yang dapat dibaca baik melalui katalog dan modul search
    * Memberi rating bagi buku
    * Berpartisipasi dalam leaderboard dengan memberikan rating

# Alur Pengintegrasian
1. Dalam menghubungkan flutter dan django, akan digunakan beberapa library yang akan mempermudah seperti pbp_django untuk proses login dan logout, dan http untuk proses fetching json dari endpoint django.
2. Beberapa endpoint dari projek uts digunakan kembali dalam pengintegrasian. Untuk mendukung beberapa fitur tambahan, beberapa endpoint baru ditambahkan. 
3. Frontend flutter kemudian akan memanggil endpoint backend yang ada pada django secara asynchronous.

# Tautan Berita Acara

[Link GDocs Berita Acara Kami](https://docs.google.com/spreadsheets/d/1zQ68lFicQ0OQE3q7AP53PekBuTdB7l3QsvXFU262EPQ/edit?usp=sharing)

[![Build status](https://build.appcenter.ms/v0.1/apps/d564891b-34a2-44c7-97e0-158e0adf0a79/branches/main/badge)](https://appcenter.ms)
