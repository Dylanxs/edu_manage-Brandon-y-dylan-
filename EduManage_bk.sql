-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: EduManage
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alumnos`
--

DROP TABLE IF EXISTS `alumnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alumnos` (
  `id_alumno` binary(16) NOT NULL,
  `carnet_alumno` varchar(10) DEFAULT NULL,
  `nombre_alumno` varchar(50) DEFAULT NULL,
  `apellido_alumno` varchar(50) DEFAULT NULL,
  `edad_alumno` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_alumno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumnos`
--

LOCK TABLES `alumnos` WRITE;
/*!40000 ALTER TABLE `alumnos` DISABLE KEYS */;
INSERT INTO `alumnos` VALUES ('0273d6d9-d664-11','2345678901','Ana','Martínez',40),('0b584cfb-d664-11','A001','Luis','Sánchez',25),('4b2a6b37-d664-11','1234567890','Juan','Pérez',35);
/*!40000 ALTER TABLE `alumnos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calificaciones` (
  `id_calificacion` binary(16) NOT NULL,
  `id_inscripcion` binary(16) DEFAULT NULL,
  `calificacion_final` decimal(5,2) DEFAULT NULL,
  `fecha_calificacion` date DEFAULT NULL,
  PRIMARY KEY (`id_calificacion`),
  KEY `fk_inscripcion` (`id_inscripcion`),
  CONSTRAINT `fk_inscripcion` FOREIGN KEY (`id_inscripcion`) REFERENCES `inscripciones` (`id_inscripcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificaciones`
--

LOCK TABLES `calificaciones` WRITE;
/*!40000 ALTER TABLE `calificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `calificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripciones`
--

DROP TABLE IF EXISTS `inscripciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inscripciones` (
  `id_inscripcion` binary(16) NOT NULL,
  `id_alumno` binary(16) DEFAULT NULL,
  `id_materia` binary(16) DEFAULT NULL,
  `fecha_inscripcion` date DEFAULT NULL,
  `estado` enum('Activo','Inactivo') DEFAULT NULL CHECK (`estado` in ('Activo','Inactivo')),
  PRIMARY KEY (`id_inscripcion`),
  KEY `fk_alumno` (`id_alumno`),
  KEY `fk_materia` (`id_materia`),
  CONSTRAINT `fk_alumno` FOREIGN KEY (`id_alumno`) REFERENCES `alumnos` (`id_alumno`),
  CONSTRAINT `fk_materia` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones`
--

LOCK TABLES `inscripciones` WRITE;
/*!40000 ALTER TABLE `inscripciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materias` (
  `id_materia` binary(16) NOT NULL,
  `nombre_materia` varchar(100) DEFAULT NULL,
  `grupo_materia` int(11) DEFAULT NULL,
  `id_profesor` binary(16) DEFAULT NULL,
  `cupos` int(11) DEFAULT NULL CHECK (`cupos` >= 0),
  PRIMARY KEY (`id_materia`),
  UNIQUE KEY `nombre_materia` (`nombre_materia`,`grupo_materia`),
  KEY `fk_profesor` (`id_profesor`),
  CONSTRAINT `fk_profesor` FOREIGN KEY (`id_profesor`) REFERENCES `profesores` (`id_profesor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesores`
--

DROP TABLE IF EXISTS `profesores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profesores` (
  `id_profesor` binary(16) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `correo_electronico` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_profesor`),
  UNIQUE KEY `correo_electronico` (`correo_electronico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesores`
--

LOCK TABLES `profesores` WRITE;
/*!40000 ALTER TABLE `profesores` DISABLE KEYS */;
INSERT INTO `profesores` VALUES ('02729dba-d664-11','Pedro','García','pedro@example.com'),('0b574240-d664-11','Carlos','Hernández','carlos@example.com'),('4b2a27cf-d664-11','Maria','González','maria@example.com');
/*!40000 ALTER TABLE `profesores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-28 17:02:40
