# PSAT2425 - Panduan Deploy Aplikasi CRUD Siswa di AWS EC2

## Deskripsi

Repositori ini digunakan untuk menyimpan aplikasi CRUD siswa sebagai bagian dari penilaian praktek PSAT 2025.

---

## Langkah Deploy di AWS EC2

### 1. Buat Instance Baru

* Masuk ke AWS Console → EC2 → Launch Instance.
* Berikan nama instance bebas (contoh: `psat-deploy`).
* Pilih OS: **Ubuntu Server** (misalnya Ubuntu 24.04 LTS).
* Instance type: `t2.nano`.
* Key Pair: pilih `vockey`.
* Network Settings: pilih **Select existing security group** lalu pilih **SG server web** (harus sudah ada dan membuka port 80/443).

---

### 2. Tambahkan Script di User Data

Scroll ke bagian **Advanced Details** → **User data**, lalu isi dengan skrip ini:

```bash
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2 php php-mysql libapache2-mod-php mysql-client
sudo rm -rf /var/www/html/{*,.*}
sudo git clone https://github.com/SinSerenee/psat2425.git /var/www/html
sudo chmod -R 777 /var/www/html
echo DB_USER=admin > /var/www/html/.env
echo DB_PASS=MyP4ssw0rd12345 >> /var/www/html/.env
echo DB_NAME=crudsiswa  >> /var/www/html/.env
echo DB_HOST=database-1.cgxshlk266oq.us-east-1.rds.amazonaws.com >> /var/www/html/.env
sudo apt install openssl
sudo a2enmod ssl
sudo a2ensite default-ssl.conf
sudo systemctl reload apache2
```

> ⚠️ Pastikan `DB_PASS` dan `DB_HOST` disesuaikan dengan info RDS kamu sendiri.

---

### 3. Launch Instance

* Klik **Launch Instance**
* Tunggu statusnya sampai **Running**

---

### 4. Verifikasi

Setelah instance aktif:

```bash
cd /var/www/html
ls
```

Jika muncul file seperti `README.md`, `dashboard.php`, dan lainnya, berarti aplikasi berhasil ter-deploy.

---

### 5. Buka di Browser

Buka:

```
http://<Public-IP-Instance-Kamu>
```

Kamu akan melihat aplikasi CRUD siswa tampil.

---

### 6. Isi Aplikasi

* Masukkan data siswa kamu
* Screenshot halaman hasil isian data
* Upload screenshot dan link repo GitHub ke **Google Form** yang disediakan

---

## Catatan

* `UserData` hanya berjalan saat pertama kali instance dibuat.
* Jika muncul **HTTP Error 500**:

  * Cek file `.env`
  * Tes koneksi ke RDS
  * Periksa log Apache:

    ```bash
    sudo tail -n 20 /var/log/apache2/error.log
    ```
