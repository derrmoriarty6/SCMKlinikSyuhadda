-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2026 at 04:06 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.0.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_apotek_maju`
--
CREATE DATABASE IF NOT EXISTS `db_apotek_maju` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_apotek_maju`;

-- --------------------------------------------------------

--
-- Stand-in structure for view `querypenjualan`
--
CREATE TABLE `querypenjualan` (
`id_penjualan` int(11)
,`tgl_jual` date
,`kd_obat` varchar(10)
,`nm_obat` varchar(50)
,`satuan` varchar(20)
,`kd_kategori` varchar(10)
,`nm_kategori` varchar(30)
,`kd_supplier` varchar(10)
,`nm_supplier` varchar(50)
,`jumlah` int(11)
,`harga_satuan` double
,`total_harga` double
,`nama_pembeli` varchar(50)
,`keterangan` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `tblkategori`
--

CREATE TABLE `tblkategori` (
  `kd_kategori` varchar(10) NOT NULL,
  `nm_kategori` varchar(30) NOT NULL,
  `keterangan` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tblkategori`
--

INSERT INTO `tblkategori` (`kd_kategori`, `nm_kategori`, `keterangan`) VALUES
('KTG01', 'Obat Bebas', 'Dapat dibeli tanpa resep dokter'),
('KTG02', 'Obat Bebas Terbatas', 'Perlu resep dokter untuk jumlah tertentu'),
('KTG03', 'Obat Keras', 'Wajib resep dokter'),
('KTG04', 'Vitamin dan Suplemen', 'Untuk menjaga kesehatan tubuh'),
('KTG05', 'Herbal', 'Obat tradisional alami');

-- --------------------------------------------------------

--
-- Table structure for table `tblobat`
--

CREATE TABLE `tblobat` (
  `kd_obat` varchar(10) NOT NULL,
  `nm_obat` varchar(50) NOT NULL,
  `kd_kategori` varchar(10) NOT NULL,
  `kd_supplier` varchar(10) NOT NULL,
  `satuan` varchar(20) NOT NULL,
  `harga` double NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tblobat`
--

INSERT INTO `tblobat` (`kd_obat`, `nm_obat`, `kd_kategori`, `kd_supplier`, `satuan`, `harga`, `stok`) VALUES
('OBT001', 'Paracetamol 500mg', 'KTG01', 'SUP001', 'Strip', 5000, 100),
('OBT002', 'Amoxicillin 500mg', 'KTG03', 'SUP002', 'Strip', 15000, 50),
('OBT003', 'Vitamin C 1000mg', 'KTG04', 'SUP003', 'Botol', 35000, 20),
('OBT004', 'Tolak Angin Cair', 'KTG05', 'SUP004', 'Sachet', 3000, 200),
('OBT005', 'Bodrex Extra', 'KTG01', 'SUP001', 'Strip', 8000, 75);

-- --------------------------------------------------------

--
-- Table structure for table `tblpenjualan`
--

CREATE TABLE `tblpenjualan` (
  `id_penjualan` int(11) NOT NULL,
  `tgl_jual` date NOT NULL,
  `kd_obat` varchar(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_satuan` double NOT NULL,
  `total_harga` double NOT NULL,
  `nama_pembeli` varchar(50) NOT NULL,
  `keterangan` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tblpenjualan`
--

INSERT INTO `tblpenjualan` (`id_penjualan`, `tgl_jual`, `kd_obat`, `jumlah`, `harga_satuan`, `total_harga`, `nama_pembeli`, `keterangan`) VALUES
(1, '2026-05-25', 'OBT001', 2, 5000, 10000, 'Budi', 'Lunas'),
(2, '2026-05-25', 'OBT003', 1, 35000, 35000, 'Siti', 'Lunas'),
(3, '2026-05-26', 'OBT004', 5, 3000, 15000, 'Joko', 'Hutang');

-- --------------------------------------------------------

--
-- Table structure for table `tblsupplier`
--

CREATE TABLE `tblsupplier` (
  `kd_supplier` varchar(10) NOT NULL,
  `nm_supplier` varchar(50) NOT NULL,
  `alamat` varchar(100) NOT NULL,
  `telp` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tblsupplier`
--

INSERT INTO `tblsupplier` (`kd_supplier`, `nm_supplier`, `alamat`, `telp`) VALUES
('SUP001', 'PT Kimia Farma', 'Jl. Veteran No 1, Jakarta', '0211234567'),
('SUP002', 'PT Kalbe Farma', 'Letjen Suprapto Cempaka Putih', '0219876543'),
('SUP003', 'PT Sanbe Farma', 'Jl. Industri Cimahi', '022123456'),
('SUP004', 'PT Sido Muncul', 'Jl. Arteri Soekarno Hatta Semarang', '024987654');

-- --------------------------------------------------------

--
-- Structure for view `querypenjualan`
--
DROP TABLE IF EXISTS `querypenjualan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `querypenjualan`  AS  
SELECT 
    `p`.`id_penjualan` AS `id_penjualan`,
    `p`.`tgl_jual` AS `tgl_jual`,
    `o`.`kd_obat` AS `kd_obat`,
    `o`.`nm_obat` AS `nm_obat`,
    `o`.`satuan` AS `satuan`,
    `k`.`kd_kategori` AS `kd_kategori`,
    `k`.`nm_kategori` AS `nm_kategori`,
    `s`.`kd_supplier` AS `kd_supplier`,
    `s`.`nm_supplier` AS `nm_supplier`,
    `p`.`jumlah` AS `jumlah`,
    `p`.`harga_satuan` AS `harga_satuan`,
    `p`.`total_harga` AS `total_harga`,
    `p`.`nama_pembeli` AS `nama_pembeli`,
    `p`.`keterangan` AS `keterangan`
FROM (((`tblpenjualan` `p` 
JOIN `tblobat` `o` ON((`p`.`kd_obat` = `o`.`kd_obat`))) 
JOIN `tblkategori` `k` ON((`o`.`kd_kategori` = `k`.`kd_kategori`))) 
JOIN `tblsupplier` `s` ON((`o`.`kd_supplier` = `s`.`kd_supplier`)));

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tblkategori`
--
ALTER TABLE `tblkategori`
  ADD PRIMARY KEY (`kd_kategori`);

--
-- Indexes for table `tblobat`
--
ALTER TABLE `tblobat`
  ADD PRIMARY KEY (`kd_obat`),
  ADD KEY `kd_kategori` (`kd_kategori`),
  ADD KEY `kd_supplier` (`kd_supplier`);

--
-- Indexes for table `tblpenjualan`
--
ALTER TABLE `tblpenjualan`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD KEY `kd_obat` (`kd_obat`);

--
-- Indexes for table `tblsupplier`
--
ALTER TABLE `tblsupplier`
  ADD PRIMARY KEY (`kd_supplier`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tblpenjualan`
--
ALTER TABLE `tblpenjualan`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tblobat`
--
ALTER TABLE `tblobat`
  ADD CONSTRAINT `tblobat_ibfk_1` FOREIGN KEY (`kd_kategori`) REFERENCES `tblkategori` (`kd_kategori`),
  ADD CONSTRAINT `tblobat_ibfk_2` FOREIGN KEY (`kd_supplier`) REFERENCES `tblsupplier` (`kd_supplier`);

--
-- Constraints for table `tblpenjualan`
--
ALTER TABLE `tblpenjualan`
  ADD CONSTRAINT `tblpenjualan_ibfk_1` FOREIGN KEY (`kd_obat`) REFERENCES `tblobat` (`kd_obat`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
