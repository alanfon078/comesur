# ComeSur - Esquema de Base de Datos

## 1. Diagrama de Entidad-Relación

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  USUARIO    │     │   NEGOCIO   │     │   COMIDA    │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ PK id_usuario│◀───│ PK id_negocio│    │ PK id_comida│
│ nombre       │     │ FK id_propietario│◀───│ FK id_negocio│
│ correo       │     │ nombre_negocio  │     │ nombre       │
│ password     │     │ direccion       │     │ precio      │
│ rol          │     │ categoria       │     │ disponible   │
└──────┬──────┘     └──────┬──────┘     └─────────────┘
       │                    │
       │         ┌─────────┴─────────┐
       │         │                   │
       ▼         ▼                   ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  FAVORITO   │ │ MENU_DIARIO │ │CALIFICACION │
├─────────────┤ ├─────────────┤ ├─────────────┤
│ PK id_favorito││ PK id_menu │ │PK id_cal │
│ FK id_usuario ││FK id_negocio│ │FK id_usuario│
│ FK id_negocio ││ fecha      │ │FK id_comida │
└─────────────┘ └──────┬──────┘ └─────────────┘
                        │
                        ▼
                 ┌─────────────┐
                 │ MENU_COMIDA │
                 ├─────────────┤
                 │PK id_menu_com│
                 │FK id_menu   │
                 │FK id_comida │
                 └─────────────┘
```

---

## 2. Creación de Tablas

### Tabla: Usuario

```sql
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('estudiante', 'negocio', 'admin') NOT NULL DEFAULT 'estudiante',
    imagen_url VARCHAR(500) DEFAULT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    activo BOOLEAN DEFAULT TRUE,
    ultimo_login DATETIME DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_usuario_correo (correo),
    INDEX idx_usuario_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Negocio

```sql
CREATE TABLE Negocio (
    id_negocio INT PRIMARY KEY AUTO_INCREMENT,
    id_propietario INT NOT NULL,
    nombre_negocio VARCHAR(120) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(200),
    categoria VARCHAR(80),
    latitud DECIMAL(10, 8) DEFAULT NULL,
    longitud DECIMAL(11, 8) DEFAULT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    email VARCHAR(120) DEFAULT NULL,
    horario_apertura TIME DEFAULT NULL,
    horario_cierre TIME DEFAULT NULL,
    dias_laborales VARCHAR(20) DEFAULT 'Lun-Dom',
    calificacion_promedio DECIMAL(3, 2) DEFAULT 0.00,
    total_calificaciones INT DEFAULT 0,
    imagen_url VARCHAR(500) DEFAULT NULL,
    activo BOOLEAN DEFAULT TRUE,
    verificado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_negocio_propietario 
        FOREIGN KEY (id_propietario) REFERENCES Usuario(id_usuario) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_negocio_propietario (id_propietario),
    INDEX idx_negocio_categoria (categoria),
    INDEX idx_negocio_calificacion (calificacion_promedio DESC),
    INDEX idx_negocio_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Comida

```sql
CREATE TABLE Comida (
    id_comida INT PRIMARY KEY AUTO_INCREMENT,
    id_negocio INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(8, 2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    imagen_url VARCHAR(500) DEFAULT NULL,
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_comida_negocio 
        FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    INDEX idx_comida_negocio (id_negocio),
    INDEX idx_comida_precio (precio),
    INDEX idx_comida_disponible (disponible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Menu_Diario

```sql
CREATE TABLE Menu_Diario (
    id_menu INT PRIMARY KEY AUTO_INCREMENT,
    id_negocio INT NOT NULL,
    fecha DATE NOT NULL,
    titulo VARCHAR(200) DEFAULT NULL,
    descripcion TEXT DEFAULT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_menu_negocio 
        FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    UNIQUE KEY uk_menu_fecha (id_negocio, fecha),
    INDEX idx_menu_fecha (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Menu_Comida

```sql
CREATE TABLE Menu_Comida (
    id_menu_comida INT PRIMARY KEY AUTO_INCREMENT,
    id_menu INT NOT NULL,
    id_comida INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_menu_comida_menu 
        FOREIGN KEY (id_menu) REFERENCES Menu_Diario(id_menu) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_menu_comida_comida 
        FOREIGN KEY (id_comida) REFERENCES Comida(id_comida) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    UNIQUE KEY uk_menu_comida (id_menu, id_comida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Favorito

```sql
CREATE TABLE Favorito (
    id_favorito INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_negocio INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_favorito_usuario 
        FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_negocio 
        FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    UNIQUE KEY uk_favorito (id_usuario, id_negocio),
    INDEX idx_favorito_usuario (id_usuario),
    INDEX idx_favorito_negocio (id_negocio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

### Tabla: Calificacion

```sql
CREATE TABLE Calificacion (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_comida INT NOT NULL,
    puntuacion TINYINT NOT NULL,
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    edited_at DATETIME DEFAULT NULL,
    activo BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_calificacion_usuario 
        FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_calificacion_comida 
        FOREIGN KEY (id_comida) REFERENCES Comida(id_comida) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 5),
    
    UNIQUE KEY uk_calificacion (id_usuario, id_comida),
    INDEX idx_calificacion_comida (id_comida),
    INDEX idx_calificacion_fecha (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 3. Vistas Materializadas

### Vista: Negocios con Calificación

```sql
CREATE VIEW v_NegociosConCalificacion AS
SELECT 
    n.id_negocio,
    n.nombre_negocio,
    n.descripcion,
    n.direccion,
    n.categoria,
    n.calificacion_promedio,
    n.total_calificaciones,
    n.imagen_url,
    COUNT(DISTINCT c.id_comida) AS total_platillos,
    MIN(c.precio) AS precio_minimo,
    MAX(c.precio) AS precio_maximo
FROM Negocio n
LEFT JOIN Comida c ON n.id_negocio = c.id_negocio AND c.disponible = TRUE
WHERE n.activo = TRUE
GROUP BY n.id_negocio;
```

---

## 4. Procedimientos Almacenados

### SP: Filtrar Comida

```sql
DELIMITER //

CREATE PROCEDURE sp_filtrar_comida(
    IN p_tipo_comida VARCHAR(100),
    IN p_presupuesto DECIMAL(8,2)
)
BEGIN
    SET @query = '
        SELECT 
            c.id_comida,
            c.nombre AS platillo,
            c.precio,
            n.id_negocio,
            n.nombre_negocio AS negocio,
            n.calificacion_promedio,
            n.direccion
        FROM Comida c
        INNER JOIN Negocio n ON c.id_negocio = n.id_negocio
        WHERE c.disponible = TRUE
        AND n.activo = TRUE
    ';
    
    IF p_tipo_comida IS NOT NULL AND p_tipo_comida != '' THEN
        SET @query = CONCAT(@query, ' AND n.categoria LIKE "%', p_tipo_comida, '%"');
    END IF;
    
    IF p_presupuesto IS NOT NULL AND p_presupuesto > 0 THEN
        SET @query = CONCAT(@query, ' AND c.precio <= ', p_presupuesto);
    END IF;
    
    SET @query = CONCAT(@query, ' ORDER BY n.calificacion_promedio DESC');
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;
```

---

### SP: Actualizar Calificación Promedio

```sql
DELIMITER //

CREATE PROCEDURE sp_actualizar_calificacion_negocio(
    IN p_id_negocio INT
)
BEGIN
    UPDATE Negocio n
    SET n.calificacion_promedio = (
        SELECT COALESCE(AVG(c.puntuacion), 0)
        FROM Calificacion c
        INNER JOIN Comida co ON c.id_comida = co.id_comida
        WHERE co.id_negocio = p_id_negocio
        AND c.activo = TRUE
    ),
    n.total_calificaciones = (
        SELECT COUNT(*)
        FROM Calificacion c
        INNER JOIN Comida co ON c.id_comida = co.id_comida
        WHERE co.id_negocio = p_id_negocio
        AND c.activo = TRUE
    )
    WHERE n.id_negocio = p_id_negocio;
END //

DELIMITER ;
```

---

## 5. Índices para Optimización

### Consultas Frecuentes

```sql
-- Búsqueda de comida con filtros
CREATE INDEX idx_comida_filtros ON Comida(id_negocio, disponible, precio);

-- Lista de favoritos
CREATE INDEX idx_favoritos_usuario ON Favorito(id_usuario, created_at DESC);

-- Calificaciones recientes
CREATE INDEX idx_calificaciones_recientes ON Calificacion(id_comida, fecha DESC);

-- Búsqueda por categoría
CREATE INDEX idx_negocio_categoria_activo ON Negocio(categoria, activo, calificacion_promedio DESC);
```

---

## 6. Datos de Prueba (Seed)

```sql
-- Insertar usuario de prueba
INSERT INTO Usuario (nombre, correo, password, rol) VALUES
('Juan Pérez', 'juan@test.com', '$2b$10$...', 'estudiante'),
('María García', 'maria@test.com', '$2b$10$...', 'estudiante'),
('La Casa del Burger', 'lahouse@negocio.com', '$2b$10$...', 'negocio');

-- Insertar negocios de prueba
INSERT INTO Negocio (id_propietario, nombre_negocio, descripcion, direccion, categoria, calificacion_promedio) VALUES
(3, 'La Casa del Burger', 'Las mejores hamburguesas artesanales', 'Av. Universidad #123', 'Hamburguesas', 4.50),
(3, 'Tacos El Güero', 'Tacos de la mejor calidad', 'Calle 5 de Mayo #45', 'Tacos', 4.20),
(3, 'Pizzas Express', 'Pizzas artesanales en 15 minutos', 'Blvd. Central #78', 'Pizza', 4.80);

-- Insertar comidas de prueba
INSERT INTO Comida (id_negocio, nombre, descripcion, precio, disponible) VALUES
(1, 'Hamburguesa Clásica', 'Doble carne, queso cheddar, jitomate, lechuga', 85.00, TRUE),
(1, 'Hamburguesa Doble', 'Doble carne, doble queso, tocino', 110.00, TRUE),
(2, 'Tacos de Asada', '3 tacos de res asada con cebolla y cilantro', 60.00, TRUE),
(2, 'Tacos Al Pastor', '3 tacos de cerdo adobado', 55.00, TRUE),
(3, 'Pizza Margarita', 'Salsa de tomate, mozzarella, albahaca', 120.00, TRUE);
```

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
