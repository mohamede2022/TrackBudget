/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: trackbudget_db
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `vendor_name` varchar(100) DEFAULT NULL,
  `money_spent` decimal(10,2) DEFAULT NULL,
  `date_of_transaction` date DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `transactions` VALUES
(1,1,'Starbucks',6.50,'2026-03-01','Food & Drink'),
(2,5,'Amazon',45.99,'2026-03-01','Shopping'),
(3,12,'Apple Store',129.00,'2026-03-02','Electronics'),
(4,2,'Shell Gas',35.00,'2026-03-02','Transport'),
(5,45,'Netflix',15.99,'2026-03-02','Entertainment'),
(6,8,'Whole Foods',82.30,'2026-03-03','Groceries'),
(7,20,'Uber',12.50,'2026-03-03','Transport'),
(8,33,'Chipotle',14.25,'2026-03-03','Food & Drink'),
(9,15,'Target',22.15,'2026-03-04','Shopping'),
(10,58,'Nike',110.00,'2026-03-04','Shopping'),
(11,10,'Starbucks',5.75,'2026-03-04','Food & Drink'),
(12,4,'Spotify',10.99,'2026-03-05','Entertainment'),
(13,50,'AMC Theater',18.00,'2026-03-05','Entertainment'),
(14,25,'Walmart',56.40,'2026-03-05','Groceries'),
(15,60,'Planet Fitness',25.00,'2026-03-05','Health'),
(16,21,'Walmart',45.10,'2026-03-05','Groceries'),
(17,22,'Shell Gas',42.00,'2026-03-05','Transport'),
(18,23,'Chick-fil-A',15.20,'2026-03-05','Food & Drink'),
(19,24,'Amazon',12.99,'2026-03-05','Shopping'),
(20,25,'Netflix',15.99,'2026-03-05','Entertainment'),
(21,26,'Starbucks',5.45,'2026-03-05','Food & Drink'),
(22,27,'Uber',18.50,'2026-03-05','Transport'),
(23,28,'Target',34.20,'2026-03-05','Shopping'),
(24,29,'Chipotle',12.50,'2026-03-05','Food & Drink'),
(25,30,'Apple Music',10.99,'2026-03-05','Entertainment'),
(26,31,'Dunkin Donuts',4.50,'2026-03-05','Food & Drink'),
(27,32,'Chevron',50.00,'2026-03-05','Transport'),
(28,33,'Steam Games',59.99,'2026-03-05','Entertainment'),
(29,34,'Walgreens',22.15,'2026-03-05','Health'),
(30,35,'McDonalds',9.80,'2026-03-05','Food & Drink'),
(31,36,'H&M',45.00,'2026-03-05','Shopping'),
(32,37,'CVS Pharmacy',15.30,'2026-03-05','Health'),
(33,38,'Lyft',22.00,'2026-03-05','Transport'),
(34,39,'Taco Bell',11.25,'2026-03-05','Food & Drink'),
(35,40,'Best Buy',89.99,'2026-03-05','Electronics'),
(36,41,'Spotify',10.99,'2026-03-05','Entertainment'),
(37,42,'Whole Foods',65.40,'2026-03-05','Groceries'),
(38,43,'Subway',13.00,'2026-03-05','Food & Drink'),
(39,44,'7-Eleven',8.50,'2026-03-05','Shopping'),
(40,46,'AMC Theater',25.00,'2026-03-05','Entertainment'),
(41,47,'Adidas',75.00,'2026-03-05','Shopping'),
(42,48,'Starbucks',6.25,'2026-03-05','Food & Drink'),
(43,49,'Uber Eats',32.10,'2026-03-05','Food & Drink'),
(44,51,'Home Depot',120.00,'2026-03-05','Shopping'),
(45,52,'Petco',45.99,'2026-03-05','Other');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_name` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'rhellis0','rhellis0@virginia.edu','dc3514a5b6408eeb4bbb13dc43a3188789c84d27045cdc1ceb05301f59d71537','2026-03-05 20:51:09','Hellis','Roanna'),
(2,'vbollen1','vbollen1@comcast.net','6347ebe14e47df83fb42ebc3b350a4e45b3f682b97372fd03d68d605c2377e53','2026-03-05 21:01:34','Bollen','Veronique'),
(3,'kvreede2','kvreede2@walmart.com','3a910cf9456dacd26f84c40c2dfa40bcb3e9dab0953a267957e8758cdf018880','2026-03-05 21:01:34','Vreede','Kellina'),
(4,'aalgie3','aalgie3@opensource.org','6a49efc57460d046c8709e270aba66cfe20b47447520ac6f5d10400200e76f28','2026-03-05 21:01:34','Algie','Aldis'),
(5,'ntorn4','ntorn4@mozilla.org','b96d04d68bb4409d47939dd53b30891102254b9790ff6c3e77212eba8a46ffea','2026-03-05 21:01:34','Torn','Nancee'),
(6,'eswales5','eswales5@liveinternet.ru','ea3eb007615b132d6f87f4f8940a2508b1c8e115e820b793d1801a7df8faf6b6','2026-03-05 21:01:34','Swales','Essa'),
(7,'iradenhurst6','iradenhurst6@si.edu','4a62bbfc8e48ac1ba549a827ce7990fdcb73bd1d8f5e12aafbd6f22a1a61a324','2026-03-05 21:01:34','Radenhurst','Idelle'),
(8,'gcurtoys7','gcurtoys7@harvard.edu','83a418e48572caff7627d9df6fb3bc3dcb47bf7044f19e3ff91e51c9c1b422fe','2026-03-05 21:01:34','Curtoys','Garvey'),
(9,'htammadge8','htammadge8@cnn.com','e21c126de01b0fbbc06d538915c0378d6f7abb44a2f74c30b11fe5b6ee661e9f','2026-03-05 21:01:34','Tammadge','Harley'),
(10,'bodocherty9','bodocherty9@archive.org','3767561da37cafa370c0229eece8406095728703a3a857ce5bf944b3f3b1ad3a','2026-03-05 21:01:34','O\'Docherty','Babs'),
(11,'pbarra','pbarra@com.com','a23ae60de0ead638e99d1b5166dd2c6bf836be0b7d10fb2578b546f15ece6a4e','2026-03-05 21:01:34','Barr','Pearce'),
(12,'awarltonb','awarltonb@ft.com','503a01da86f30f6819ee9a15095bdfb19385604a4fc587cc8acf8069527f391a','2026-03-05 21:01:34','Warlton','Axe'),
(13,'edinsdalec','edinsdalec@youtube.com','4aacd66809adcbd82b3242d8c76ff1608a398e5dc58f0d60f7035b515536aef3','2026-03-05 21:01:34','Dinsdale','Elonore'),
(14,'kshrimptond','kshrimptond@printfriendly.com','9448ae940935f0f0c7c5943f0bd53333a8c8756c4119085586d1386a030d79c8','2026-03-05 21:01:34','Shrimpton','Kimmy'),
(15,'rcushellye','rcushellye@craigslist.org','06c9208f160b45b33a524c5a07131ca51b1824dbf049c9d761b06ce34078bdaf','2026-03-05 21:01:34','Cushelly','Rudie'),
(16,'mairyf','mairyf@senate.gov','3919b53f5bc422f2e0afe50d6f7720e939fccfa964fc3b877566174d4a7ea3f6','2026-03-05 21:01:34','Airy','Marita'),
(17,'hculleng','hculleng@mozilla.org','272df8f3fb0f785430848f9ffa181a0094c4bc3ca26303418e78663f5d9d9e22','2026-03-05 21:01:34','Cullen','Hillie'),
(18,'doakleyh','doakleyh@mysql.com','0f12f5d77b79f23d859eaf2009408be84bcf16e7faa12747d049d5d09ff1a6fa','2026-03-05 21:01:34','Oakley','Dov'),
(19,'lstollardi','lstollardi@nsw.gov.au','f064da9f2729c400a09756ada623fc3f8c567cffe39b345ed05eb8dbadd858ef','2026-03-05 21:01:34','Stollard','Lura'),
(20,'kfudgerj','kfudgerj@washingtonpost.com','9ed72cb86e416380a43b74a2e8415f526d0f0a963ad3e0de289fb0f331db5838','2026-03-05 21:01:34','Fudger','Kristal'),
(21,'eharvattk','eharvattk@about.com','b9b6a1e3306c4be5d6cd024d7ed622ffce2a86aa4ffcb22d121ad7d9f9887d3c','2026-03-05 21:04:55','Harvatt','Electra'),
(22,'gnewdickl','gnewdickl@omniture.com','7ff979ef40a0c5ba145b5d0e971dafae87fc6c47f375c1a9a323ec5e425161e8','2026-03-05 21:04:55','Newdick','Gordie'),
(23,'hjestm','hjestm@purevolume.com','87e68613d3981e5115b52f6cea1a0acc9b054734862f54833a6de098ee431d17','2026-03-05 21:04:55','Jest','Homere'),
(24,'mmatevushevn','mmatevushevn@nydailynews.com','22175faae3cdc701b8d6f85875073041e7a142398ee4031ae803f31131428916','2026-03-05 21:04:55','Matevushev','Modesty'),
(25,'sneleso','sneleso@gov.uk','2acd56b6e2e6ada4950f41b80daecbbb418996487fc855dee105ef97d68d4902','2026-03-05 21:04:55','Neles','Siward'),
(26,'rpoyntzp','rpoyntzp@myspace.com','1d251fa19549c6e25577cb1491a8de31a31d03864a19cb7cbcf70809387f3bca','2026-03-05 21:04:55','Poyntz','Reina'),
(27,'sjanneyq','sjanneyq@google.com.au','ebb3e0c59070cf8e64d41fde370676dfc066e0f1a763f5d6e1c2743a7e00004f','2026-03-05 21:04:55','Janney','Shell'),
(28,'aautier','aautier@pen.io','3d2bec8a1ece4948f6fbac74f676b1b6783449c63ead351f85ab3ec042b003f8','2026-03-05 21:04:55','Autie','Alastair'),
(29,'rbonniers','rbonniers@rakuten.co.jp','29d64bcb397fa695266dc93bafae61b7579726b2fc2f96da03df90dc6b999aa7','2026-03-05 21:04:55','Bonnier','Ranee'),
(30,'ktornst','ktornst@123-reg.co.uk','d6db2f1a588cc8bcb67384ed1fdbc15290aecf16dc8bad4ccc4416fc732e7163','2026-03-05 21:04:55','Torns','Kati'),
(31,'bcorradinou','bcorradinou@hugedomains.com','8c36e66cdeb0e69094e0345dbb6579fdc15702082ac6e845bef1eb2c5d5dba76','2026-03-05 21:04:55','Corradino','Bab'),
(32,'elawtyv','elawtyv@google.ca','53e23a523d5578e739c2c11e1d2b1d3a2ce2e50669cf34a6e9aa02d94c6fe067','2026-03-05 21:04:55','Lawty','Emilee'),
(33,'mbehaggw','mbehaggw@eventbrite.com','d507a6857059157a76795284f69a8dba98d094b6213f0cfddb42075ed7d61f19','2026-03-05 21:04:55','Behagg','Miriam'),
(34,'tavrahamyx','tavrahamyx@mashable.com','b8029ea4836d6d9f048c213015d8ceff94812bf0fe62497995cc7e0b9a50f714','2026-03-05 21:04:55','Avrahamy','Terese'),
(35,'dlehucquety','dlehucquety@nih.gov','662a2fbb7c3467d8a369d32beab0a84a109ce271f24ae8861efa44bb25bb2f92','2026-03-05 21:04:55','Le Hucquet','Dennison'),
(36,'dmirrleesz','dmirrleesz@mail.ru','4ea3e6bec3b26579b0ab64a59d8866999dd68af89067c81ad83fa4b3a63644ff','2026-03-05 21:04:55','Mirrlees','Dotty'),
(37,'cmilland10','cmilland10@patch.com','ce6406a345bb0d4b45cbc74cf57760a72cd6faab860999348132c51bcf920d30','2026-03-05 21:04:55','Milland','Cirillo'),
(38,'rmanis11','rmanis11@diigo.com','2a6597ccef2f2ad5276f504c0a340adfd3fda0b403f86aad2429164b2c4937c0','2026-03-05 21:04:55','Manis','Ryan'),
(39,'vattle12','vattle12@pen.io','2ecc65adb832550b516a2c1a405fd38bd25532cb3fc7bd7b339e50f83fab7275','2026-03-05 21:04:55','Attle','Vonny'),
(40,'bcottee13','bcottee13@chicagotribune.com','7f5ed363f21b8f396cc899411ddf2f4fd7d119a9136c7aeab43277663f712846','2026-03-05 21:04:55','Cottee','Belle'),
(41,'oriddick14','oriddick14@sina.com.cn','91ca9f69140d873f204db67a36e39564c8c337c8190024b1f5081e0a5067c2fe','2026-03-05 21:05:34','Riddick','Olivette'),
(42,'abillo15','abillo15@skyrock.com','d1b512bc74e34ba5ee0f86ab7ea18125eeb0d1f94a34c4d909474d622437c062','2026-03-05 21:05:34','Billo','Adolpho'),
(43,'aeydel16','aeydel16@163.com','5e28a6037ebb2dfd022517eb532550cbd824be17a28ba2fef9d5055938b7bb83','2026-03-05 21:05:34','Eydel','Angeli'),
(44,'nlavrick17','nlavrick17@mapy.cz','e9c2b809044a07c1f8046bb7de5f103b0e155d401cd742214be5423f3264cd7d','2026-03-05 21:05:34','Lavrick','Niles'),
(45,'aroffey18','aroffey18@marriott.com','a6d29203a665b03f5fba1f67beb84f3ab119c50d66a3cc37c7ee1d204340431d','2026-03-05 21:05:34','Roffey','Ariel'),
(46,'aminors19','aminors19@usda.gov','f2edf4b7fc900c9e008182ced1bb56b0db3a34e7bfb60912fa08af35da5335a1','2026-03-05 21:05:34','Minors','Audry'),
(47,'lduddridge1b','lduddridge1b@mit.edu','ff0f139f3c7275fce7164701a23eb21bc808167f097321b2ca0f91e72faf62ba','2026-03-05 21:05:34','Duddridge','Lennie'),
(48,'lwallman1c','lwallman1c@netscape.com','c33ac309a3baa1ac2869ba9eb4527d097e86f7ee4e4d038ab20b3ff536281d6a','2026-03-05 21:05:34','Wallman','Lorianna'),
(49,'odawney1d','odawney1d@nationalgeographic.com','10482ca5501f6b0157a10891a35e283a3abaa1a0e2e6d5464d37dc4b81677bb8','2026-03-05 21:05:34','Dawney','Orelie'),
(50,'rgavini1e','rgavini1e@squidoo.com','26141719210168f62d989741cac5e4484b179e52afd1c6a4c28b6d0add0d10aa','2026-03-05 21:05:34','Gavini','Reuven'),
(51,'mcharker1f','mcharker1f@noaa.gov','035a1a991185d18c9984de8065323251712e45ad493c15f81aaf5ad1b0556fd0','2026-03-05 21:05:34','Charker','Marinna'),
(52,'jmatejic1g','jmatejic1g@mozilla.com','2f02cef7229c0a290fc90bf71919ced5c4e44529cd7c0a9dda21cbdcb990ddc8','2026-03-05 21:05:34','Matejic','Justina'),
(53,'cblincoe1h','cblincoe1h@salon.com','e1e2afc4334f20437e6f6b6b10741878b7bd23b014417b0fd45e4b4a84504d0d','2026-03-05 21:05:34','Blincoe','Court'),
(54,'fsooley1i','fsooley1i@sphinn.com','bdbd2d908b6dd09a0fdb6bd83317de4d826827e8d045c47ed5e63ed11f1d36c5','2026-03-05 21:05:34','Sooley','Florian'),
(55,'mrubinsaft1j','mrubinsaft1j@amazon.com','ba56e7c472c28bf0d2a1de818e684ca661dd334e8327d09944a1521c038f43b6','2026-03-05 21:05:34','Rubinsaft','Marie-jeanne'),
(56,'hbrum1k','hbrum1k@fastcompany.com','ddcf2f642375b9d46127dd562a3a1b76424c30a5748499326f6a50487c7921d2','2026-03-05 21:05:34','Brum','Hillie'),
(57,'ichmiel1l','ichmiel1l@ftc.gov','3ef435f2bbee9aca5668cd032a0a272c048087f1d4bf51a22e7eeb808908799c','2026-03-05 21:05:34','Chmiel','Ivory'),
(58,'awhytock1m','awhytock1m@jimdo.com','bcf3362ce0fcb700a04eb8aa972d1a162db9d3f3f9513ee53ff322d22235ee20','2026-03-05 21:05:34','Whytock','Amity'),
(59,'mcarnoghan1n','mcarnoghan1n@biglobe.ne.jp','4e2281325cbbeb0b17010156c1bd22aff23b0b3e937525fe0182ffd9b2f23882','2026-03-05 21:05:34','Carnoghan','Maureen'),
(60,'ogullefant1o','ogullefant1o@msn.com','e09e9414e77b9fde4a7b360cc1186b9414be9a43abcb0840abdcff8a1a96cd48','2026-03-05 21:05:34','Gullefant','Odetta'),
(61,'qw','qw@email.com','99603673ef52d660d00d9c0d427280c40b655a999d8ebfdf6477322a16dcbeb2','2026-03-11 17:04:11','w','q');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-03-13 13:04:19
