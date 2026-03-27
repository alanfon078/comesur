# ComeSur - Especificación de API REST

## 1. Información General

### Base URL

| Entorno | URL Base |
|---------|----------|
| Desarrollo | `http://localhost:3000/api` |
| Staging | `https://api-staging.comesur.app/api` |
| Producción | `https://api.comesur.app/api` |

### Autenticación

```
Authorization: Bearer <jwt_token>
```

### Formato de Respuesta

```json
// Éxito
{
    "success": true,
    "data": { ... },
    "meta": { ... }
}

// Error
{
    "success": false,
    "error": {
        "message": "Descripción del error",
        "code": "ERROR_CODE"
    }
}
```

### Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Respuesta exitosa |
| 201 | Created | Recurso creado |
| 400 | Bad Request | Validación fallida |
| 401 | Unauthorized | No autenticado |
| 403 | Forbidden | No autorizado |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto de datos |
| 429 | Too Many Requests | Rate limit excedido |
| 500 | Internal Server Error | Error del servidor |

---

## 2. Endpoints de Autenticación

### POST /auth/register

Registrar un nuevo usuario.

**Request:**
```json
{
    "nombre": "Juan Pérez",
    "correo": "juan@email.com",
    "password": "securePassword123"
}
```

**Response (201):**
```json
{
    "success": true,
    "data": {
        "user": {
            "id_usuario": 1,
            "nombre": "Juan Pérez",
            "correo": "juan@email.com",
            "rol": "estudiante"
        },
        "token": "eyJhbGciOiJIUzI1NiIs..."
    }
}
```

**Errores:**
- `400`: Datos inválidos
- `409`: Correo ya registrado

---

### POST /auth/login

Iniciar sesión.

**Request:**
```json
{
    "correo": "juan@email.com",
    "password": "securePassword123"
}
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "user": {
            "id_usuario": 1,
            "nombre": "Juan Pérez",
            "correo": "juan@email.com",
            "rol": "estudiante"
        },
        "token": "eyJhbGciOiJIUzI1NiIs..."
    }
}
```

**Errores:**
- `401`: Credenciales inválidas

---

### POST /auth/logout

Cerrar sesión.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
    "success": true,
    "message": "Sesión cerrada exitosamente"
}
```

---

## 3. Endpoints de Negocios

### GET /negocios/filtrar

Buscar negocios con filtros.

**Query Parameters:**

| Parámetro | Tipo | Requerido | Descripción |
|------------|------|-----------|-------------|
| tipoComida | string | No | Tipo/categoría de comida |
| presupuesto | number | No | Precio máximo |

**Ejemplo:**
```
GET /api/negocios/filtrar?tipoComida=hamburguesa&presupuesto=100
```

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "platillo": "Hamburguesa Clásica",
            "precio": 85.00,
            "negocio": "La Casa del Burger",
            "calificacionPromedio": 4.5
        },
        {
            "platillo": "Hamburguesa Doble",
            "precio": 95.00,
            "negocio": "La Casa del Burger",
            "calificacionPromedio": 4.5
        }
    ],
    "meta": {
        "total": 2,
        "timestamp": "2026-03-25T12:00:00Z"
    }
}
```

**Errores:**
- `400`: Parámetros inválidos
- `404`: Sin resultados
- `429`: Rate limit excedido

---

### GET /negocios/:id

Obtener detalle de un negocio.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
    "success": true,
    "data": {
        "id_negocio": 1,
        "nombre_negocio": "La Casa del Burger",
        "descripcion": "Las mejores hamburguesas del sur",
        "direccion": "Av. Universidad #123",
        "categoria": "Hamburguesas",
        "calificacion_promedio": 4.5,
        "horario_apertura": "08:00:00",
        "horario_cierre": "22:00:00",
        "telefono": "55-1234-5678",
        "menu": [
            {
                "id_comida": 1,
                "nombre": "Hamburguesa Clásica",
                "descripcion": "Doble carne, queso cheddar",
                "precio": 85.00,
                "disponible": true
            }
        ]
    }
}
```

---

### GET /negocios (futuro)

Listar todos los negocios.

**Query Parameters:**

| Parámetro | Tipo | Default | Descripción |
|------------|------|---------|-------------|
| page | number | 1 | Número de página |
| limit | number | 20 | Elementos por página |
| categoria | string | null | Filtrar por categoría |

---

## 4. Endpoints de Favoritos (futuro)

### GET /favoritos

Obtener favoritos del usuario.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
    "success": true,
    "data": [
        {
            "id_favorito": 1,
            "negocio": {
                "id_negocio": 1,
                "nombre_negocio": "La Casa del Burger",
                "calificacion_promedio": 4.5
            },
            "created_at": "2026-03-25T10:00:00Z"
        }
    ]
}
```

---

### POST /favoritos

Agregar negocio a favoritos.

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
    "id_negocio": 1
}
```

**Response (201):**
```json
{
    "success": true,
    "data": {
        "id_favorito": 1,
        "id_negocio": 1
    }
}
```

---

### DELETE /favoritos/:idNegocio

Quitar negocio de favoritos.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
    "success": true,
    "message": "Favorito eliminado"
}
```

---

## 5. Endpoints de Calificaciones (futuro)

### POST /calificaciones

Crear calificación.

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
    "id_comida": 1,
    "puntuacion": 5,
    "comentario": "Deliciosa hamburguesa, la recomiendo"
}
```

**Response (201):**
```json
{
    "success": true,
    "data": {
        "id_calificacion": 1,
        "puntuacion": 5,
        "comentario": "Deliciosa hamburguesa, la recomiendo",
        "fecha": "2026-03-25T12:00:00Z"
    }
}
```

---

### GET /calificaciones/:idComida

Obtener calificaciones de una comida.

**Response (200):**
```json
{
    "success": true,
    "data": {
        "promedio": 4.2,
        "total": 15,
        "calificaciones": [
            {
                "id_calificacion": 1,
                "puntuacion": 5,
                "comentario": "Excelente",
                "usuario": {
                    "nombre": "María G."
                },
                "fecha": "2026-03-24T10:00:00Z"
            }
        ]
    }
}
```

---

## 6. Endpoints de Gestión de Menú (futuro)

### POST /menu/platillos

Agregar platillo al menú.

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
    "nombre": "Hamburguesa Especial",
    "descripcion": "Con tocino y queso azul",
    "precio": 120.00
}
```

---

### PUT /menu/platillos/:id

Actualizar platillo.

**Request:**
```json
{
    "nombre": "Hamburguesa Especial XXL",
    "precio": 135.00,
    "disponible": true
}
```

---

### DELETE /menu/platillos/:id

Eliminar platillo.

---

## 7. Manejo de Errores

### Formato de Error

```json
{
    "success": false,
    "error": {
        "message": "No hay comidas que coincidan con los filtros especificados",
        "code": "NO_RESULTS_FOUND"
    }
}
```

### Códigos de Error

| Código | HTTP | Descripción |
|--------|------|-------------|
| VALIDATION_ERROR | 400 | Datos de entrada inválidos |
| UNAUTHORIZED | 401 | Token inválido o expirado |
| FORBIDDEN | 403 | No tiene permisos |
| NOT_FOUND | 404 | Recurso no encontrado |
| DUPLICATE_ENTRY | 409 | Recurso duplicado |
| RATE_LIMIT_EXCEEDED | 429 | Demasiadas requests |
| INTERNAL_ERROR | 500 | Error interno |

---

## 8. Rate Limiting

### Headers de Rate Limit

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1711368000
```

### Límites por Endpoint

| Endpoint | Límite | Ventana |
|----------|--------|---------|
| /auth/* | 10 req | 1 minuto |
| /negocios/filtrar | 30 req | 1 minuto |
| /negocios/* | 100 req | 1 minuto |
| /favoritos/* | 50 req | 1 minuto |
| /calificaciones/* | 20 req | 1 minuto |

---

## 9. Versionado

### Header de Versión

```
Accept: application/json; version=v1
```

### Estrategia

- Versión actual: v1
- Cambios backwards-compatible: nueva versión minor
- Cambios breaking: nueva versión major

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
