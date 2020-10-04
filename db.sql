-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `jualan`;
CREATE DATABASE `jualan` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `jualan`;

DROP TABLE IF EXISTS `tdata_barang`;
CREATE TABLE `tdata_barang` (
  `kode_barang` int(11) NOT NULL AUTO_INCREMENT,
  `nama_barang` varchar(150) NOT NULL,
  `harga_beli` int(10) unsigned zerofill NOT NULL DEFAULT 0000000000,
  `harga_jual` int(10) unsigned zerofill NOT NULL DEFAULT 0000000000,
  `tanggal_update` datetime DEFAULT NULL,
  `update_by` int(10) unsigned zerofill NOT NULL DEFAULT 0000000000,
  PRIMARY KEY (`kode_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

INSERT INTO `tdata_barang` (`kode_barang`, `nama_barang`, `harga_beli`, `harga_jual`, `tanggal_update`, `update_by`) VALUES
(1,	'Semen Tiga Roda',	0000040000,	0000050000,	'2020-06-29 11:51:11',	0000000001),
(2,	'Cat No Drop',	0000025000,	0000030000,	'2020-06-28 12:39:46',	0000000001),
(3,	'Cat Biasa',	0000030000,	0000050000,	'2020-06-28 02:12:36',	0000000001),
(4,	'Test',	0000001000,	0000005000,	'2020-07-01 04:15:19',	0000000002),
(5,	'Paralon Wafin 2.5',	0000010000,	0000025000,	NULL,	0000000000),
(6,	'Kabel ',	0000030000,	0000040000,	NULL,	0000000000);

DROP TABLE IF EXISTS `tkode_transaksi`;
CREATE TABLE `tkode_transaksi` (
  `kode_transaksi` smallint(6) NOT NULL,
  `nama_transaksi` varchar(50) NOT NULL,
  `xfaktor` smallint(6) NOT NULL DEFAULT 1,
  PRIMARY KEY (`kode_transaksi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `tkode_transaksi` (`kode_transaksi`, `nama_transaksi`, `xfaktor`) VALUES
(1,	'Pembelian',	1),
(2,	'Penjualan',	-1),
(3,	'Akurasi',	1);

DROP TABLE IF EXISTS `tpelanggan`;
CREATE TABLE `tpelanggan` (
  `kode_pelanggan` int(11) NOT NULL AUTO_INCREMENT,
  `nama_pelanggan` varchar(50) NOT NULL,
  `alamat` varchar(250) NOT NULL,
  `telp` varchar(15) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  PRIMARY KEY (`kode_pelanggan`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

INSERT INTO `tpelanggan` (`kode_pelanggan`, `nama_pelanggan`, `alamat`, `telp`, `update_date`, `update_by`) VALUES
(1,	'Umum',	'Karawang',	'000000000000',	'2020-07-01 04:02:15',	2),
(4,	'Yanto',	'Karawang Timur',	'08888888888',	'2020-07-01 04:13:11',	2),
(5,	'Andi',	'Karawang Barat',	'081200000001',	'2020-07-01 04:14:00',	2);

DROP TABLE IF EXISTS `trole`;
CREATE TABLE `trole` (
  `role` varchar(50) NOT NULL,
  PRIMARY KEY (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `trole` (`role`) VALUES
('admin'),
('pengelola'),
('pimpinan');

DROP TABLE IF EXISTS `tsupplier`;
CREATE TABLE `tsupplier` (
  `kode_supplier` int(11) NOT NULL AUTO_INCREMENT,
  `nama_supplier` varchar(50) NOT NULL,
  `alamat` varchar(250) NOT NULL,
  `telp` varchar(15) NOT NULL,
  `update_date` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  PRIMARY KEY (`kode_supplier`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

INSERT INTO `tsupplier` (`kode_supplier`, `nama_supplier`, `alamat`, `telp`, `update_date`, `update_by`) VALUES
(3,	'PT Maju Bersama',	'Karawang Barat',	'02222222222',	'2020-07-01 04:15:39',	2);

DROP TABLE IF EXISTS `ttransaksi_detail`;
CREATE TABLE `ttransaksi_detail` (
  `id` bigint(20) NOT NULL,
  `kode_barang` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 0,
  `harga` bigint(20) NOT NULL DEFAULT 0,
  `harga_beli` bigint(20) NOT NULL DEFAULT 0,
  KEY `id` (`id`),
  KEY `kode_barang` (`kode_barang`),
  CONSTRAINT `ttransaksi_detail_ibfk_1` FOREIGN KEY (`id`) REFERENCES `ttransaksi_header` (`id`),
  CONSTRAINT `ttransaksi_detail_ibfk_2` FOREIGN KEY (`kode_barang`) REFERENCES `tdata_barang` (`kode_barang`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ttransaksi_detail` (`id`, `kode_barang`, `jumlah`, `harga`, `harga_beli`) VALUES
(1,	1,	5,	50000,	40000),
(1,	2,	2,	30000,	25000),
(5,	2,	1,	12000,	25000),
(5,	1,	2,	50000,	40000),
(4,	1,	1,	50000,	40000),
(4,	2,	1,	30000,	25000),
(6,	1,	5,	70000,	40000),
(6,	2,	100,	35000,	25000),
(7,	3,	3,	50000,	30000),
(9,	1,	3,	50000,	40000),
(8,	1,	1,	50000,	40000),
(10,	1,	70,	70000,	40000),
(11,	1,	5,	50000,	40000),
(12,	1,	123,	200000,	40000),
(21,	1,	1,	50000,	40000);

DROP TABLE IF EXISTS `ttransaksi_header`;
CREATE TABLE `ttransaksi_header` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_transaksi` smallint(6) NOT NULL,
  `kode_pelanggan` int(11) DEFAULT NULL,
  `kode_supplier` int(11) DEFAULT NULL,
  `tanggal_posting` date NOT NULL,
  `tanggal_update` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  `diskon` smallint(6) NOT NULL DEFAULT 0,
  `dibayarkan` bigint(20) NOT NULL DEFAULT 0,
  `status_transaksi` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `kode_pelanggan` (`kode_pelanggan`),
  KEY `kode_supplier` (`kode_supplier`),
  CONSTRAINT `ttransaksi_header_ibfk_1` FOREIGN KEY (`kode_pelanggan`) REFERENCES `tpelanggan` (`kode_pelanggan`) ON DELETE CASCADE,
  CONSTRAINT `ttransaksi_header_ibfk_2` FOREIGN KEY (`kode_supplier`) REFERENCES `tsupplier` (`kode_supplier`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

INSERT INTO `ttransaksi_header` (`id`, `kode_transaksi`, `kode_pelanggan`, `kode_supplier`, `tanggal_posting`, `tanggal_update`, `update_by`, `diskon`, `dibayarkan`, `status_transaksi`) VALUES
(1,	1,	NULL,	3,	'2020-03-16',	'2020-03-16 23:13:10',	1,	0,	0,	0),
(4,	2,	4,	NULL,	'2020-04-03',	'2020-04-04 02:45:49',	1,	1,	500000,	1),
(5,	2,	4,	NULL,	'2020-04-12',	'2020-04-12 11:26:26',	1,	1,	120000,	1),
(6,	1,	NULL,	3,	'2020-06-28',	'2020-06-28 11:37:06',	1,	0,	0,	0),
(7,	1,	NULL,	3,	'2020-06-28',	'2020-06-28 02:11:54',	1,	0,	0,	0),
(8,	2,	1,	NULL,	'2020-06-28',	'2020-06-28 02:45:03',	1,	0,	50000,	1),
(9,	2,	1,	NULL,	'2020-06-28',	'2020-06-28 02:49:00',	1,	0,	150000,	1),
(10,	1,	NULL,	3,	'2020-06-29',	'2020-06-29 11:50:49',	1,	0,	0,	0),
(11,	2,	1,	NULL,	'2020-06-29',	'2020-06-29 11:51:52',	1,	1,	250000,	1),
(12,	1,	NULL,	3,	'2020-07-01',	'2020-07-01 11:33:51',	2,	0,	0,	0),
(13,	2,	1,	NULL,	'2020-08-08',	'2020-08-08 05:16:28',	2,	0,	0,	0),
(14,	2,	1,	NULL,	'2020-08-07',	'2020-08-08 05:16:41',	2,	0,	0,	0),
(15,	2,	1,	NULL,	'2020-08-07',	'2020-08-08 05:17:38',	2,	0,	0,	0),
(16,	2,	1,	NULL,	'2020-08-08',	'2020-08-08 05:18:33',	2,	0,	0,	0),
(17,	2,	1,	NULL,	'2020-08-07',	'2020-08-08 05:18:43',	2,	0,	0,	0),
(18,	2,	1,	NULL,	'2020-08-01',	'2020-08-08 05:19:40',	2,	0,	0,	0),
(19,	2,	1,	NULL,	'2020-08-08',	'2020-08-08 05:22:19',	2,	0,	0,	0),
(20,	1,	NULL,	3,	'2020-08-22',	'2020-08-22 10:18:41',	2,	0,	0,	0),
(21,	2,	1,	NULL,	'2020-08-22',	'2020-08-22 10:18:50',	2,	0,	0,	0);

DROP TABLE IF EXISTS `tuser`;
CREATE TABLE `tuser` (
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`username`),
  UNIQUE KEY `id` (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

INSERT INTO `tuser` (`username`, `password`, `role`, `nama`, `userid`) VALUES
('pengelola',	'202cb962ac59075b964b07152d234b70',	'pengelola',	'pengelola',	3),
('pimpinan',	'21232f297a57a5a743894a0e4a801fc3',	'pimpinan',	'Pimpinan Toko',	1),
('yoseph',	'202cb962ac59075b964b07152d234b70',	'admin',	'Yoseph',	2);

DROP VIEW IF EXISTS `vpembelian_detail`;
CREATE TABLE `vpembelian_detail` (`id` bigint(20), `kode_transaksi` smallint(6), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11), `nama_supplier` varchar(50), `kode_barang` int(11), `nama_barang` varchar(150), `jumlah` int(11), `harga` bigint(20), `jumlah_harga` bigint(30));


DROP VIEW IF EXISTS `vpembelian_header`;
CREATE TABLE `vpembelian_header` (`id` bigint(20), `kode_supplier` int(11), `nama_supplier` varchar(50), `alamat` varchar(250), `telp` varchar(15), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11));


DROP VIEW IF EXISTS `vpenjualan_detail`;
CREATE TABLE `vpenjualan_detail` (`id` bigint(20), `kode_transaksi` smallint(6), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11), `nama_pelanggan` varchar(50), `alamat` varchar(250), `telp` varchar(15), `kode_barang` int(11), `nama_barang` varchar(150), `jumlah` int(11), `harga` bigint(20), `jumlah_harga` bigint(30), `jumlah_beli` bigint(30), `jumlah_laba` bigint(31), `diskon` smallint(6), `dibayarkan` bigint(20), `status_transaksi` smallint(6));


DROP VIEW IF EXISTS `vpenjualan_header`;
CREATE TABLE `vpenjualan_header` (`id` bigint(20), `kode_pelanggan` int(11), `nama_pelanggan` varchar(50), `alamat` varchar(250), `telp` varchar(15), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11));


DROP VIEW IF EXISTS `vstok`;
CREATE TABLE `vstok` (`kode_barang` int(11), `nama_barang` varchar(150), `stok` decimal(37,0), `harga_jual` int(10) unsigned zerofill, `harga_beli` int(10) unsigned zerofill);


DROP VIEW IF EXISTS `vtransaksi`;
CREATE TABLE `vtransaksi` (`id` bigint(20), `kode_transaksi` smallint(6), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11), `kode_barang` int(11), `nama_barang` varchar(150), `jumlah` int(11), `harga` bigint(20), `jumlahharga` bigint(30));


DROP VIEW IF EXISTS `vtransaksi_penjualan`;
CREATE TABLE `vtransaksi_penjualan` (`id` bigint(20), `kode_transaksi` smallint(6), `tanggal_posting` date, `tanggal_update` datetime, `update_by` int(11), `kode_barang` int(11), `nama_barang` varchar(150), `jumlah` int(11), `harga` bigint(20), `jumlahharga` bigint(30));


DROP TABLE IF EXISTS `vpembelian_detail`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpembelian_detail` AS select `a`.`id` AS `id`,`a`.`kode_transaksi` AS `kode_transaksi`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by`,`a`.`nama_supplier` AS `nama_supplier`,`b`.`kode_barang` AS `kode_barang`,`c`.`nama_barang` AS `nama_barang`,`b`.`jumlah` AS `jumlah`,`b`.`harga` AS `harga`,`b`.`jumlah` * `b`.`harga` AS `jumlah_harga` from ((((select `jualan`.`ttransaksi_header`.`id` AS `id`,`jualan`.`ttransaksi_header`.`kode_transaksi` AS `kode_transaksi`,`jualan`.`ttransaksi_header`.`tanggal_posting` AS `tanggal_posting`,`jualan`.`ttransaksi_header`.`tanggal_update` AS `tanggal_update`,`jualan`.`ttransaksi_header`.`update_by` AS `update_by`,`jualan`.`tsupplier`.`nama_supplier` AS `nama_supplier` from (`jualan`.`ttransaksi_header` join `jualan`.`tsupplier` on(`jualan`.`ttransaksi_header`.`kode_supplier` = `jualan`.`tsupplier`.`kode_supplier`)) where `jualan`.`ttransaksi_header`.`kode_transaksi` = 1)) `a` join `jualan`.`ttransaksi_detail` `b` on(`a`.`id` = `b`.`id`)) join `jualan`.`tdata_barang` `c` on(`b`.`kode_barang` = `c`.`kode_barang`));

DROP TABLE IF EXISTS `vpembelian_header`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpembelian_header` AS select `a`.`id` AS `id`,`a`.`kode_supplier` AS `kode_supplier`,`b`.`nama_supplier` AS `nama_supplier`,`b`.`alamat` AS `alamat`,`b`.`telp` AS `telp`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by` from (`ttransaksi_header` `a` join `tsupplier` `b` on(`a`.`kode_supplier` = `b`.`kode_supplier`));

DROP TABLE IF EXISTS `vpenjualan_detail`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpenjualan_detail` AS select `a`.`id` AS `id`,`a`.`kode_transaksi` AS `kode_transaksi`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by`,`a`.`nama_pelanggan` AS `nama_pelanggan`,`a`.`alamat` AS `alamat`,`a`.`telp` AS `telp`,`b`.`kode_barang` AS `kode_barang`,`c`.`nama_barang` AS `nama_barang`,`b`.`jumlah` AS `jumlah`,`b`.`harga` AS `harga`,`b`.`jumlah` * `b`.`harga` AS `jumlah_harga`,`b`.`jumlah` * `b`.`harga_beli` AS `jumlah_beli`,`b`.`jumlah` * (`b`.`harga` - `b`.`harga_beli`) AS `jumlah_laba`,`a`.`diskon` AS `diskon`,`a`.`dibayarkan` AS `dibayarkan`,`a`.`status_transaksi` AS `status_transaksi` from ((((select `jualan`.`ttransaksi_header`.`id` AS `id`,`jualan`.`ttransaksi_header`.`kode_transaksi` AS `kode_transaksi`,`jualan`.`ttransaksi_header`.`tanggal_posting` AS `tanggal_posting`,`jualan`.`ttransaksi_header`.`tanggal_update` AS `tanggal_update`,`jualan`.`ttransaksi_header`.`update_by` AS `update_by`,`jualan`.`tpelanggan`.`nama_pelanggan` AS `nama_pelanggan`,`jualan`.`tpelanggan`.`alamat` AS `alamat`,`jualan`.`tpelanggan`.`telp` AS `telp`,`jualan`.`ttransaksi_header`.`diskon` AS `diskon`,`jualan`.`ttransaksi_header`.`dibayarkan` AS `dibayarkan`,`jualan`.`ttransaksi_header`.`status_transaksi` AS `status_transaksi` from (`jualan`.`ttransaksi_header` join `jualan`.`tpelanggan` on(`jualan`.`ttransaksi_header`.`kode_pelanggan` = `jualan`.`tpelanggan`.`kode_pelanggan`)) where `jualan`.`ttransaksi_header`.`kode_transaksi` = 2)) `a` join `jualan`.`ttransaksi_detail` `b` on(`a`.`id` = `b`.`id`)) join `jualan`.`tdata_barang` `c` on(`b`.`kode_barang` = `c`.`kode_barang`));

DROP TABLE IF EXISTS `vpenjualan_header`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vpenjualan_header` AS select `a`.`id` AS `id`,`a`.`kode_pelanggan` AS `kode_pelanggan`,`b`.`nama_pelanggan` AS `nama_pelanggan`,`b`.`alamat` AS `alamat`,`b`.`telp` AS `telp`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by` from (`ttransaksi_header` `a` join `tpelanggan` `b` on(`a`.`kode_pelanggan` = `b`.`kode_pelanggan`));

DROP TABLE IF EXISTS `vstok`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vstok` AS select `a`.`kode_barang` AS `kode_barang`,`a`.`nama_barang` AS `nama_barang`,ifnull(`b`.`stok`,0) AS `stok`,`a`.`harga_jual` AS `harga_jual`,`a`.`harga_beli` AS `harga_beli` from (`jualan`.`tdata_barang` `a` left join (select `a`.`kode_barang` AS `kode_barang`,sum(`a`.`jumlah` * `c`.`xfaktor`) AS `stok` from ((`jualan`.`ttransaksi_detail` `a` join `jualan`.`ttransaksi_header` `b` on(`a`.`id` = `b`.`id`)) join `jualan`.`tkode_transaksi` `c` on(`b`.`kode_transaksi` = `c`.`kode_transaksi`)) group by `a`.`kode_barang`) `b` on(`a`.`kode_barang` = `b`.`kode_barang`));

DROP TABLE IF EXISTS `vtransaksi`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vtransaksi` AS select `a`.`id` AS `id`,`a`.`kode_transaksi` AS `kode_transaksi`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by`,`b`.`kode_barang` AS `kode_barang`,`c`.`nama_barang` AS `nama_barang`,`b`.`jumlah` AS `jumlah`,`b`.`harga` AS `harga`,`b`.`jumlah` * `b`.`harga` AS `jumlahharga` from ((`ttransaksi_header` `a` join `ttransaksi_detail` `b` on(`a`.`id` = `b`.`id`)) join `tdata_barang` `c` on(`b`.`kode_barang` = `c`.`kode_barang`));

DROP TABLE IF EXISTS `vtransaksi_penjualan`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vtransaksi_penjualan` AS select `a`.`id` AS `id`,`a`.`kode_transaksi` AS `kode_transaksi`,`a`.`tanggal_posting` AS `tanggal_posting`,`a`.`tanggal_update` AS `tanggal_update`,`a`.`update_by` AS `update_by`,`b`.`kode_barang` AS `kode_barang`,`c`.`nama_barang` AS `nama_barang`,`b`.`jumlah` AS `jumlah`,`b`.`harga` AS `harga`,`b`.`jumlah` * `b`.`harga` AS `jumlahharga` from ((((select `jualan`.`ttransaksi_header`.`id` AS `id`,`jualan`.`ttransaksi_header`.`kode_transaksi` AS `kode_transaksi`,`jualan`.`ttransaksi_header`.`tanggal_posting` AS `tanggal_posting`,`jualan`.`ttransaksi_header`.`tanggal_update` AS `tanggal_update`,`jualan`.`ttransaksi_header`.`update_by` AS `update_by` from `jualan`.`ttransaksi_header` where `jualan`.`ttransaksi_header`.`kode_transaksi` = 2)) `a` join `jualan`.`ttransaksi_detail` `b` on(`a`.`id` = `b`.`id`)) join `jualan`.`tdata_barang` `c` on(`b`.`kode_barang` = `c`.`kode_barang`));

-- 2020-10-04 16:21:42
