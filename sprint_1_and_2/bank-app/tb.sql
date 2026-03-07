-- -------------------------------------------------------------
-- TablePlus 6.8.2(656)
--
-- https://tableplus.com/
--
-- Database: trackbudget_db
-- Generation Time: 2026-03-05 21:40:45.9580
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `vendor_name` varchar(100) DEFAULT NULL,
  `money_spent` decimal(10,2) DEFAULT NULL,
  `date_of_transaction` date DEFAULT NULL,
  `transaction_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_name` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `transactions` (`transaction_id`, `user_id`, `vendor_name`, `money_spent`, `date_of_transaction`, `transaction_type`) VALUES
(1, 1, 'Starbucks', 6.50, '2026-03-01', 'Food & Drink'),
(2, 5, 'Amazon', 45.99, '2026-03-01', 'Shopping'),
(3, 12, 'Apple Store', 129.00, '2026-03-02', 'Electronics'),
(4, 2, 'Shell Gas', 35.00, '2026-03-02', 'Transport'),
(5, 45, 'Netflix', 15.99, '2026-03-02', 'Entertainment'),
(6, 8, 'Whole Foods', 82.30, '2026-03-03', 'Groceries'),
(7, 20, 'Uber', 12.50, '2026-03-03', 'Transport'),
(8, 33, 'Chipotle', 14.25, '2026-03-03', 'Food & Drink'),
(9, 15, 'Target', 22.15, '2026-03-04', 'Shopping'),
(10, 58, 'Nike', 110.00, '2026-03-04', 'Shopping'),
(11, 10, 'Starbucks', 5.75, '2026-03-04', 'Food & Drink'),
(12, 4, 'Spotify', 10.99, '2026-03-05', 'Entertainment'),
(13, 50, 'AMC Theater', 18.00, '2026-03-05', 'Entertainment'),
(14, 25, 'Walmart', 56.40, '2026-03-05', 'Groceries'),
(15, 60, 'Planet Fitness', 25.00, '2026-03-05', 'Health'),
(16, 21, 'Walmart', 45.10, '2026-03-05', 'Groceries'),
(17, 22, 'Shell Gas', 42.00, '2026-03-05', 'Transport'),
(18, 23, 'Chick-fil-A', 15.20, '2026-03-05', 'Food & Drink'),
(19, 24, 'Amazon', 12.99, '2026-03-05', 'Shopping'),
(20, 25, 'Netflix', 15.99, '2026-03-05', 'Entertainment'),
(21, 26, 'Starbucks', 5.45, '2026-03-05', 'Food & Drink'),
(22, 27, 'Uber', 18.50, '2026-03-05', 'Transport'),
(23, 28, 'Target', 34.20, '2026-03-05', 'Shopping'),
(24, 29, 'Chipotle', 12.50, '2026-03-05', 'Food & Drink'),
(25, 30, 'Apple Music', 10.99, '2026-03-05', 'Entertainment'),
(26, 31, 'Dunkin Donuts', 4.50, '2026-03-05', 'Food & Drink'),
(27, 32, 'Chevron', 50.00, '2026-03-05', 'Transport'),
(28, 33, 'Steam Games', 59.99, '2026-03-05', 'Entertainment'),
(29, 34, 'Walgreens', 22.15, '2026-03-05', 'Health'),
(30, 35, 'McDonalds', 9.80, '2026-03-05', 'Food & Drink'),
(31, 36, 'H&M', 45.00, '2026-03-05', 'Shopping'),
(32, 37, 'CVS Pharmacy', 15.30, '2026-03-05', 'Health'),
(33, 38, 'Lyft', 22.00, '2026-03-05', 'Transport'),
(34, 39, 'Taco Bell', 11.25, '2026-03-05', 'Food & Drink'),
(35, 40, 'Best Buy', 89.99, '2026-03-05', 'Electronics'),
(36, 41, 'Spotify', 10.99, '2026-03-05', 'Entertainment'),
(37, 42, 'Whole Foods', 65.40, '2026-03-05', 'Groceries'),
(38, 43, 'Subway', 13.00, '2026-03-05', 'Food & Drink'),
(39, 44, '7-Eleven', 8.50, '2026-03-05', 'Shopping'),
(40, 46, 'AMC Theater', 25.00, '2026-03-05', 'Entertainment'),
(41, 47, 'Adidas', 75.00, '2026-03-05', 'Shopping'),
(42, 48, 'Starbucks', 6.25, '2026-03-05', 'Food & Drink'),
(43, 49, 'Uber Eats', 32.10, '2026-03-05', 'Food & Drink'),
(44, 51, 'Home Depot', 120.00, '2026-03-05', 'Shopping'),
(45, 52, 'Petco', 45.99, '2026-03-05', 'Other');

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `created_at`, `last_name`, `first_name`) VALUES
(1, 'rhellis0', 'rhellis0@virginia.edu', 'bG7<LRGjk5', '2026-03-05 14:51:09', 'Hellis', 'Roanna'),
(2, 'vbollen1', 'vbollen1@comcast.net', 'hS8!lk<nfr', '2026-03-05 15:01:34', 'Bollen', 'Veronique'),
(3, 'kvreede2', 'kvreede2@walmart.com', 'eN9\"O|BC', '2026-03-05 15:01:34', 'Vreede', 'Kellina'),
(4, 'aalgie3', 'aalgie3@opensource.org', 'qB0||z/Mm#', '2026-03-05 15:01:34', 'Algie', 'Aldis'),
(5, 'ntorn4', 'ntorn4@mozilla.org', 'pO3&M$09<q', '2026-03-05 15:01:34', 'Torn', 'Nancee'),
(6, 'eswales5', 'eswales5@liveinternet.ru', 'mY9\"lm+\'8OnG26`f', '2026-03-05 15:01:34', 'Swales', 'Essa'),
(7, 'iradenhurst6', 'iradenhurst6@si.edu', 'sY7<Vb#2E', '2026-03-05 15:01:34', 'Radenhurst', 'Idelle'),
(8, 'gcurtoys7', 'gcurtoys7@harvard.edu', 'aY1&D,=E/`\'', '2026-03-05 15:01:34', 'Curtoys', 'Garvey'),
(9, 'htammadge8', 'htammadge8@cnn.com', 'mB3@Ss<#H', '2026-03-05 15:01:34', 'Tammadge', 'Harley'),
(10, 'bodocherty9', 'bodocherty9@archive.org', 'zI7|0,)OX/uSHj', '2026-03-05 15:01:34', 'O\'Docherty', 'Babs'),
(11, 'pbarra', 'pbarra@com.com', 'qD6.Xu4HL~4\'e\"', '2026-03-05 15:01:34', 'Barr', 'Pearce'),
(12, 'awarltonb', 'awarltonb@ft.com', 'fO3?zO?AqnQs', '2026-03-05 15:01:34', 'Warlton', 'Axe'),
(13, 'edinsdalec', 'edinsdalec@youtube.com', 'wX3_aYQA3', '2026-03-05 15:01:34', 'Dinsdale', 'Elonore'),
(14, 'kshrimptond', 'kshrimptond@printfriendly.com', 'fH0`R8gRw?9hQ=', '2026-03-05 15:01:34', 'Shrimpton', 'Kimmy'),
(15, 'rcushellye', 'rcushellye@craigslist.org', 'vB0|L?A?\'>mXiM', '2026-03-05 15:01:34', 'Cushelly', 'Rudie'),
(16, 'mairyf', 'mairyf@senate.gov', 'fP7`m!x*kg', '2026-03-05 15:01:34', 'Airy', 'Marita'),
(17, 'hculleng', 'hculleng@mozilla.org', 'zB4*@e%u', '2026-03-05 15:01:34', 'Cullen', 'Hillie'),
(18, 'doakleyh', 'doakleyh@mysql.com', 'vS4%FRV84#+$9%o', '2026-03-05 15:01:34', 'Oakley', 'Dov'),
(19, 'lstollardi', 'lstollardi@nsw.gov.au', 'yV2.AYV71TQm@dS', '2026-03-05 15:01:34', 'Stollard', 'Lura'),
(20, 'kfudgerj', 'kfudgerj@washingtonpost.com', 'mX5&/\'xYA}cTw~<\"', '2026-03-05 15:01:34', 'Fudger', 'Kristal'),
(21, 'eharvattk', 'eharvattk@about.com', 'zA3ksRIcEoiH', '2026-03-05 15:04:55', 'Harvatt', 'Electra'),
(22, 'gnewdickl', 'gnewdickl@omniture.com', 'kL4PWrXhtXFw', '2026-03-05 15:04:55', 'Newdick', 'Gordie'),
(23, 'hjestm', 'hjestm@purevolume.com', 'mP4KjRwCWn', '2026-03-05 15:04:55', 'Jest', 'Homere'),
(24, 'mmatevushevn', 'mmatevushevn@nydailynews.com', 'vT02qOZy', '2026-03-05 15:04:55', 'Matevushev', 'Modesty'),
(25, 'sneleso', 'sneleso@gov.uk', 'aX9xHyjL', '2026-03-05 15:04:55', 'Neles', 'Siward'),
(26, 'rpoyntzp', 'rpoyntzp@myspace.com', 'hU03aT2cCv', '2026-03-05 15:04:55', 'Poyntz', 'Reina'),
(27, 'sjanneyq', 'sjanneyq@google.com.au', 'oI4tfiVa0', '2026-03-05 15:04:55', 'Janney', 'Shell'),
(28, 'aautier', 'aautier@pen.io', 'jM20dIm6E', '2026-03-05 15:04:55', 'Autie', 'Alastair'),
(29, 'rbonniers', 'rbonniers@rakuten.co.jp', 'kY3rgr0LyLC2', '2026-03-05 15:04:55', 'Bonnier', 'Ranee'),
(30, 'ktornst', 'ktornst@123-reg.co.uk', 'tO91jb0Z', '2026-03-05 15:04:55', 'Torns', 'Kati'),
(31, 'bcorradinou', 'bcorradinou@hugedomains.com', 'yR2Rp_o', '2026-03-05 15:04:55', 'Corradino', 'Bab'),
(32, 'elawtyv', 'elawtyv@google.ca', 'vH8qILNkPd', '2026-03-05 15:04:55', 'Lawty', 'Emilee'),
(33, 'mbehaggw', 'mbehaggw@eventbrite.com', 'qQ3Yfm', '2026-03-05 15:04:55', 'Behagg', 'Miriam'),
(34, 'tavrahamyx', 'tavrahamyx@mashable.com', 'gL2v4qHuLAg', '2026-03-05 15:04:55', 'Avrahamy', 'Terese'),
(35, 'dlehucquety', 'dlehucquety@nih.gov', 'tW9NJ', '2026-03-05 15:04:55', 'Le Hucquet', 'Dennison'),
(36, 'dmirrleesz', 'dmirrleesz@mail.ru', 'aB3tRyN1V0', '2026-03-05 15:04:55', 'Mirrlees', 'Dotty'),
(37, 'cmilland10', 'cmilland10@patch.com', 'iV1RDzEV', '2026-03-05 15:04:55', 'Milland', 'Cirillo'),
(38, 'rmanis11', 'rmanis11@diigo.com', 'oD3BzSyvINtWV', '2026-03-05 15:04:55', 'Manis', 'Ryan'),
(39, 'vattle12', 'vattle12@pen.io', 'wC8aykHnbW', '2026-03-05 15:04:55', 'Attle', 'Vonny'),
(40, 'bcottee13', 'bcottee13@chicagotribune.com', 'mC3zcB2', '2026-03-05 15:04:55', 'Cottee', 'Belle'),
(41, 'oriddick14', 'oriddick14@sina.com.cn', 'vQ5taNytkEEW', '2026-03-05 15:05:34', 'Riddick', 'Olivette'),
(42, 'abillo15', 'abillo15@skyrock.com', 'cF1jCbzS6JJ6', '2026-03-05 15:05:34', 'Billo', 'Adolpho'),
(43, 'aeydel16', 'aeydel16@163.com', 'yT7iEhL', '2026-03-05 15:05:34', 'Eydel', 'Angeli'),
(44, 'nlavrick17', 'nlavrick17@mapy.cz', 'yG4WA2edUz', '2026-03-05 15:05:34', 'Lavrick', 'Niles'),
(45, 'aroffey18', 'aroffey18@marriott.com', 'uF6gcOD', '2026-03-05 15:05:34', 'Roffey', 'Ariel'),
(46, 'aminors19', 'aminors19@usda.gov', 'iO7UWH1HU', '2026-03-05 15:05:34', 'Minors', 'Audry'),
(47, 'lduddridge1b', 'lduddridge1b@mit.edu', 'mM2Z6mQPv', '2026-03-05 15:05:34', 'Duddridge', 'Lennie'),
(48, 'lwallman1c', 'lwallman1c@netscape.com', 'oB7WG6bs4', '2026-03-05 15:05:34', 'Wallman', 'Lorianna'),
(49, 'odawney1d', 'odawney1d@nationalgeographic.com', 'jG3UDcG0', '2026-03-05 15:05:34', 'Dawney', 'Orelie'),
(50, 'rgavini1e', 'rgavini1e@squidoo.com', 'oF5AQ', '2026-03-05 15:05:34', 'Gavini', 'Reuven'),
(51, 'mcharker1f', 'mcharker1f@noaa.gov', 'nO1DBpyZ29Ji', '2026-03-05 15:05:34', 'Charker', 'Marinna'),
(52, 'jmatejic1g', 'jmatejic1g@mozilla.com', 'hS9YOqRK2so', '2026-03-05 15:05:34', 'Matejic', 'Justina'),
(53, 'cblincoe1h', 'cblincoe1h@salon.com', 'fS6676GXrPK', '2026-03-05 15:05:34', 'Blincoe', 'Court'),
(54, 'fsooley1i', 'fsooley1i@sphinn.com', 'sA1FbiT', '2026-03-05 15:05:34', 'Sooley', 'Florian'),
(55, 'mrubinsaft1j', 'mrubinsaft1j@amazon.com', 'gB8Ndty', '2026-03-05 15:05:34', 'Rubinsaft', 'Marie-jeanne'),
(56, 'hbrum1k', 'hbrum1k@fastcompany.com', 'cE6Iz358r3Z', '2026-03-05 15:05:34', 'Brum', 'Hillie'),
(57, 'ichmiel1l', 'ichmiel1l@ftc.gov', 'aJ8VQMKq8TYY', '2026-03-05 15:05:34', 'Chmiel', 'Ivory'),
(58, 'awhytock1m', 'awhytock1m@jimdo.com', 'lM1txKcgGT', '2026-03-05 15:05:34', 'Whytock', 'Amity'),
(59, 'mcarnoghan1n', 'mcarnoghan1n@biglobe.ne.jp', 'jU82VAqExT', '2026-03-05 15:05:34', 'Carnoghan', 'Maureen'),
(60, 'ogullefant1o', 'ogullefant1o@msn.com', 'yL56oTB9rI1Y', '2026-03-05 15:05:34', 'Gullefant', 'Odetta');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
