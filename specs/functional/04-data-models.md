# ComeSur - Modelos de Datos

## 1. Diagrama Entidad-Relación

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   USUARIO     │       │   NEGOCIO     │       │    COMIDA     │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id_usuario PK│◀──────│ id_negocio PK │       │ id_comida PK │
│ nombre       │       │ descripcion   │◀──────│ id_negocio FK │
│ correo       │       │ nombre_negocio│       │ nombre        │
│ password     │       │ direccion     │       │ descripcion   │
│ rol          │       │ categoria     │       │ precio        │
│ fecha_reg    │       │ calificacion  │       │ disponible    │
└──────┬───────┘       └──────┬───────┘       └──────────────┘
       │                        │                        │
       │                        │                        │
       │    ┌──────────────────┴──────────────────┐      │
       │    │                                     │      │
       ▼    ▼                                     │      ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   FAVORITO    │       │  MENU_DIARIO │       │ CALIFICACION │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id_favorito PK│       │ id_menu PK   │       │ id_cal PK    │
│ id_usuario FK │       │ id_negocio FK│       │ id_usuario FK│
│ id_negocio FK │       │ fecha        │       │ id_comida FK │
└──────────────┘       └──────┬───────┘       │ puntuacion   │
                             │                │ comentario   │
                             │                │ fecha        │
                             ▼                └──────────────┘
                      ┌──────────────┐
                      │ MENU_COMIDA   │
                      ├──────────────┤
                      │ id_menu_com PK│
                      │ id_menu FK   │
                      │ id_comida FK │
                      └──────────────┘
```

---

## 2. Entidad: Usuario

### Definición

```sql
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('estudiante', 'negocio', 'admin') DEFAULT 'estudiante',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_usuario | INT | PK, AUTO_INCREMENT | Identificador único |
| fecha_registro | DATETIME | DEFAULT NOW() | Fecha de registro |
| nombre | VARCHAR(100) | NOT NULL | Nombre completo |
| correo | VARCHAR(120) | NOT NULL, UNIQUE | Correo electrónico |
| password | VARCHAR(255) | NOT NULL | Contraseña hasheada |
| rol | ENUM | DEFAULT 'estudiante' | Rol del usuario |
| created_at | TIMESTAMP | AUTO | Fecha de creación |
| updated_at | TIMESTAMP | AUTO | Última modificación |

### Índices

| Índice | Campos | Tipo |
|--------|--------|------|
| idx_usuario_correo | correo | UNIQUE |
| idx_usuario_rol | rol | INDEX |

---

## 3. Entidad: Negocio

### Definición

```sql
CREATE TABLE Negocio (
    id_negocio INT PRIMARY KEY AUTO_INCREMENT,
    descripcion TEXT,
    id_propietario INT NOT NULL,
    nombre_negocio VARCHAR(120) NOT NULL,
    direccion VARCHAR(200),
    categoria VARCHAR(80),
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00,
    horario_apertura TIME,
    horario_cierre TIME,
    telefono VARCHAR(20),
    imagen_url VARCHAR(500),
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_propietario) REFERENCES Usuario(id_usuario)
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_negocio | INT | PK, AUTO_INCREMENT | Identificador único |
| descripcion | TEXT | NULL | Descripción del negocio |
| id_propietario | INT | NOT NULL, FK | Usuario dueño |
| nombre_negocio | VARCHAR(120) | NOT NULL | Nombre comercial |
| direccion | VARCHAR(200) | NULL | Dirección física |
| categoria | VARCHAR(80) | NULL | Tipo de comida |
| calificacion_promedio | DECIMAL(3,2) | DEFAULT 0.00 | Promedio calculado |
| horario_apertura | TIME | NULL | Hora de apertura |
| horario_cierre | TIME | NULL | Hora de cierre |
| telefono | VARCHAR(20) | NULL | Teléfono de contacto |
| imagen_url | VARCHAR(500) | NULL | URL de imagen |
| activo | BOOLEAN | DEFAULT TRUE | Negocio activo |

### Índices

| Índice | Campos | Tipo |
|--------|--------|------|
| idx_negocio_propietario | id_propietario | INDEX |
| idx_negocio_categoria | categoria | INDEX |
| idx_negocio_calificacion | calificacion_promedio | INDEX |

---

## 4. Entidad: Comida

### Definición

```sql
CREATE TABLE Comida (
    id_comida INT PRIMARY KEY AUTO_INCREMENT,
    id_negocio INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(8,2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    imagen_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) ON DELETE CASCADE
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_comida | INT | PK, AUTO_INCREMENT | Identificador único |
| id_negocio | INT | NOT NULL, FK | Negocio al que pertenece |
| nombre | VARCHAR(120) | NOT NULL | Nombre del platillo |
| descripcion | TEXT | NULL | Descripción del platillo |
| precio | DECIMAL(8,2) | NOT NULL | Precio en MXN |
| disponible | BOOLEAN | DEFAULT TRUE | Disponible para ordenar |
| imagen_url | VARCHAR(500) | NULL | URL de imagen |

### Índices

| Índice | Campos | Tipo |
|--------|--------|------|
| idx_comida_negocio | id_negocio | INDEX |
| idx_comida_precio | precio | INDEX |
| idx_comida_disponible | disponible | INDEX |

---

## 5. Entidad: Menu_Diario

### Definición

```sql
CREATE TABLE Menu_Diario (
    id_menu INT PRIMARY KEY AUTO_INCREMENT,
    id_negocio INT NOT NULL,
    fecha DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) ON DELETE CASCADE,
    UNIQUE KEY uk_menu_fecha (id_negocio, fecha)
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_menu | INT | PK, AUTO_INCREMENT | Identificador único |
| id_negocio | INT | NOT NULL, FK | Negocio dueño |
| fecha | DATE | NOT NULL | Fecha del menú |
| created_at | TIMESTAMP | AUTO | Fecha de creación |

---

## 6. Entidad: Menu_Comida

### Definición

```sql
CREATE TABLE Menu_Comida (
    id_menu_comida INT PRIMARY KEY AUTO_INCREMENT,
    id_menu INT NOT NULL,
    id_comida INT NOT NULL,
    FOREIGN KEY (id_menu) REFERENCES Menu_Diario(id_menu) ON DELETE CASCADE,
    FOREIGN KEY (id_comida) REFERENCES Comida(id_comida) ON DELETE CASCADE,
    UNIQUE KEY uk_menu_comida (id_menu, id_comida)
);
```

---

## 7. Entidad: Favorito

### Definición

```sql
CREATE TABLE Favorito (
    id_favorito INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_negocio INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_negocio) REFERENCES Negocio(id_negocio) ON DELETE CASCADE,
    UNIQUE KEY uk_favorito (id_usuario, id_negocio)
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_favorito | INT | PK, AUTO_INCREMENT | Identificador único |
| id_usuario | INT | NOT NULL, FK | Usuario que favorió |
| id_negocio | INT | NOT NULL, FK | Negocio favoritado |
| created_at | TIMESTAMP | AUTO | Fecha de creación |

---

## 8. Entidad: Calificacion

### Definición

```sql
CREATE TABLE Calificacion (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_comida INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_comida) REFERENCES Comida(id_comida) ON DELETE CASCADE,
    UNIQUE KEY uk_calificacion (id_usuario, id_comida)
);
```

### Atributos

| Campo | Tipo | Constraints | Descripción |
|-------|------|-------------|-------------|
| id_calificacion | INT | PK, AUTO_INCREMENT | Identificador único |
| id_usuario | INT | NOT NULL, FK | Usuario que califica |
| id_comida | INT | NOT NULL, FK | Comida calificada |
| puntuacion | INT | NOT NULL, 1-5 | Puntuación en estrellas |
| comentario | TEXT | NULL | Comentario opcional |
| fecha | DATETIME | AUTO | Fecha de calificación |

---

## 9. Triggers y Procedimientos

### Trigger: Actualizar calificación promedio

```sql
DELIMITER //

CREATE TRIGGER tr_update_calificacion_negocio
AFTER INSERT ON Calificacion
FOR EACH ROW
BEGIN
    UPDATE Negocio n
    JOIN Comida c ON c.id_negocio = n.id_negocio
    SET n.calificacion_promedio = (
        SELECT AVG(c2.puntuacion)
        FROM Calificacion c2
        JOIN Comida c3 ON c2.id_comida = c3.id_comida
        WHERE c3.id_negocio = n.id_negocio
    )
    WHERE c.id_comida = NEW.id_comida;
END //

DELIMITER ;
```

---

## 10. Consultas Comunes

### Buscar comida con filtros

```sql
SELECT 
    com.nombre AS platillo,
    com.precio,
    neg.nombre_negocio AS negocio,
    neg.calificacion_promedio
FROM Comida com
JOIN Negocio neg ON com.id_negocio = neg.id_negocio
WHERE com.disponible = TRUE
    AND neg.activo = TRUE
    AND neg.categoria LIKE CONCAT('%', ?, '%')
    AND com.precio <= ?
ORDER BY neg.calificacion_promedio DESC;
```

### Obtener favoritos de usuario

```sql
SELECT 
    neg.*,
    com.nombre AS ultimo_platillo
FROM Favorito fav
JOIN Negocio neg ON fav.id_negocio = neg.id_negocio
LEFT JOIN Comida com ON com.id_negocio = neg.id_negocio AND com.disponible = TRUE
WHERE fav.id_usuario = ?
ORDER BY fav.created_at DESC;
```

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
