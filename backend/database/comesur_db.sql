-- Autor: Alan Yael Fonseca Ruiz
drop database if exists comesur_db;
CREATE DATABASE IF NOT EXISTS comesur_db;
USE comesur_db;

-- Tabla Administrador
CREATE TABLE Administrador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    credencialesAdmin VARCHAR(255) NOT NULL
);

-- Tabla Usuario
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('Estudiante', 'Dueño') NOT NULL DEFAULT 'Estudiante'
);

-- Tabla Preferencia (Relación 1 a 1 con Usuario)
CREATE TABLE Preferencia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    tipoComida VARCHAR(50),
    presupuestoMaximo DECIMAL(10, 2),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla Negocio 
CREATE TABLE Negocio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dueno_id INT NOT NULL,
    admin_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipoComida VARCHAR(50),
    rangoPrecio VARCHAR(20),
    horarioApertura TIME,
    horarioCierre TIME,
    calificacionPromedio DECIMAL(3, 2) DEFAULT 0.00,
    direccion VARCHAR(255),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    menuDelDia TEXT,
    FOREIGN KEY (dueno_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES Administrador(id)
);

-- Tabla Producto (Relación 1 a muchos con Negocio)
CREATE TABLE Producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    negocio_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (negocio_id) REFERENCES Negocio(id) ON DELETE CASCADE
);

-- Tabla Reseña (Relación de Usuario hacia Negocio)
CREATE TABLE Resena (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    negocio_id INT NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (negocio_id) REFERENCES Negocio(id) ON DELETE CASCADE
);