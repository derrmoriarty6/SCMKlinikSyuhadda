# Perancangan Sistem Informasi Pengolahan Data Pasien Berbasis Model WaterFall Pada Klinik Syuhadda

## Latar Belakang & Konteks

Project UAS mata kuliah Pemrograman Visual semester 4. Sistem ini mengelola data pasien pada **Klinik Syuhadda** dengan tema **SCM (Supply Chain Management)** — dalam konteks klinik, SCM mengacu pada rantai pasokan layanan kesehatan: mulai dari **pendaftaran pasien → pemeriksaan dokter → pemberian obat → transaksi/pembayaran**.

Semua kode CRUD **wajib mengikuti pola/referensi** dari project latihan `AplNilaiMhs`.

---

## Pemetaan Konsep: AplNilaiMhs → SCMKlinikSyuhadda

| AplNilaiMhs (Referensi) | SCMKlinikSyuhadda (Project Baru) | Keterangan |
|---|---|---|
| `tblmahasiswa` | `tblpasien` | Data master pasien (mirip data mahasiswa) |
| `tbldosen` | `tbldokter` | Data master dokter (mirip data dosen) |
| `tblmatakuliah` | `tblobat` | Data master obat (mirip data matakuliah) |
| `tblnilai` + `querynilai` | `tblrekammedis` + `queryrekammedis` | Transaksi/proses utama (mirip nilai) |
| `F_MenuUtama` | `F_MenuUtama` | Menu utama dengan MenuStrip |
| `FormMahasiswa` | `FormPasien` | CRUD data pasien |
| `FormDosen` | `FormDokter` | CRUD data dokter |
| `FormMataKuliah` | `FormObat` | CRUD data obat |
| `FormNilai` | `FormRekamMedis` | Proses transaksi rekam medis |
| `FormCariMhs` | `FormCariPasien` | Pencarian pasien (lookup) |
| `FormCariDosen` | `FormCariDokter` | Pencarian dokter (lookup) |
| `FormCariMtk` | `FormCariObat` | Pencarian obat (lookup) |
| `BukaKoneksi` | `BukaKoneksi` | Module koneksi MySQL |

---

## Konsep SCM dalam Konteks Klinik

> [!IMPORTANT]
> **SCM pada klinik** bukan soal logistik barang seperti di manufaktur, melainkan **rantai layanan kesehatan**:
> 1. **Supplier (Pemasok)** → Data Obat masuk ke klinik
> 2. **Inventory (Persediaan)** → Stok obat tersedia di klinik
> 3. **Service Delivery (Pelayanan)** → Pasien diperiksa dokter, diberi resep obat
> 4. **Output (Hasil)** → Rekam Medis tercatat lengkap dengan diagnosis dan obat

Ini menjadi **nilai tambah saat presentasi** karena menunjukkan pemahaman tema SCM yang diaplikasikan ke domain kesehatan.

---

## Desain Database (`db_klinik_syuhadda.sql`)

### Tabel `tblpasien` (≈ tblmahasiswa)
| Field | Tipe | Keterangan |
|---|---|---|
| `no_rm` | VARCHAR(10) PK | Nomor Rekam Medis (≈ NIM) |
| `nama_pasien` | VARCHAR(50) | Nama lengkap pasien |
| `tmp_lahir` | VARCHAR(30) | Tempat lahir |
| `tgl_lahir` | DATE | Tanggal lahir |
| `usia` | INT(3) | Usia pasien |
| `jenkel` | VARCHAR(10) | Jenis kelamin (RadioButton) |
| `gol_darah` | VARCHAR(5) | Golongan darah (CheckBox: A, B, AB, O) |
| `alamat` | VARCHAR(100) | Alamat pasien |
| `telp` | VARCHAR(15) | Telepon/HP |

### Tabel `tbldokter` (≈ tbldosen)
| Field | Tipe | Keterangan |
|---|---|---|
| `kd_dokter` | VARCHAR(10) PK | Kode dokter (≈ NIDN) |
| `nama_dokter` | VARCHAR(50) | Nama dokter |
| `spesialis` | VARCHAR(30) | Spesialisasi (≈ Email) |
| `telp` | VARCHAR(15) | Telepon |

### Tabel `tblobat` (≈ tblmatakuliah)
| Field | Tipe | Keterangan |
|---|---|---|
| `kd_obat` | VARCHAR(10) PK | Kode obat (≈ kdmtk) |
| `nama_obat` | VARCHAR(50) | Nama obat (≈ nmmtk) |
| `harga` | INT | Harga satuan (≈ SKS) |

### Tabel `tblrekammedis` (≈ tblnilai)
| Field | Tipe | Keterangan |
|---|---|---|
| `id_rm` | INT PK AUTO_INCREMENT | ID rekam medis (≈ id_nilai) |
| `tgl_periksa` | DATE | Tanggal periksa (≈ ta) |
| `no_rm` | VARCHAR(10) FK | Nomor RM pasien (≈ nim) |
| `kd_dokter` | VARCHAR(10) FK | Kode dokter (≈ nidn) |
| `kd_obat` | VARCHAR(10) FK | Kode obat (≈ kdmtk) |
| `keluhan` | VARCHAR(100) | Keluhan pasien |
| `diagnosis` | VARCHAR(100) | Diagnosis dokter |
| `jml_obat` | INT | Jumlah obat |
| `total_biaya` | DOUBLE | Total biaya (harga × jumlah) |
| `status` | VARCHAR(20) | Status: Rawat Jalan / Dirujuk |

### View `queryrekammedis` (≈ querynilai)
JOIN `tblrekammedis` + `tblpasien` + `tbldokter` + `tblobat` untuk menampilkan data lengkap di ListView.

---

## Struktur File Project

```
SCMKlinikSyuhadda/
├── SCMKlinikSyuhadda.sln
├── db_klinik_syuhadda.sql          ← [NEW] File SQL database
└── SCMKlinikSyuhadda/
    ├── SCMKlinikSyuhadda.vbproj    ← [MODIFY] Update references & compile items
    ├── App.config                  ← [MODIFY] Tambah logging config
    ├── BukaKoneksi.vb              ← [NEW] Module koneksi (referensi AplNilaiMhs)
    │
    ├── F_MenuUtama.vb              ← [NEW] Form menu utama
    ├── F_MenuUtama.Designer.vb     ← [NEW] Designer menu utama
    ├── F_MenuUtama.resx            ← [NEW] Resource
    │
    ├── FormPasien.vb               ← [NEW] CRUD Pasien (ref: FormMahasiswa)
    ├── FormPasien.Designer.vb      ← [NEW] Designer
    ├── FormPasien.resx             ← [NEW] Resource
    │
    ├── FormDokter.vb               ← [NEW] CRUD Dokter (ref: FormDosen)
    ├── FormDokter.Designer.vb      ← [NEW] Designer
    ├── FormDokter.resx             ← [NEW] Resource
    │
    ├── FormObat.vb                 ← [NEW] CRUD Obat (ref: FormMataKuliah)
    ├── FormObat.Designer.vb        ← [NEW] Designer
    ├── FormObat.resx               ← [NEW] Resource
    │
    ├── FormRekamMedis.vb           ← [NEW] Proses Rekam Medis (ref: FormNilai)
    ├── FormRekamMedis.Designer.vb  ← [NEW] Designer
    ├── FormRekamMedis.resx         ← [NEW] Resource
    │
    ├── FormCariPasien.vb           ← [NEW] Lookup Pasien (ref: FormCariMhs)
    ├── FormCariPasien.Designer.vb  ← [NEW] Designer
    ├── FormCariPasien.resx         ← [NEW] Resource
    │
    ├── FormCariDokter.vb           ← [NEW] Lookup Dokter (ref: FormCariDosen)
    ├── FormCariDokter.Designer.vb  ← [NEW] Designer
    ├── FormCariDokter.resx         ← [NEW] Resource
    │
    ├── FormCariObat.vb             ← [NEW] Lookup Obat (ref: FormCariMtk)
    ├── FormCariObat.Designer.vb    ← [NEW] Designer
    ├── FormCariObat.resx           ← [NEW] Resource
    │
    ├── My Project/                 ← [MODIFY] Update Application.myapp & designer
    │   ├── Application.myapp
    │   ├── Application.Designer.vb
    │   ├── AssemblyInfo.vb
    │   ├── Resources.Designer.vb
    │   ├── Resources.resx
    │   ├── Settings.Designer.vb
    │   └── Settings.settings
    │
    ├── bin/                        ← Output folder (auto-generated)
    └── obj/                        ← Build folder (auto-generated)
```

> [!NOTE]
> File `Form1.vb` dan `Form1.Designer.vb` yang sudah ada akan **dihapus** karena digantikan oleh `F_MenuUtama`.

---

## Desain Tema Visual (Klinik Kesehatan)

Tema warna disesuaikan untuk **nuansa klinik/kesehatan** yang profesional:

| Elemen | Warna di AplNilaiMhs | Warna di SCMKlinikSyuhadda |
|---|---|---|
| Panel BackColor | `ControlDarkDark` (abu gelap) | `Color.FromArgb(0, 105, 92)` — **Teal gelap** (tema kesehatan) |
| Label ForeColor | `ButtonHighlight` (putih) | `Color.White` — tetap putih |
| Label Title Font | 14.25pt Bold | 14.25pt Bold — sama |
| Button BackColor | `ButtonHighlight` | `Color.FromArgb(224, 242, 241)` — **Teal muda** |
| Button ForeColor | `ControlText` (hitam) | `Color.FromArgb(0, 77, 64)` — **Teal tua** |
| ListView GridLines | True | True — sama |

> [!TIP]
> **Warna teal/hijau toska** adalah warna standar yang diasosiasikan dengan dunia medis dan kesehatan — memberikan kesan profesional dan terpercaya saat presentasi.

---

## Pola CRUD (Mengikuti AplNilaiMhs)

Setiap form CRUD mengikuti pola yang **identik** dengan referensi:

### Pola Fungsi Standar (per Form)
```
1. posisilist()         → Setup kolom ListView
2. Isilist()            → Load data dari MySQL ke ListView
3. caridataXxx()        → Pencarian data dengan LIKE
4. AmbilDataDariListView() → Klik ListView → isi TextBox
5. bersih()             → Kosongkan semua TextBox
6. btnSave_Click        → INSERT INTO (validasi → query → refresh)
7. btnEdit_Click        → UPDATE SET WHERE (validasi → query → refresh)
8. btnDelete_Click      → DELETE FROM WHERE (konfirmasi → query → refresh)
9. btnRefresh_Click     → bersih() + Isilist()
10. btnExit_Click       → Me.Close()
11. Form_Load           → koneksiKeDataBase() + posisilist() + Isilist()
```

### Pola Query (Identik dengan Referensi)
```vb
' SAVE (INSERT) — sama persis polanya dengan FormDosen.btnSave_Click
Query = "INSERT INTO tbldokter VALUES('" & txtKdDokter.Text & "','" & txtNamaDokter.Text & "',...)"
daData = New MySqlDataAdapter(Query, Conn)
dsData = New DataSet
daData.Fill(dsData)

' EDIT (UPDATE) — sama persis polanya
Query = "UPDATE tbldokter SET nama_dokter='" & txtNamaDokter.Text & "' WHERE kd_dokter='" & txtKdDokter.Text & "'"

' DELETE — sama persis polanya
Query = "DELETE FROM tbldokter WHERE kd_dokter='" & txtKdDokter.Text & "'"
```

---

## Fitur Khusus FormRekamMedis (≈ FormNilai)

Sama seperti `FormNilai` yang memiliki fungsi `prosesnilai()` untuk menghitung nilai, `FormRekamMedis` akan memiliki fungsi `prosesbiaya()`:

```
prosesbiaya():
  - Ambil harga obat dari txtHarga
  - Ambil jumlah obat dari txtJmlObat
  - total_biaya = harga × jml_obat
  - Tentukan status berdasarkan diagnosis:
    * Jika diagnosis ringan → "Rawat Jalan"
    * Jika diagnosis berat → "Dirujuk"
```

Ini **paralel** dengan `prosesnilai()` di referensi yang menghitung nilai huruf, bobot, dan keterangan.

---

## Data Sampel untuk Presentasi

### tblpasien (5 data)
| no_rm | nama_pasien | tmp_lahir | tgl_lahir | usia | jenkel | gol_darah | alamat | telp |
|---|---|---|---|---|---|---|---|---|
| RM001 | Ahmad Rizki | Medan | 1990-03-15 | 36 | Laki-Laki | A | Jl. Sudirman No.10 | 081234567801 |
| RM002 | Siti Aisyah | Binjai | 1985-07-22 | 41 | Perempuan | B | Jl. Gatot Subroto No.5 | 081234567802 |
| RM003 | Budi Hartono | Medan | 1978-11-08 | 48 | Laki-Laki | O | Jl. Imam Bonjol No.3 | 081234567803 |
| RM004 | Dewi Lestari | Tebing Tinggi | 1995-01-30 | 31 | Perempuan | AB | Jl. Diponegoro No.7 | 081234567804 |
| RM005 | Rudi Saputra | Medan | 2000-09-12 | 26 | Laki-Laki | A | Jl. Pemuda No.15 | 081234567805 |

### tbldokter (5 data)
| kd_dokter | nama_dokter | spesialis | telp |
|---|---|---|---|
| DK001 | dr. Hasan Basri, Sp.PD | Penyakit Dalam | 081345678901 |
| DK002 | dr. Fatimah Zahra, Sp.A | Anak | 081345678902 |
| DK003 | dr. Andi Prasetyo | Umum | 081345678903 |
| DK004 | dr. Rina Sari, Sp.OG | Kandungan | 081345678904 |
| DK005 | dr. Budi Santoso, Sp.B | Bedah | 081345678905 |

### tblobat (5 data)
| kd_obat | nama_obat | harga |
|---|---|---|
| OB001 | Paracetamol 500mg | 5000 |
| OB002 | Amoxicillin 500mg | 8000 |
| OB003 | Omeprazole 20mg | 12000 |
| OB004 | Antangin Cair | 3000 |
| OB005 | Ibuprofen 400mg | 7000 |

---

## Open Questions

> [!IMPORTANT]
> **1. Form Login:** Apakah perlu ditambahkan Form Login (username/password) sebelum masuk ke Menu Utama? Project referensi `AplNilaiMhs` tidak memilikinya, tapi ini bisa jadi **nilai tambah** saat presentasi.

> [!IMPORTANT]
> **2. Laporan/Report:** Project referensi memiliki Crystal Reports (`LHSMhs.rpt`) untuk Lembar Hasil Studi. Apakah ingin saya buatkan juga form laporan sederhana (misalnya laporan rekam medis pasien), atau cukup CRUD saja?

> [!IMPORTANT]
> **3. Warna Tema:** Saya rekomendasikan **teal/hijau toska** untuk nuansa kesehatan. Apakah ada preferensi warna lain yang diinginkan?

---

## Urutan Eksekusi

1. **Database** → `db_klinik_syuhadda.sql`
2. **Module Koneksi** → `BukaKoneksi.vb`
3. **App.config** → Update konfigurasi
4. **Form Master** → `FormPasien`, `FormDokter`, `FormObat` (masing-masing .vb + .Designer.vb + .resx)
5. **Form Lookup** → `FormCariPasien`, `FormCariDokter`, `FormCariObat`
6. **Form Transaksi** → `FormRekamMedis`
7. **Menu Utama** → `F_MenuUtama`
8. **My Project** → Update `Application.myapp`, `Application.Designer.vb`, `AssemblyInfo.vb`
9. **Project File** → Update `SCMKlinikSyuhadda.vbproj`
10. **Cleanup** → Hapus `Form1.vb` dan `Form1.Designer.vb`

---

## Verification Plan

### Manual Verification
1. Buka project di Visual Studio → pastikan tidak ada error compile
2. Jalankan XAMPP → import `db_klinik_syuhadda.sql` ke phpMyAdmin
3. Run project → test CRUD di setiap form
4. Verifikasi semua tombol (Save, Edit, Delete, Refresh, Exit, Cari Data)
5. Verifikasi form lookup mengisi data ke FormRekamMedis

---

## Tips Presentasi ke Dosen

1. **Jelaskan konsep SCM** → rantai pasokan layanan kesehatan (obat masuk → stok → pelayanan → rekam medis)
2. **Jelaskan Model WaterFall** → Requirements → Design → Implementation → Testing → Maintenance
3. **Tunjukkan pola CRUD** → sama dengan project latihan, hanya konteks yang berbeda
4. **Demo live** → Tambah pasien → Tambah dokter → Tambah obat → Buat rekam medis → Edit → Delete
5. **Jelaskan koneksi database** → Module `BukaKoneksi` menggunakan `MySql.Data.MySqlClient`
