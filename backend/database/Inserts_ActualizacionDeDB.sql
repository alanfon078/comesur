use comesur_db;

select * from usuario;
select * from producto;
select * from resena;
select * from negocio;
-- ==========================================
-- 1. Administradores (2 registros)
-- ==========================================
INSERT INTO Administrador (credencialesAdmin) VALUES
('hash_admin_001_xyz'),
('hash_admin_002_abc');

-- ==========================================
-- 2. Usuarios (10 registros)
-- Incluye campos de Fase 3: google_id, facebook_id
-- ==========================================
INSERT INTO Usuario (nombre, correo, contrasena, rol, google_id, facebook_id) VALUES
('Alan Yael', 'alan@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Dueño', 'g_123', NULL),
('Erik Jesús Ramírez Díaz', 'erik@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', NULL, 'fb_123'),
('Zaid Jared Cerna Durán', 'zaid@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', 'g_456', NULL),
('Junior H', 'junior@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', NULL, NULL),
('Dueño Tacos', 'tacos@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Dueño', 'g_789', 'fb_789'),
('Dueño Carnes', 'carnes@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Dueño', NULL, NULL),
('Estudiante 1', 'est1@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', 'g_111', NULL),
('Estudiante 2', 'est2@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', NULL, 'fb_222'),
('Dueño Cafetería', 'cafe@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Dueño', 'g_333', NULL),
('Estudiante 3', 'est3@correo.com', '$2b$10$um0uWvltWg/8rtyD3uQsquGKHK7oKLv9Y8j1hjQr.Tr58h6B2/lq.', 'Estudiante', NULL, NULL);

-- ==========================================
-- 3. Preferencias (5 registros)
-- ==========================================
INSERT INTO Preferencia (usuario_id, tipoComida, presupuestoMaximo) VALUES
(2, 'Carnes', 200.00),
(3, 'Tacos', 120.50),
(4, 'Comida Rápida', 300.00),
(7, 'Desayunos', 80.00),
(8, 'Pizza', 150.00);

-- ==========================================
-- 4. Negocios (4 registros)
-- Incluye campo de Fase 4: totalVistas
-- ==========================================
INSERT INTO Negocio (dueno_id, admin_id, nombre, descripcion, tipoComida, rangoPrecio, horarioApertura, horarioCierre, calificacionPromedio, direccion, latitud, longitud, menuDelDia, totalVistas) VALUES
(1, 1, 'Protein Factory', 'Comida con altos macros para el gimnasio.', 'Saludable', '$$', '08:00:00', '20:00:00', 4.8, 'Cerca de la entrada principal', 19.4326, -99.1332, '1,2', 150),
(5, 1, 'Tacos El Inge', 'Los mejores tacos para después de clases.', 'Tacos', '$', '10:00:00', '22:00:00', 4.5, 'Av. Universidad 123', 19.4330, -99.1340, '5,6', 85),
(6, 2, 'Carnes Asadas El Norteño', 'Cortes de carne de primera.', 'Carnes', '$$$', '13:00:00', '23:00:00', 4.9, 'Plaza Estudiantil', 19.4350, -99.1350, '7,8', 230),
(9, 2, 'Cafetería Central', 'Desayunos y energía para programar.', 'Cafetería', '$', '07:00:00', '18:00:00', 4.2, 'Edificio A', 19.4310, -99.1310, '9,10', 500);

INSERT INTO Negocio (dueno_id, admin_id, nombre, descripcion, tipoComida, rangoPrecio, horarioApertura, horarioCierre, calificacionPromedio, direccion, latitud, longitud, menuDelDia, totalVistas) VALUES
(1, 1, 'Cafeteria ITSUR', 'Comida con variedad disponible', 'Variado', '$', '08:00:00', '16:00:00', 3.8, 'Avenida Educación Superior 2000', 20.1225,  -101.1642, '1,2', 200);

-- ==========================================
-- 5. Productos (10 registros)
-- ==========================================
INSERT INTO Producto (negocio_id, nombre, descripcion, precio, disponible) VALUES
(1, 'Pechuga de Pollo a la Plancha', '250g de pechuga magra con porción de arroz blanco.', 85.00, TRUE),
(1, 'Batido Gold Standard Whey', 'Licuado de proteína de suero de leche sabor chocolate.', 60.00, TRUE),
(1, 'Batido Mutant Whey', 'Licuado alto en calorías, ideal para etapa de volumen.', 70.00, TRUE),
(1, 'Monster Zero Sugar', 'Lata bien fría de 473ml para máxima energía en proyectos.', 45.00, TRUE),
(2, 'Tacos de Bistec', 'Orden de 5 tacos con doble tortilla.', 60.00, TRUE),
(2, 'Quesadilla con Carne', 'Tortilla de harina con queso fundido y carne asada.', 40.00, TRUE),
(3, 'Corte Ribeye 300g', 'Corte jugoso acompañado de ensalada fresca.', 250.00, TRUE),
(3, 'Arrachera Marinada', 'Arrachera suave acompañada con papas al horno.', 180.00, TRUE),
(4, 'Café Americano Grande', 'Café de grano recién colado.', 25.00, TRUE),
(4, 'Chilaquiles Rojos con Pollo', 'Chilaquiles crujientes con pechuga deshebrada.', 55.00, TRUE);

INSERT INTO Producto (negocio_id, nombre, descripcion, precio, disponible) VALUES
(5, 'Gringa Grande', 'Gringa grande de torilla de harina con carne a seleccionar', 60.00, TRUE),
(5, 'Hamburguesa doble', 'Hamburguesa tradicional con doble carne', 60.00, TRUE);

update Negocio
set direccion = 'Avenida Educación Superior 2000, Colonia Benito Juárez, C.P. 38982'
where id = 5;

update Negocio
set longitud = -101.1514187741462
where id = 5;

update Negocio
set latitud = 20.138706473241008
where id = 5;


ALTER TABLE Negocio MODIFY latitud DECIMAL(10, 8);
ALTER TABLE Negocio MODIFY longitud DECIMAL(11, 8);


-- ==========================================
-- 6. Favoritos (5 registros - Fase 3)
-- ==========================================
INSERT INTO Favorito (usuario_id, negocio_id) VALUES
(2, 1),
(2, 3),
(3, 2),
(4, 1),
(7, 4);

-- ==========================================
-- 7. Reseñas (6 registros)
-- Respeta la restricción UNIQUE(usuario_id, negocio_id) de Fase 3
-- ==========================================
INSERT INTO Resena (usuario_id, negocio_id, calificacion, comentario) VALUES
(2, 1, 5, 'Excelente cantidad de proteína, perfecto para cerrar el entreno.'),
(3, 2, 4, 'Muy buenos tacos para cenar, aunque cerraron temprano hoy.'),
(4, 1, 5, 'La bebida energética fría salva las entregas de ICPC.'),
(7, 4, 4, 'Buen café, ideal para las mañanas de clases.'),
(8, 3, 5, 'La arrachera está increíblemente suave.'),
(2, 3, 5, 'Muy buena carne asada, excelentes macros para la dieta.');