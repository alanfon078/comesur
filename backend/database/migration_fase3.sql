-- Migración Fase 3: Social Features
-- Autor: Alan Yael Fonseca Ruiz

USE comesur_db;

-- 1. Agregar columnas OAuth a Usuario
ALTER TABLE Usuario
    ADD COLUMN IF NOT EXISTS google_id VARCHAR(255) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS facebook_id VARCHAR(255) DEFAULT NULL;

-- Índices únicos para IDs de OAuth (solo si no existen)
CREATE UNIQUE INDEX IF NOT EXISTS uk_usuario_google ON Usuario(google_id);
CREATE UNIQUE INDEX IF NOT EXISTS uk_usuario_facebook ON Usuario(facebook_id);

-- 2. Tabla Favorito (one per user per negocio)
CREATE TABLE IF NOT EXISTS Favorito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    negocio_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (negocio_id) REFERENCES Negocio(id) ON DELETE CASCADE,
    UNIQUE KEY uk_favorito (usuario_id, negocio_id),
    INDEX idx_favorito_usuario (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Restricción UNIQUE en Resena (un usuario, un negocio)
ALTER TABLE Resena
    ADD CONSTRAINT IF NOT EXISTS uk_resena UNIQUE (usuario_id, negocio_id);
