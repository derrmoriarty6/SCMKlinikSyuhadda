# 📋 Panduan Presentasi UAS - Pemrograman Visual
## Perancangan Sistem Informasi Pengolahan Data Pasien Berbasis Model WaterFall Pada Klinik Syuhadda
### Tema: SCM (Supply Chain Management)

---

## 1. PENDAHULUAN (Pembuka Presentasi)

### 1.1 Latar Belakang
"Klinik Syuhadda adalah klinik kesehatan yang membutuhkan sistem informasi untuk mengelola data pasien secara digital. Saat ini pencatatan masih dilakukan secara manual sehingga rentan terhadap kehilangan data, kesalahan pencatatan, dan lambatnya pencarian data pasien."

### 1.2 Tujuan Project
- Merancang dan membangun **Sistem Informasi Pengolahan Data Pasien** berbasis desktop
- Mengimplementasikan konsep **CRUD** (Create, Read, Update, Delete)
- Menerapkan tema **SCM (Supply Chain Management)** dalam konteks pelayanan kesehatan
- Menggunakan **Model WaterFall** sebagai metodologi pengembangan

### 1.3 Teknologi yang Digunakan
| Komponen | Teknologi |
|---|---|
| Bahasa Pemrograman | **VB .NET Framework 4** |
| IDE | **Microsoft Visual Studio** |
| Database | **MySQL** (via phpMyAdmin/XAMPP) |
| Koneksi Database | **MySQL Connector .NET 6.6.4** |
| Library | `MySql.Data.MySqlClient` |

---

## 2. KONSEP SCM DALAM KONTEKS KLINIK

### 2.1 Apa itu SCM?
**Supply Chain Management** adalah pengelolaan seluruh aliran barang, informasi, dan jasa dari **pemasok** hingga **konsumen akhir**.

### 2.2 Penerapan SCM di Klinik Syuhadda
Dalam konteks klinik, SCM bukan tentang logistik barang manufaktur, melainkan tentang **rantai layanan kesehatan**:

```
[SUPPLIER OBAT] → [STOK OBAT DI KLINIK] → [PELAYANAN KE PASIEN] → [REKAM MEDIS]
     ↓                    ↓                       ↓                      ↓
  tblobat            Data Obat              FormRekamMedis          queryrekammedis
  (Input)           (Inventory)             (Service Delivery)        (Output/Laporan)
```

**Jelaskan ke dosen:**
> "Dalam project ini, SCM diterapkan melalui rantai pasokan layanan kesehatan. Data obat yang masuk dari supplier dicatat dalam sistem (tblobat), kemudian saat pasien datang berobat, dokter memeriksa dan meresepkan obat. Seluruh proses ini dicatat dalam rekam medis, yang merupakan output akhir dari rantai layanan."

---

## 3. MODEL WATERFALL

### 3.1 Tahapan WaterFall yang Diterapkan

```
┌─────────────────────┐
│  1. REQUIREMENTS    │ → Analisis kebutuhan sistem klinik
├─────────────────────┤
│  2. DESIGN          │ → Desain database & form UI
├─────────────────────┤
│  3. IMPLEMENTATION  │ → Coding VB.NET + MySQL
├─────────────────────┤
│  4. TESTING         │ → Test CRUD setiap form
├─────────────────────┤
│  5. MAINTENANCE     │ → Perbaikan bug & update
└─────────────────────┘
```

**Jelaskan ke dosen:**
> "Kami menggunakan model Waterfall karena kebutuhan sistem sudah jelas dari awal. Setiap tahap diselesaikan secara berurutan: mulai dari analisis kebutuhan klinik, merancang database dan UI, menulis kode program, melakukan pengujian, hingga siap digunakan."

---

## 4. STRUKTUR DATABASE

### 4.1 Database: `db_klinik_syuhadda`

**5 Tabel + 1 View:**

| No | Tabel | Fungsi | Primary Key |
|---|---|---|---|
| 1 | `user` | Data login pengguna | `id_user` (AUTO_INCREMENT) |
| 2 | `tblpasien` | Data master pasien | `no_rm` |
| 3 | `tbldokter` | Data master dokter | `kd_dokter` |
| 4 | `tblobat` | Data master obat | `kd_obat` |
| 5 | `tblrekammedis` | Transaksi rekam medis | `id_rm` (AUTO_INCREMENT) |
| 6 | `queryrekammedis` | VIEW untuk menggabungkan semua tabel | - |

### 4.2 Relasi Antar Tabel
```
tblpasien ──┐
            ├──→ tblrekammedis ──→ queryrekammedis (VIEW)
tbldokter ──┤
            │
tblobat ────┘
```

**Jelaskan ke dosen:**
> "Database menggunakan MySQL dengan nama `db_klinik_syuhadda`. Terdapat 5 tabel utama dan 1 VIEW. Tabel `tblrekammedis` merupakan tabel transaksi yang menghubungkan pasien, dokter, dan obat melalui foreign key. View `queryrekammedis` menggunakan JOIN untuk menggabungkan semua data agar mudah ditampilkan di ListView."

---

## 5. ALUR PROGRAM

```
Program Dimulai
      ↓
┌─────────────────┐
│   FormLogin     │ ← User memasukkan username & password
│                 │   Dicek ke tabel `user` di database
└────────┬────────┘
         ↓ (Login Berhasil)
┌─────────────────┐
│  F_MenuUtama    │ ← Menu utama dengan MenuStrip
│                 │   5 Menu: Input Data, Transaksi, Cari Data, Laporan, Keluar
└────────┬────────┘
         ↓
   ┌─────┼─────┬─────────┬──────────┐
   ↓     ↓     ↓         ↓          ↓
 Input  Trans  Cari    Laporan    Keluar
 Data   aksi   Data
   ↓     ↓     ↓         ↓
 Pasien  RM   Pasien   Cetak
 Dokter       Dokter   (PrintPreview)
 Obat         Obat
```

---

## 6. PENJELASAN SETIAP FORM

### 6.1 FormLogin (Form Login Pengguna)

**Fungsi:** Autentikasi pengguna sebelum masuk ke sistem.

**Komponen UI:**
- `txtUsername` — TextBox untuk username
- `txtPassword` — TextBox dengan PasswordChar `*` untuk keamanan
- `btnLogin` — Tombol login
- `btnExit` — Tombol keluar

**Cara Kerja Login:**
```vb
' Query SELECT ke tabel user untuk verifikasi
cmd = New MySqlCommand("SELECT * FROM user WHERE username='" & txtUsername.Text & "' AND password='" & txtPassword.Text & "'", conn)
RD = cmd.ExecuteReader
RD.Read()
If RD.HasRows = True Then
    ' Login berhasil → sembunyikan FormLogin, tampilkan Menu Utama
    Me.Hide()
    F_MenuUtama.Show()
Else
    ' Login gagal → tampilkan pesan error
    MsgBox("Username atau Password salah!")
End If
```

**Jelaskan ke dosen:**
> "FormLogin menggunakan `MySqlCommand` dan `MySqlDataReader` untuk memverifikasi username dan password dari tabel `user`. Jika data ditemukan (`HasRows = True`), form login disembunyikan dan menu utama ditampilkan."

---

### 6.2 F_MenuUtama (Menu Utama)

**Fungsi:** Navigasi utama ke seluruh fitur aplikasi.

**Komponen:** `MenuStrip` dengan struktur:
- **Input Data** → Pasien, Dokter, Obat
- **Transaksi** → Rekam Medis
- **Cari Data** → Pasien, Dokter, Obat
- **Laporan** → Rekam Medis
- **Keluar**

**Cara Buka Form:**
```vb
' Setiap menu item memanggil form dengan ShowDialog()
Private Sub PasienToolStripMenuItem_Click(...) Handles PasienToolStripMenuItem.Click
    FormPasien.ShowDialog()
End Sub
```

---

### 6.3 FormPasien (CRUD Data Pasien)

**Referensi:** Dibuat berdasarkan `FormMahasiswa` dari project latihan `AplNilaiMhs`.

**Komponen UI:**
- `txtNoRM` — No. Rekam Medis (≈ NIM)
- `txtNamaPasien` — Nama pasien (≈ Nama Mahasiswa)
- `txtTmpLahir` — Tempat lahir
- `dtpTglLahir` — DateTimePicker untuk tanggal lahir
- `txtUsia` — Usia (otomatis dihitung)
- `rdbLaki`, `rdbPerempuan` — **RadioButton** untuk jenis kelamin
- `cbA`, `cbB`, `cbAB`, `cbO` — **CheckBox** untuk golongan darah
- `txtAlamat`, `txtTelp` — Data alamat dan telepon
- `ListView1` — Menampilkan semua data pasien
- Tombol: REFRESH, SAVE, EDIT, DELETE, EXIT, CARI DATA

**Pola CRUD (sama dengan referensi):**

```vb
' === CREATE (SAVE) ===
query = "Insert Into tblpasien Values('" & txtNoRM.Text & "','" & txtNamaPasien.Text & "',...)"
daData = New MySqlDataAdapter(query, conn)
dsData = New DataSet
daData.Fill(dsData)

' === READ (ISILIST) ===
query = "SELECT * FROM tblpasien ORDER BY no_rm"
' Data ditampilkan ke ListView1

' === UPDATE (EDIT) ===
query = "UPDATE tblpasien SET nama_pasien='" & txtNamaPasien.Text & "',... WHERE no_rm='" & txtNoRM.Text & "'"

' === DELETE ===
query = "Delete From tblpasien Where no_rm='" & txtNoRM.Text & "'"
```

**Fitur Khusus:**
- **RadioButton** untuk jenis kelamin → hanya bisa pilih satu (Laki-Laki ATAU Perempuan)
- **CheckBox** untuk golongan darah → menggunakan logika eksklusif (jika A dipilih, B/AB/O otomatis tidak dipilih)
- **DateTimePicker** + **Hitung Usia otomatis** → `thn = Year(Now) - Year(dtpTglLahir.Value)`

**Jelaskan ke dosen:**
> "FormPasien mengimplementasikan CRUD lengkap. Pola kode-nya sama persis dengan FormMahasiswa di project latihan: menggunakan `MySqlDataAdapter` dan `DataSet` untuk eksekusi query. RadioButton digunakan untuk jenis kelamin, dan CheckBox untuk golongan darah. Usia dihitung otomatis dari tanggal lahir."

---

### 6.4 FormDokter (CRUD Data Dokter)

**Referensi:** Berdasarkan `FormDosen` dari `AplNilaiMhs`.

**Field:** Kode Dokter (≈ NIDN), Nama Dokter (≈ Nama Dosen), Spesialis (≈ Email), Telepon.

**Pola kode 100% sama dengan FormDosen**, hanya nama tabel dan field yang diubah.

---

### 6.5 FormObat (CRUD Data Obat)

**Referensi:** Berdasarkan `FormMataKuliah` dari `AplNilaiMhs`.

**Field:** Kode Obat (≈ KdMtk), Nama Obat (≈ NmMtk), Harga (≈ SKS).

---

### 6.6 FormRekamMedis (Transaksi Utama)

**Referensi:** Berdasarkan `FormNilai` dari `AplNilaiMhs`.

**Ini adalah form paling kompleks** karena menggabungkan data dari 3 tabel master.

**Komponen Khusus:**
- `BtnCariPasien` → Membuka `FormCariPasien` untuk memilih pasien
- `BtnCariDokter` → Membuka `FormCariDokter` untuk memilih dokter
- `BtnCariObat` → Membuka `FormCariObat` untuk memilih obat
- `BtnProses` → Menghitung total biaya dan menentukan status

**Fungsi `prosesbiaya()` (≈ `prosesnilai()` di referensi):**
```vb
Private Sub prosesbiaya()
    hargaobat = CInt(txtHarga.Text)
    jumlahobat = CInt(txtJmlObat.Text)
    totalbiaya = hargaobat * jumlahobat    ' Hitung total biaya
    txtTotalBiaya.Text = totalbiaya

    ' Tentukan status berdasarkan diagnosis
    If diagnosis mengandung kata "appendisitis/fraktur/tumor/kanker" Then
        statusPasien = "Dirujuk"           ' Perlu penanganan rumah sakit
    Else
        statusPasien = "Rawat Jalan"       ' Bisa ditangani di klinik
    End If
    txtStatus.Text = statusPasien
End Sub
```

**Jelaskan ke dosen:**
> "FormRekamMedis paralel dengan FormNilai di project latihan. Sama seperti `prosesnilai()` yang menghitung nilai huruf dan bobot, `prosesbiaya()` menghitung total biaya obat dan menentukan status pasien. Tombol CARI membuka form pencarian lookup, sama seperti FormCariMhs di referensi."

---

### 6.7 Form Pencarian (Lookup)

**FormCariPasien, FormCariDokter, FormCariObat** → Referensi dari `FormCariMhs`, `FormCariDosen`, `FormCariMtk`.

**Cara Kerja Lookup:**
```vb
' Saat item di ListView diklik, data dikirim ke FormRekamMedis
Private Sub AmbilDataDariListview()
    FormRekamMedis.txtNoRM.Text = .Item(0).SubItems(0).Text      ' Kirim No RM
    FormRekamMedis.txtNamaPasien.Text = .Item(0).SubItems(1).Text ' Kirim Nama
End Sub
' Lalu form lookup ditutup otomatis
Me.Close()
```

---

### 6.8 FormLaporan (Cetak Laporan)

**Fungsi:** Menampilkan dan mencetak laporan rekam medis pasien.

**Teknologi:** Menggunakan `PrintDocument` dan `PrintPreviewDialog` bawaan .NET (tanpa Crystal Reports).

**Cara Kerja:**
```vb
' Tombol CETAK membuka Print Preview
Private Sub btnCetak_Click(...)
    Dim ppd As New PrintPreviewDialog()
    ppd.Document = printDoc
    ppd.ShowDialog()    ' Menampilkan preview sebelum cetak
End Sub

' PrintPage event menggambar layout laporan
Private Sub printDoc_PrintPage(...)
    e.Graphics.DrawString("KLINIK SYUHADDA", fontTitle, Brushes.Black, 280, y)
    ' ... header, data rows, footer
End Sub
```

---

## 7. MODUL KONEKSI DATABASE

### `BukaKoneksi.vb`
```vb
Module bukakoneksi
    Public conn As MySqlConnection       ' Objek koneksi
    Public daData As MySqlDataAdapter    ' Adapter untuk query
    Public dsData As DataSet             ' Dataset penampung hasil
    Public query As String               ' String query SQL
    Public RD As MySqlDataReader         ' Reader untuk SELECT
    Public cmd As MySqlCommand           ' Command untuk eksekusi

    Public Sub koneksiKeDataBase()
        Dim str As String = "server=localhost;user id=root;password=;database=db_klinik_syuhadda"
        conn = New MySqlConnection(str)
        If conn.State = ConnectionState.Closed Then
            conn.Open()
        End If
    End Sub
End Module
```

**Jelaskan ke dosen:**
> "Module `BukaKoneksi` bersifat Public sehingga variabel `conn`, `daData`, `dsData`, dll. bisa diakses dari semua form tanpa perlu membuat koneksi ulang. Pola ini sama persis dengan project latihan AplNilaiMhs."

---

## 8. PEMETAAN REFERENSI: AplNilaiMhs → SCMKlinikSyuhadda

| Komponen AplNilaiMhs | Komponen SCMKlinikSyuhadda | Keterangan |
|---|---|---|
| - | `FormLogin` | **TAMBAHAN** - Form login dengan tabel user |
| `F_MenuUtama` | `F_MenuUtama` | Menu utama, struktur sama |
| `FormMahasiswa` | `FormPasien` | CRUD + RadioButton + CheckBox |
| `FormDosen` | `FormDokter` | CRUD sederhana 4 field |
| `FormMataKuliah` | `FormObat` | CRUD sederhana 3 field |
| `FormNilai` | `FormRekamMedis` | Transaksi + prosesbiaya() |
| `FormCariMhs` | `FormCariPasien` | Lookup pasien |
| `FormCariDosen` | `FormCariDokter` | Lookup dokter |
| `FormCariMtk` | `FormCariObat` | Lookup obat |
| `LHS` (Crystal Reports) | `FormLaporan` (PrintPreview) | **DIUBAH** - tanpa Crystal Reports |
| `BukaKoneksi` | `BukaKoneksi` | Module koneksi, pola sama |
| `dbnilai` | `db_klinik_syuhadda` | Database MySQL |

---

## 9. DESAIN TEMA VISUAL

**Warna Teal/Hijau Toska** dipilih karena:
- Merupakan warna yang identik dengan dunia **medis/kesehatan**
- Memberikan kesan **profesional** dan **terpercaya**
- Konsisten di seluruh form

| Elemen | Warna |
|---|---|
| Panel Background | `RGB(0, 105, 92)` — Teal gelap |
| Label Text | `White` |
| Button Background | `RGB(178, 223, 219)` — Teal muda |
| Button Text | `RGB(0, 77, 64)` — Teal tua |
| MenuStrip | `RGB(0, 77, 64)` — Teal sangat tua |

---

## 10. CARA MENJALANKAN PROGRAM

### Langkah-langkah:
1. **Buka XAMPP** → Start Apache dan MySQL
2. **Buka phpMyAdmin** → `http://localhost/phpmyadmin`
3. **Buat database baru** dengan nama `db_klinik_syuhadda`
4. **Import** file `db_klinik_syuhadda.sql`
5. **Buka project** di Visual Studio → `SCMKlinikSyuhadda.sln`
6. **Tekan F5** atau klik Start untuk menjalankan
7. **Login** dengan:
   - Username: `admin` | Password: `admin123`
   - Username: `operator` | Password: `oper123`

---

## 11. TIPS PRESENTASI KE DOSEN

### ✅ Yang Harus Ditunjukkan:
1. **Tunjukkan database** di phpMyAdmin — struktur tabel dan data
2. **Demo login** — masukkan password salah dulu (tunjukkan validasi), lalu login benar
3. **Demo CRUD** di FormPasien:
   - SAVE: Tambah pasien baru
   - Klik ListView → data terisi ke TextBox (READ)
   - EDIT: Ubah nama pasien → klik EDIT
   - DELETE: Hapus data → konfirmasi OK/Cancel
4. **Demo FormRekamMedis:**
   - Klik CARI Pasien → pilih pasien → data terisi otomatis
   - Klik CARI Dokter → pilih dokter
   - Klik CARI Obat → pilih obat, harga terisi otomatis
   - Isi keluhan, diagnosis, jumlah obat
   - Klik PROSES → total biaya dan status otomatis dihitung
   - Klik SAVE
5. **Demo Laporan** — Klik CETAK → Print Preview muncul

### ✅ Yang Harus Dijelaskan:
- "Kode CRUD mengikuti pola dari project latihan AplNilaiMhs"
- "Module BukaKoneksi sama persis, hanya nama database yang berbeda"
- "FormPasien referensi dari FormMahasiswa, FormDokter dari FormDosen, dll."
- "Tema SCM diterapkan melalui rantai pelayanan: data obat → pelayanan → rekam medis"
- "Model WaterFall: dari analisis kebutuhan → desain → implementasi → testing"

### ❌ Yang Harus Dihindari:
- Jangan bilang "program ini dibuat otomatis" — jelaskan bahwa Anda **memahami kodenya**
- Jangan buru-buru saat demo — tunjukkan setiap fitur dengan jelas
- Jangan panik jika ada error — jelaskan apa yang terjadi dan bagaimana memperbaikinya

---

## 12. PERTANYAAN YANG MUNGKIN DITANYA DOSEN

### Q: "Apa perbedaan project ini dengan project latihan?"
> **A:** "Project latihan mengelola data nilai mahasiswa, sedangkan project ini mengelola data pasien klinik. Pola CRUD-nya sama, tetapi konteks dan tabel database berbeda. Saya juga menambahkan FormLogin dan FormLaporan dengan PrintPreview."

### Q: "Kenapa menggunakan MySqlDataAdapter untuk INSERT/UPDATE/DELETE?"
> **A:** "Ini mengikuti pola dari project latihan. `MySqlDataAdapter.Fill()` akan mengeksekusi query dan hasilnya ditampung di DataSet. Untuk query INSERT/UPDATE/DELETE, DataSet akan kosong tapi query tetap tereksekusi."

### Q: "Bagaimana cara kerja form pencarian (lookup)?"
> **A:** "Saat tombol CARI diklik, form pencarian terbuka. User mencari dan mengklik data di ListView. Data yang dipilih langsung dikirim ke TextBox di FormRekamMedis melalui `FormRekamMedis.txtNoRM.Text = ...`, lalu form pencarian otomatis ditutup."

### Q: "Apa hubungannya dengan SCM?"
> **A:** "SCM dalam konteks klinik adalah rantai pasokan layanan kesehatan. Obat masuk dari supplier (tblobat), tersimpan sebagai inventori, lalu digunakan saat melayani pasien (tblrekammedis). Hasilnya tercatat sebagai output dalam bentuk laporan rekam medis."

### Q: "Kenapa pakai View (queryrekammedis)?"
> **A:** "View digunakan untuk menggabungkan data dari 4 tabel (pasien, dokter, obat, rekam medis) menggunakan JOIN. Tanpa view, kita harus menulis query JOIN yang panjang setiap kali menampilkan data di ListView."

---

*Dokumen ini dibuat sebagai panduan presentasi UAS Pemrograman Visual - Semester 4*
