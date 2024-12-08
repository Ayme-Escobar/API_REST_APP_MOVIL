-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 08-12-2024 a las 05:30:21
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `usuario_bdd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `correo`, `contrasena`, `fecha_creacion`) VALUES
(1, 'Aymé', 'ayme2@gmail.com', '$2y$10$CjbeQDwWwSSo7w6yx21sOOnD1aSVHj4E0eCDyEBg7NHSrIbwZi8b2', '2024-12-07 21:16:20'),
(9, 'Richard', 'richard1@gmail.com', '$2y$10$L2E5b2NMM44Uxspw5iggruqV7fcrVmukWNQRKB5R2xk7h590/kGSK', '2024-12-07 22:29:45'),
(10, 'Camila', 'camila@hotmail.com', '$2y$10$RjRf1edHZeScvZXj25PEtOsAMKxYHu7ciSFzB10pVEgDZJJP73.9O', '2024-12-07 22:29:59'),
(11, 'Gerald', 'geraldconstantine@gmail.com', '$2y$10$je2ddped0eu5C8o298XbtOD8h7JFqMcIounA.Z//qCWrTxL5M4a3a', '2024-12-07 22:30:17'),
(19, 'Mia', 'mia21@gmail.com', '$2y$10$DHKXqWzOJWpABPthzyG.2u1wEXroVcSsh0ApEEdDVQhtBrMEhhgXG', '2024-12-08 03:12:37'),
(20, 'Rachel', 'rachel@gmail.com', '$2y$10$0v7JrqmMQ6eWKNHRWB2xoeMBaOvQ5OKEK6rYX3tGBIGD29WRL75Ny', '2024-12-08 03:16:38');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
