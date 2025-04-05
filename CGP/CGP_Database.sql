-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: cgp
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cakes`
--

DROP TABLE IF EXISTS `cakes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cakes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cakes`
--

LOCK TABLES `cakes` WRITE;
/*!40000 ALTER TABLE `cakes` DISABLE KEYS */;
INSERT INTO `cakes` VALUES (1,'Luxurious Gold Fondant','A royal wedding cake with gold fondant and elegant details.',450.00,4.9,'https://cakevows.com/wp-content/uploads/2025/03/midnightpulse_01554_A_luxurious_royal_wedding_cake_with_multipl_814f6387-bbae-42c5-9870-256c5446a730.png'),(2,'Elegant Tiered Buttercream','A beautifully stacked buttercream cake for classy weddings.',380.00,4.8,'https://i.pinimg.com/474x/2e/63/8d/2e638dea37e6f31beac55d7514efe2e7.jpg'),(3,'Minimalist White Elegance','Clean and simple cake design for modern weddings.',320.00,4.7,'https://cakevows.com/wp-content/uploads/2024/07/White-Gender-Reveal-Cake-1024x574.png'),(4,'Rustic Naked Cake','A naked cake with rustic charm, perfect for countryside weddings.',290.00,4.9,'https://i.pinimg.com/736x/26/32/f5/2632f5ca427855db44297b077834d11f.jpg'),(5,'apple cake','apple flavor',12.00,2.0,'https://th.bing.com/th/id/OIP.rm4FTCB9kn1CHXZIWIzalwHaJ5?w=206&h=276&c=7&r=0&o=5&dpr=1.3&pid=1.7');
/*!40000 ALTER TABLE `cakes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-05 11:18:57
