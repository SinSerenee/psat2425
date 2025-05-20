PSAT2425 - Panduan Lengkap Deploy CRUD Siswa di AWS EC2 + RDS
Deskripsi
Repositori ini digunakan untuk menyimpan aplikasi CRUD siswa sebagai bagian dari penilaian praktek PSAT 2025.

Persiapan:
1. Buat Security Group di EC2
SG-ServerDB (untuk database)
Inbound Rule:

Type: MySQL/Aurora

Port: 3306

Source: Anywhere (0.0.0.0/0)

SG-ServerWeb (untuk aplikasi web)
Inbound Rules:

SSH (port 22) – from Anywhere (0.0.0.0/0)

HTTP (port 80) – from Anywhere (0.0.0.0/0)

HTTPS (port 443) – from Anywhere (0.0.0.0/0)

Database RDS (MySQL)
1. Buka AWS Console → Cari RDS
2. Klik Create Database
Engine Type: pilih MySQL

Template: pilih Free Tier

DB Cluster Identifier: contoh serverdb

Master Username: biarkan default (admin)

Master Password: isi MyP4ssw0rd12345

Public Access: No

VPC Security Group: pilih SG-ServerDB (yang buka port 3306 dari 0.0.0.0/0)

Catat endpoint host database setelah RDS selesai dibuat, misalnya:
database-1.cgxshlk266oq.us-east-1.rds.amazonaws.com

Deploy Aplikasi ke EC2
1. Launch EC2 Instance
OS: Ubuntu Server (contoh: Ubuntu 22.04 LTS)

Instance Type: t2.nano

Key Pair: pilih vockey (buat terlebih dahulu kalau belum ada)

Security Group: pilih SG-ServerWeb

2. Isi Bagian User Data (Advanced Details)
bash
Copy
Edit
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2 php php-mysql libapache2-mod-php mysql-client git
sudo rm -rf /var/www/html/{*,.*}
sudo git clone https://github.com/SinSerenee/psat2425.git /var/www/html
sudo chmod -R 777 /var/www/html
echo DB_USER=admin > /var/www/html/.env
echo DB_PASS=MyP4ssw0rd12345 >> /var/www/html/.env
echo DB_NAME=crudsiswa >> /var/www/html/.env
echo DB_HOST=database-1.cgxshlk266oq.us-east-1.rds.amazonaws.com >> /var/www/html/.env
sudo apt install -y openssl
sudo a2enmod ssl
sudo a2ensite default-ssl.conf
sudo systemctl reload apache2
Pastikan nilai DB_HOST dan DB_PASS sesuai dengan yang kamu buat di RDS

3. Launch & Akses Aplikasi
Klik Launch Instance

Tunggu status menjadi Running

Buka browser dan akses:
http://<Public-IP-Instance>

4. Verifikasi
Login ke instance (jika perlu):

bash
Copy
Edit
cd /var/www/html
ls
Jika muncul file seperti dashboard.php, style.css, dan README.md, berarti berhasil.

5. Isi Aplikasi
Masukkan user : admin
Masukkan password : 123

Masukkan beberapa data siswa.

Screenshot hasil tampilan aplikasi.

6. Upload
Kirim link GitHub repo dan screenshot hasil aplikasi ke Google Form PSAT.

Troubleshooting
Jika muncul HTTP ERROR 500:

Periksa .env

Tes koneksi ke DB:

bash
Copy
Edit
mysql -h <DB_HOST> -u admin -p
Lihat log error:

bash
Copy
Edit
sudo tail -n 20 /var/log/apache2/error.log