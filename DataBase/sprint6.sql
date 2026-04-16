-- -------------------------------------------------------------
-- TablePlus 6.8.6(662)
--
-- https://tableplus.com/
--
-- Database: trackbudget_db
-- Generation Time: 2026-04-16 10:49:38.8890
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP VIEW IF EXISTS `ai_spending_analysis`;


DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history` (
  `chat_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `user_query` text NOT NULL,
  `ai_response` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

DROP TABLE IF EXISTS `user_types`;
CREATE TABLE `user_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `account_type` enum('Student','Default','Business') DEFAULT 'Default',
  PRIMARY KEY (`type_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_types_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  UNIQUE KEY `user_name` (`user_name`) USING BTREE,
  UNIQUE KEY `email_2` (`email`),
  UNIQUE KEY `user_name_2` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `chat_history` (`chat_id`, `user_id`, `user_query`, `ai_response`, `timestamp`) VALUES
(1, 1, 'How much did I spend at Starbucks?', 'You spent $6.50 at Starbucks on March 1st.', '2026-04-16 10:48:05');

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

INSERT INTO `user_types` (`type_id`, `user_id`, `account_type`) VALUES
(1, 1, 'Student'),
(2, 2, 'Student'),
(3, 3, 'Student'),
(4, 4, 'Student'),
(5, 5, 'Student'),
(6, 6, 'Student'),
(7, 7, 'Student'),
(8, 8, 'Student'),
(9, 9, 'Student'),
(10, 10, 'Student'),
(11, 11, 'Student'),
(12, 12, 'Student'),
(13, 13, 'Student'),
(14, 14, 'Student'),
(15, 15, 'Student'),
(16, 16, 'Student'),
(17, 17, 'Student'),
(18, 18, 'Student'),
(19, 19, 'Student'),
(20, 20, 'Student'),
(21, 21, 'Business'),
(22, 22, 'Business'),
(23, 23, 'Business'),
(24, 24, 'Business'),
(25, 25, 'Business'),
(26, 26, 'Business'),
(27, 27, 'Business'),
(28, 28, 'Business'),
(29, 29, 'Business'),
(30, 30, 'Business'),
(31, 31, 'Business'),
(32, 32, 'Business'),
(33, 33, 'Business'),
(34, 34, 'Business'),
(35, 35, 'Business'),
(36, 36, 'Business'),
(37, 37, 'Business'),
(38, 38, 'Business'),
(39, 39, 'Business'),
(40, 40, 'Business'),
(41, 41, 'Default'),
(42, 42, 'Default'),
(43, 43, 'Default'),
(44, 44, 'Default'),
(45, 45, 'Default'),
(46, 46, 'Default'),
(47, 47, 'Default'),
(48, 48, 'Default'),
(49, 49, 'Default'),
(50, 50, 'Default'),
(51, 51, 'Default'),
(52, 52, 'Default'),
(53, 53, 'Default'),
(54, 54, 'Default'),
(55, 55, 'Default'),
(56, 56, 'Default'),
(57, 57, 'Default'),
(58, 58, 'Default'),
(59, 59, 'Default'),
(60, 60, 'Default');

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ai_spending_analysis` AS select `u`.`user_id` AS `user_id`,`ut`.`account_type` AS `account_type`,`t`.`vendor_name` AS `vendor_name`,`t`.`money_spent` AS `money_spent`,`t`.`transaction_type` AS `transaction_type`,`t`.`date_of_transaction` AS `date_of_transaction` from ((`users` `u` join `user_types` `ut` on((`u`.`user_id` = `ut`.`user_id`))) join `transactions` `t` on((`u`.`user_id` = `t`.`user_id`)));


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;