failed to get console mode for stdout: The handle is invalid.
-- MySQL dump 10.13  Distrib 8.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: bookssystem
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Authors`
--

DROP TABLE IF EXISTS `Authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Authors`
--

LOCK TABLES `Authors` WRITE;
/*!40000 ALTER TABLE `Authors` DISABLE KEYS */;
INSERT INTO `Authors` VALUES (1,'Henryk','Sienkiewicz');
/*!40000 ALTER TABLE `Authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Book_Author`
--

DROP TABLE IF EXISTS `Book_Author`;
/*!50001 DROP VIEW IF EXISTS `Book_Author`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Book_Author` AS SELECT 
 1 AS `ISBN`,
 1 AS `title`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `number_of_pages`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Books`
--

DROP TABLE IF EXISTS `Books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `ISBN` varchar(255) NOT NULL,
  `number_of_pages` int NOT NULL,
  `author_id` int NOT NULL,
  `publisher_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `PublisherID` (`publisher_id`),
  KEY `GenreID` (`genre_id`),
  KEY `fk_books_authors` (`author_id`),
  CONSTRAINT `Books_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `Publishers` (`id`),
  CONSTRAINT `Books_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `Genres` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Books`
--

LOCK TABLES `Books` WRITE;
/*!40000 ALTER TABLE `Books` DISABLE KEYS */;
INSERT INTO `Books` VALUES (1,'Potop','9788308000000',500,1,1,1);
/*!40000 ALTER TABLE `Books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Deliveries`
--

DROP TABLE IF EXISTS `Deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Deliveries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `delivery_date` date NOT NULL,
  `delivery_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Deliveries_ibfk_1` (`user_id`),
  KEY `Deliveries_ibfk_2` (`book_id`),
  KEY `Deliveries_ibfk_3` (`delivery_status_id`),
  CONSTRAINT `Deliveries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `Deliveries_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `Books` (`id`),
  CONSTRAINT `Deliveries_ibfk_3` FOREIGN KEY (`delivery_status_id`) REFERENCES `Delivery_status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deliveries`
--

LOCK TABLES `Deliveries` WRITE;
/*!40000 ALTER TABLE `Deliveries` DISABLE KEYS */;
INSERT INTO `Deliveries` VALUES (3,1,1,'2024-03-12',1),(4,1,1,'2024-03-15',1);
/*!40000 ALTER TABLE `Deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Delivery_status`
--

DROP TABLE IF EXISTS `Delivery_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Delivery_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Delivery_status`
--

LOCK TABLES `Delivery_status` WRITE;
/*!40000 ALTER TABLE `Delivery_status` DISABLE KEYS */;
INSERT INTO `Delivery_status` VALUES (1,'waiting'),(2,'sent'),(3,'failed'),(4,'unknown');
/*!40000 ALTER TABLE `Delivery_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genres`
--

DROP TABLE IF EXISTS `Genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genres`
--

LOCK TABLES `Genres` WRITE;
/*!40000 ALTER TABLE `Genres` DISABLE KEYS */;
INSERT INTO `Genres` VALUES (1,'Powiesc historyczna'),(2,'Dramat'),(3,'default_genre');
/*!40000 ALTER TABLE `Genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notification_type`
--

DROP TABLE IF EXISTS `Notification_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notification_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notification_type`
--

LOCK TABLES `Notification_type` WRITE;
/*!40000 ALTER TABLE `Notification_type` DISABLE KEYS */;
INSERT INTO `Notification_type` VALUES (2,'Nowe powiadomienie');
/*!40000 ALTER TABLE `Notification_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` varchar(255) NOT NULL,
  `notification_type_id` int NOT NULL,
  `sending_date` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id`),
  KEY `Notifications_ibfk_1` (`user_id`),
  KEY `Notifications_ibfk_2` (`notification_type_id`),
  CONSTRAINT `Notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `Notifications_ibfk_2` FOREIGN KEY (`notification_type_id`) REFERENCES `Notification_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notifications`
--

LOCK TABLES `Notifications` WRITE;
/*!40000 ALTER TABLE `Notifications` DISABLE KEYS */;
INSERT INTO `Notifications` VALUES (1,1,'Witaj Jan! Twoja ksika \"Potop\" zostaa wysana.',2,'2024-03-20');
/*!40000 ALTER TABLE `Notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payment_status`
--

DROP TABLE IF EXISTS `Payment_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payment_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment_status`
--

LOCK TABLES `Payment_status` WRITE;
/*!40000 ALTER TABLE `Payment_status` DISABLE KEYS */;
INSERT INTO `Payment_status` VALUES (1,'paid'),(2,'unpaid');
/*!40000 ALTER TABLE `Payment_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Payments_ibfk_1` (`user_id`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payments`
--

LOCK TABLES `Payments` WRITE;
/*!40000 ALTER TABLE `Payments` DISABLE KEYS */;
INSERT INTO `Payments` VALUES (1,1,'2024-03-15',10.99,1);
/*!40000 ALTER TABLE `Payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publishers`
--

DROP TABLE IF EXISTS `Publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publishers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publishers`
--

LOCK TABLES `Publishers` WRITE;
/*!40000 ALTER TABLE `Publishers` DISABLE KEYS */;
INSERT INTO `Publishers` VALUES (1,'Wydawnictwo Literackie'),(2,'Wydawnictwo Naukowe'),(3,'Wydawnictwo Fantastyki'),(4,'default_publisher');
/*!40000 ALTER TABLE `Publishers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Queue`
--

DROP TABLE IF EXISTS `Queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Queue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  `queue_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `book_id` (`book_id`),
  KEY `user_id` (`user_id`),
  KEY `fk_queue_status_id` (`queue_status_id`),
  CONSTRAINT `fk_queue_status_id` FOREIGN KEY (`queue_status_id`) REFERENCES `Queue_status` (`id`),
  CONSTRAINT `Queue_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `Books` (`id`),
  CONSTRAINT `Queue_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Queue`
--

LOCK TABLES `Queue` WRITE;
/*!40000 ALTER TABLE `Queue` DISABLE KEYS */;
INSERT INTO `Queue` VALUES (1,1,1,1),(2,1,1,1),(3,1,1,1);
/*!40000 ALTER TABLE `Queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Queue_status`
--

DROP TABLE IF EXISTS `Queue_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Queue_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Queue_status`
--

LOCK TABLES `Queue_status` WRITE;
/*!40000 ALTER TABLE `Queue_status` DISABLE KEYS */;
INSERT INTO `Queue_status` VALUES (1,'available'),(2,'reserved'),(3,'borrowed');
/*!40000 ALTER TABLE `Queue_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rental_status`
--

DROP TABLE IF EXISTS `Rental_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rental_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rental_status`
--

LOCK TABLES `Rental_status` WRITE;
/*!40000 ALTER TABLE `Rental_status` DISABLE KEYS */;
INSERT INTO `Rental_status` VALUES (1,'rented'),(2,'held');
/*!40000 ALTER TABLE `Rental_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rentals`
--

DROP TABLE IF EXISTS `Rentals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rentals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `rental_date` date NOT NULL,
  `return_date` date NOT NULL,
  `rental_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Rentals_ibfk_1` (`user_id`),
  KEY `Rentals_ibfk_2` (`book_id`),
  KEY `fk_rental_status_id` (`rental_status_id`),
  CONSTRAINT `fk_rental_status_id` FOREIGN KEY (`rental_status_id`) REFERENCES `Rental_status` (`id`),
  CONSTRAINT `Rentals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `Rentals_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `Books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rentals`
--

LOCK TABLES `Rentals` WRITE;
/*!40000 ALTER TABLE `Rentals` DISABLE KEYS */;
INSERT INTO `Rentals` VALUES (1,1,1,'2024-03-15','2024-04-15',1),(2,1,1,'2024-04-16','2024-05-16',1);
/*!40000 ALTER TABLE `Rentals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation_status`
--

DROP TABLE IF EXISTS `Reservation_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation_status`
--

LOCK TABLES `Reservation_status` WRITE;
/*!40000 ALTER TABLE `Reservation_status` DISABLE KEYS */;
INSERT INTO `Reservation_status` VALUES (1,'reserved'),(2,'cancelled');
/*!40000 ALTER TABLE `Reservation_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservations`
--

DROP TABLE IF EXISTS `Reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `reservation_date` date NOT NULL,
  `reservation_status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Reservations_ibfk_1` (`user_id`),
  KEY `Reservations_ibfk_2` (`book_id`),
  KEY `fk_reservation_status_id` (`reservation_status_id`),
  CONSTRAINT `fk_reservation_status_id` FOREIGN KEY (`reservation_status_id`) REFERENCES `Reservation_status` (`id`),
  CONSTRAINT `Reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `Reservations_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `Books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservations`
--

LOCK TABLES `Reservations` WRITE;
/*!40000 ALTER TABLE `Reservations` DISABLE KEYS */;
INSERT INTO `Reservations` VALUES (1,1,1,'2024-03-15',1),(2,1,1,'2024-03-16',1);
/*!40000 ALTER TABLE `Reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'Administrator','Full access to all system functionalities'),(2,'Library Employee','Access to manage books, users, and reservations'),(3,'Reader','Access to borrow and reserve books');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `role_id` int NOT NULL,
  `salt` varchar(30) NOT NULL,
  `login` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'haslo123','token123',3,'','jankowalski');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `Book_Author`
--

/*!50001 DROP VIEW IF EXISTS `Book_Author`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Book_Author` AS select `Books`.`ISBN` AS `ISBN`,`Books`.`title` AS `title`,`Authors`.`first_name` AS `first_name`,`Authors`.`last_name` AS `last_name`,`Books`.`number_of_pages` AS `number_of_pages` from (`Books` join `Authors` on((`Books`.`author_id` = `Authors`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-14 16:59:03
