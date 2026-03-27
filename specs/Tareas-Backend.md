# ComeSur - Tareas de Backend

## Tabla de Contenido
1. [Información General](#información-general)
2. [Fase 1: Foundation](#fase-1-foundation)
3. [Fase 2: Core Discovery](#fase-2-core-discovery)
4. [Fase 3: Social Features](#fase-3-social-features)
5. [Fase 4: Business Tools](#fase-4-business-tools)
6. [Endpoints por Implementar](#endpoints-por-implementar)
7. [Base de Datos](#base-de-datos)
8. [Seguridad](#seguridad)

---

## Información General

| Campo | Detalle |
|-------|---------|
| **Tecnología** | Node.js v20, Express 5.0 |
| **Base de Datos** | MySQL 8.0 |
| **Autenticación** | JWT + bcrypt |
| **Estado Actual** | Fase 1 completada |

---

## Fase 1: Foundation (Completada ✅)

### 1.1 Configuración del Proyecto
- [x] Inicializar proyecto Node.js
- [x] Configurar package.json y dependencias
- [x] Instalar express, mysql2, bcrypt, jsonwebtoken
- [x] Configurar estructura de carpetas MVC

### 1.2 Servidor Básico
- [x] Crear server.js con Express
- [x] Configurar middleware JSON
- [x] Configurar CORS
- [x] Crear conexión a MySQL

### 1.3 Endpoints de Autenticación
- [x] POST /auth/login - Iniciar sesión
- [x] Validar credenciales con bcrypt
- [x] Generar JWT token
- [x] Validar formato de correo
- [x] Validar contraseña mínima 8 caracteres

### 1.4 Endpoints de Negocios
- [x] GET /negocios/filtrar - Buscar con filtros
- [x] Parámetro tipoComida (opcional)
- [x] Parámetro presupuesto (opcional)
- [x] Ordenar por calificación descendente
- [x] Generar datos mock para pruebas

---

## Fase 2: Core Discovery (En Desarrollo 🔄)

### 2.1 Detalle de Negocio
- [ ] GET /negocios/:id
- [ ] Retornar: nombre, descripción, dirección, categoría
- [ ] Retornar: horario apertura/cierre, teléfono
- [ ] Retornar: menú completo (tabla Comida)
- [ ] Retornar: calificación promedio y total

### 2.2 Manejo de Errores
- [ ] Middleware de manejo de errores centralizado
- [ ] Códigos de error estructurados
- [ ] Logging con Winston
- [ ] Integración con Sentry
- [ ] Retry automático para requests fallidas

### 2.3 Validaciones
- [ ] Validar parámetros de entrada
- [ ] Sanitización server-side
- [ ] Rate limiting por endpoint

---

## Fase 3: Social Features (Planificado 📋)

### 3.1 Sistema de Favoritos

#### Endpoints REST
- [ ] GET /favoritos - Obtener favoritos del usuario
- [ ] POST /favoritos - Agregar negocio a favoritos
- [ ] DELETE /favoritos/:idNegocio - Quitar de favoritos

#### Lógica de Negocio
- [ ] Validar que el negocio exista
- [ ] Verificar que usuario no tenga ya el favorito
- [ ] Retornar error si no existe el favorito al eliminar

### 3.2 Sistema de Calificaciones

#### Endpoints REST
- [ ] POST /calificaciones - Crear calificación
- [ ] GET /calificaciones/:idComida - Obtener calificaciones
- [ ] PUT /calificaciones/:id - Editar calificación
- [ ] DELETE /calificaciones/:id - Eliminar calificación

#### Lógica de Negocio
- [ ] Validar puntuación 1-5
- [ ] Una calificación por usuario por comida
- [ ] Calcular promedio automáticamente
- [ ] Actualizar rating del negocio

### 3.3 Perfil de Usuario
- [ ] GET /usuarios/perfil - Obtener datos del usuario
- [ ] PUT /usuarios/perfil - Actualizar perfil
- [ ] GET /usuarios/historial - Obtener historial de calificaciones
- [ ] POST /auth/logout - Cerrar sesión

### 3.4 Autenticación OAuth
- [ ] POST /auth/register - Registrar nuevo usuario
- [ ] POST /auth/google - Login con Google
- [ ] POST /auth/facebook - Login con Facebook

---

## Fase 4: Business Tools (Planificado 📋)

### 4.1 Gestión de Menú

#### Endpoints REST
- [ ] POST /menu/platillos - Agregar platillo
- [ ] PUT /menu/platillos/:id - Editar platillo
- [ ] DELETE /menu/platillos/:id - Eliminar platillo
- [ ] PATCH /menu/platillos/:id/disponible - Cambiar disponibilidad

#### Lógica de Negocio
- [ ] Validar que el usuario sea owner del negocio
- [ ] Validar datos del platillo (nombre, precio > 0)

### 4.2 Dashboard de Negocios

#### Endpoints REST
- [ ] GET /negocios/:id/estadisticas - Obtener estadísticas
- [ ] GET /negocios/:id/visitas - Obtener historial de visitas

#### Métricas a Retornar
- [ ] Número de vistas del negocio
- [ ] Número de favoritos
- [ ] Calificación promedio
- [ ] Cantidad de calificaciones
- [ ] Tendencias de visitas (últimos 7 días)

### 4.3 Gestión de Negocio

#### Endpoints REST
- [ ] POST /negocios - Crear negocio
- [ ] PUT /negocios/:id - Actualizar negocio
- [ ] DELETE /negocios/:id - Eliminar negocio
- [ ] POST /negocios/:id/imagenes - Subir imágenes

### 4.4 Menú Diario

#### Endpoints REST
- [ ] POST /menu-diario - Crear menú del día
- [ ] GET /menu-diario/:idNegocio - Ver menú del día
- [ ] PUT /menu-diario/:id - Actualizar menú diario
- [ ] POST /menu-diario/:id/platillos - Agregar platillos al menú

---

## Endpoints por Implementar

### Autenticación (Auth)

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| POST | /auth/login | ✅ | Alta |
| POST | /auth/register | 📋 | Alta |
| POST | /auth/logout | 📋 | Alta |
| POST | /auth/google | 📋 | Media |
| POST | /auth/facebook | 📋 | Baja |
| POST | /auth/refresh | 📋 | Media |

### Negocios

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| GET | /negocios/filtrar | ✅ | Alta |
| GET | /negocios/:id | 🔄 | Alta |
| POST | /negocios | 📋 | Media |
| PUT | /negocios/:id | 📋 | Media |
| DELETE | /negocios/:id | 📋 | Baja |
| GET | /negocios/:id/estadisticas | 📋 | Media |

### Favoritos

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| GET | /favoritos | 📋 | Alta |
| POST | /favoritos | 📋 | Alta |
| DELETE | /favoritos/:idNegocio | 📋 | Alta |

### Calificaciones

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| POST | /calificaciones | 📋 | Alta |
| GET | /calificaciones/:idComida | 📋 | Alta |
| PUT | /calificaciones/:id | 📋 | Baja |
| DELETE | /calificaciones/:id | 📋 | Baja |

### Menú

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| POST | /menu/platillos | 📋 | Alta |
| PUT | /menu/platillos/:id | 📋 | Alta |
| DELETE | /menu/platillos/:id | 📋 | Alta |
| PATCH | /menu/platillos/:id/disponible | 📋 | Media |
| POST | /menu-diario | 📋 | Media |
| GET | /menu-diario/:idNegocio | 📋 | Media |

### Usuarios

| Método | Endpoint | Estado | Prioridad |
|--------|----------|--------|-----------|
| GET | /usuarios/perfil | 📋 | Media |
| PUT | /usuarios/perfil | 📋 | Media |
| GET | /usuarios/historial | 📋 | Baja |

---

## Base de Datos

### Tablas Existentes
- [x] Usuario
- [x] Negocio
- [x] Comida

### Tablas por Crear
- [ ] Favorito
- [ ] Calificacion
- [ ] Menu_Diario
- [ ] Menu_Comida

### Vistas
- [x] v_NegociosConCalificacion (existente)

### Procedimientos Almacenados
- [x] sp_filtrar_comida (existente)
- [ ] sp_actualizar_calificacion_negocio

### Índices
- [x] idx_comida_filtros
- [x] idx_negocio_categoria_activo
- [ ] idx_favoritos_usuario
- [ ] idx_calificaciones_recientes

---

## Seguridad

### Configuración Actual
- [x] JWT tokens
- [x] bcrypt para contraseñas

### Por Implementar
- [ ] Rate limiting (express-rate-limit)
- [ ] Helmet.js para headers seguros
- [ ] Validación con Joi/Zod
- [ ] HTTPS/TLS 1.2+
- [ ] Sanitización de inputs
- [ ] CORS configurado correctamente

### Rate Limits por Endpoint

| Endpoint | Límite | Ventana |
|----------|--------|---------|
| /auth/* | 10 req | 1 minuto |
| /negocios/filtrar | 30 req | 1 minuto |
| /negocios/* | 100 req | 1 minuto |
| /favoritos/* | 50 req | 1 minuto |
| /calificaciones/* | 20 req | 1 minuto |

---

## Logging y Monitoreo

### Winston
- [x] Configuración básica
- [ ] Logs de errores
- [ ] Logs de acceso
- [ ] Rotación de logs

### Sentry
- [ ] Integración con Express
- [ ] Tracking de errores
- [ ] Captura de contexto

---

## Símbolos de Estado

| Símbolo | Significado |
|---------|-------------|
| ✅ | Completado |
| 🔄 | En desarrollo |
| 📋 | Planificado |

---

*Documento generado: 2026-03-26*
*Versión: 1.0*