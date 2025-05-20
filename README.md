````markdown
# PSAT2425 - Panduan Lengkap Deploy CRUD Siswa di AWS EC2 + RDS

## Deskripsi
Repositori ini menyimpan aplikasi CRUD siswa untuk keperluan penilaian praktek PSAT 2025. Panduan ini menjelaskan proses lengkap mulai dari setup database hingga deploy aplikasi menggunakan AWS EC2 dan UserData.

---

## Persiapan

### Buat Security Group di EC2

#### SG-ServerDB
- **Inbound Rule**:
  - Type: MySQL/Aurora
  - Port: 3306
  - Source: Anywhere (0.0.0.0/0)

#### SG-ServerWeb
- **Inbound Rules**:
  - SSH (port 22) – Anywhere (0.0.0.0/0)
  - HTTP (port 80) – Anywhere (0.0.0.0/0)
  - HTTPS (port 443) – Anywhere (0.0.0.0/0)

---

## Konfigurasi Database RDS (MySQL)

### Langkah-langkah:
1. Buka **AWS Console** → cari **RDS**.
2. Klik **Create Database**.
3. Konfigurasi:
   - Engine Type: **MySQL**
   - Templates: **Free Tier**
   - DB Identifier: `serverdb`
   - Master Username: `admin`
   - Master Password: `MyP4ssw0rd12345`
   - Public Access: **No**
   - Security Group: Pilih **SG-ServerDB**

> Setelah selesai, catat DB endpoint, misalnya:
> `database-1.cgxshlk266oq.us-east-1.rds.amazonaws.com`

---

## Deploy Aplikasi ke AWS EC2

### 1. Launch Instance
- OS: **Ubuntu Server 22.04 LTS**
- Instance Type: `t2.nano`
- Key Pair: `vockey`
- Security Group: pilih **SG-ServerWeb**

### 2. Tambahkan Script di User Data
Saat membuat instance, scroll ke bagian **Advanced Details → User Data**, lalu paste:

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
````

> Ganti `DB_HOST` dan `DB_PASS` sesuai konfigurasi RDS kamu jika berbeda.

---

## Verifikasi

### Cek dari browser:

Buka:

```
http://<Public-IP-Instance>
```

### Cek lewat terminal (opsional):

```bash
cd /var/www/html
ls
```

Kalau muncul file seperti `dashboard.php`, `style.css`, dan `README.md`, berarti **berhasil**.

---

## Pengisian Data
* Masukkan user : admin
* Masukkan password : 123
* Tambahkan data siswa ke dalam aplikasi.
* Ambil **screenshot** hasilnya.
* Upload ke **Google Form** PSAT sesuai instruksi.

---

## Troubleshooting

* **Error 500 (Internal Server Error)?**

  * Periksa file `.env`
  * Tes koneksi ke DB:

    ```bash
    mysql -h <DB_HOST> -u admin -p
    ```
  * Cek log error:

    ```bash
    sudo tail -n 20 /var/log/apache2/error.log
    ```

---

## Link Repositori

[https://github.com/SinSerenee/psat2425](https://github.com/SinSerenee/psat2425)

---

Semoga sukses dan lancar dalam pengumpulan tugas PSAT! 🎯

```

---