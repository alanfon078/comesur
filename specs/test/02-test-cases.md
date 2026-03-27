# ComeSur - Casos de Prueba

## Convenciones

| Campo | Formato |
|-------|---------|
| TC-ID | TC-[Módulo]-[Número] |
| Prioridad | P0 (Crítico), P1 (Alto), P2 (Medio) |
| Precondición | Estado requerido antes de ejecutar |
| Pasos | Secuencia numerada de acciones |
| Resultado Esperado | Comportamiento esperado del sistema |

---

## Módulo: Autenticación (AUTH)

### TC-AUTH-001: Login con credenciales válidas

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-001 |
| **Prioridad** | P0 |
| **Módulo** | AUTH |
| **Título** | Login con credenciales válidas |

**Precondiciones:**
- Usuario registrado en el sistema
- Credenciales: correo: `test@comesur.com`, password: `Test1234`

**Pasos:**
1. Abrir aplicación ComeSur
2. Verificar que se muestra Login Screen
3. Ingresar correo: `test@comesur.com`
4. Ingresar contraseña: `Test1234`
5. Presionar botón "Iniciar Sesión"

**Resultado Esperado:**
- Mostrar loading indicator
- Redirigir a Filter Screen tras 1-2 segundos
- Toast/SnackBar: "Bienvenido, [nombre del usuario]"
- Botón de logout visible en Filter Screen

**Postcondición:** Sesión activa con token almacenado localmente

---

### TC-AUTH-002: Login con credenciales inválidas

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-002 |
| **Prioridad** | P0 |
| **Módulo** | AUTH |
| **Título** | Login con credenciales incorrectas |

**Precondiciones:** Ninguna

**Pasos:**
1. Abrir aplicación ComeSur
2. Ingresar correo: `invalid@email.com`
3. Ingresar contraseña: `wrongpass`
4. Presionar botón "Iniciar Sesión"

**Resultado Esperado:**
- Mostrar mensaje de error: "Credenciales incorrectas. Verifica tu correo y contraseña."
- Campos de texto permanecen con los valores ingresados
- No navegar a ninguna otra pantalla
- Botón "Iniciar Sesión" habilitado nuevamente

---

### TC-AUTH-003: Login con campos vacíos

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-003 |
| **Prioridad** | P1 |
| **Módulo** | AUTH |
| **Título** | Validación de campos obligatorios |

**Precondiciones:** Ninguna

**Pasos:**
1. Abrir aplicación ComeSur
2. Dejar campos de correo y contraseña vacíos
3. Presionar botón "Iniciar Sesión"

**Resultado Esperado:**
- Mostrar validación inline: "El correo es requerido" bajo campo correo
- Mostrar validación inline: "La contraseña es requerida" bajo campo contraseña
- Botón "Iniciar Sesión" permanece habilitado
- No realizar request a API

---

### TC-AUTH-004: Login con formato de correo inválido

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-004 |
| **Prioridad** | P1 |
| **Módulo** | AUTH |
| **Título** | Validación de formato de correo |

**Precondiciones:** Ninguna

**Pasos:**
1. Abrir aplicación ComeSur
2. Ingresar correo: `noesuncorreo`
3. Ingresar contraseña: `Test1234`
4. Presionar botón "Iniciar Sesión"

**Resultado Esperado:**
- Mostrar mensaje: "Ingresa un correo electrónico válido"
- Campo correo resaltado en rojo
- No realizar request a API

---

### TC-AUTH-005: Registro de nuevo usuario

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-005 |
| **Prioridad** | P1 |
| **Módulo** | AUTH |
| **Título** | Registro con datos válidos |

**Precondiciones:** Correo `nuevo@email.com` no registrado

**Pasos:**
1. Abrir aplicación ComeSur
2. Presionar "Crear cuenta"
3. Ingresar nombre: "Usuario Nuevo"
4. Ingresar correo: `nuevo@email.com`
5. Ingresar contraseña: `NuevaPass123`
6. Confirmar contraseña: `NuevaPass123`
7. Presionar "Registrarse"

**Resultado Esperado:**
- Mostrar loading indicator
- Crear usuario en base de datos
- Mostrar mensaje: "Cuenta creada exitosamente"
- Redirigir a Login Screen
- Usuario puede iniciar sesión con nuevas credenciales

---

### TC-AUTH-006: Registro con correo existente

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-006 |
| **Prioridad** | P1 |
| **Módulo** | AUTH |
| **Título** | Registro con correo duplicado |

**Precondiciones:** Correo `existente@email.com` ya registrado

**Pasos:**
1. Abrir aplicación ComeSur
2. Presionar "Crear cuenta"
3. Ingresar nombre: "Otro Usuario"
4. Ingresar correo: `existente@email.com`
5. Ingresar contraseña: `TestPass123`
6. Confirmar contraseña: `TestPass123`
7. Presionar "Registrarse"

**Resultado Esperado:**
- Mostrar mensaje de error: "Este correo ya está registrado. Intenta con otro."
- Campo correo resaltado
- Contraseñas limpiadas por seguridad
- No crear usuario duplicado

---

### TC-AUTH-007: Logout exitoso

| Campo | Valor |
|-------|-------|
| **ID** | TC-AUTH-007 |
| **Prioridad** | P1 |
| **Módulo** | AUTH |
| **Título** | Cerrar sesión correctamente |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen (sesión activa)
2. Abrir menú de usuario/perfil
3. Presionar "Cerrar Sesión"
4. Confirmar en diálogo de confirmación

**Resultado Esperado:**
- Mostrar diálogo: "¿Estás seguro de que quieres cerrar sesión?"
- Al confirmar: limpiar token y datos de sesión
- Redirigir a Login Screen
- Botón atrás deshabilitado desde Login (no permitir volver a sesión)

---

## Módulo: Búsqueda (SEARCH)

### TC-SEARCH-001: Búsqueda por tipo de comida

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-001 |
| **Prioridad** | P0 |
| **Módulo** | SEARCH |
| **Título** | Buscar hamburguesas |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen
2. Ingresar "hamburguesa" en campo de búsqueda
3. Dejar campo presupuesto vacío
4. Presionar "Buscar" o botón de aplicar filtros

**Resultado Esperado:**
- Mostrar loading indicator
- Mostrar Results Screen con cards de restaurantes
- Cada card muestra: nombre negocio, calificación (estrellas), distancia
- Resultados ordenados por calificación descendente
- Indicador de cantidad: "X resultados encontrados"

---

### TC-SEARCH-002: Búsqueda con filtro de presupuesto

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-002 |
| **Prioridad** | P0 |
| **Módulo** | SEARCH |
| **Título** | Filtrar por precio máximo |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen
2. Ingresar "tacos" en campo de búsqueda
3. Ingresar "50" en campo de presupuesto
4. Presionar "Buscar"

**Resultado Esperado:**
- Mostrar solo resultados con precio <= 50
- Si no hay resultados: mostrar empty state
- Indicador de filtro activo visible
- Mensaje: "Mostrando tacos hasta $50"

---

### TC-SEARCH-003: Sin resultados de búsqueda

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-003 |
| **Prioridad** | P0 |
| **Módulo** | SEARCH |
| **Título** | Empty state cuando no hay coincidencias |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen
2. Ingresar "comidainexistente123456" en campo de búsqueda
3. Presionar "Buscar"

**Resultado Esperado:**
- Mostrar empty state con ícono de búsqueda
- Mensaje: "No hay comidas que coincidan con tu búsqueda"
- Sugerencia: "Intenta con otros términos o modifica tus filtros"
- Botón "Modificar Filtros" visible y funcional
- Al presionar: regresar a Filter Screen con campos limpios

---

### TC-SEARCH-004: Validación de campo vacío

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-004 |
| **Prioridad** | P1 |
| **Módulo** | SEARCH |
| **Título** | No permitir búsqueda sin tipo de comida |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen
2. Dejar campo de tipo de comida vacío
3. [Opcional] Ingresar presupuesto
4. Presionar "Buscar"

**Resultado Esperado:**
- Mostrar validación: "Ingresa el tipo de comida que buscas"
- Campo tipoComida resaltado
- No realizar request a API
- Permanecer en Filter Screen

---

### TC-SEARCH-005: Presupuesto con valor inválido

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-005 |
| **Prioridad** | P2 |
| **Módulo** | SEARCH |
| **Título** | Validación de presupuesto negativo |

**Precondiciones:** Usuario logueado

**Pasos:**
1. Estar en Filter Screen
2. Ingresar "pizza" en tipo de comida
3. Ingresar "-10" en presupuesto
4. Presionar "Buscar"

**Resultado Esperado:**
- Mostrar mensaje: "El presupuesto debe ser mayor a 0"
- Campo presupuesto resaltado
- No realizar búsqueda

---

### TC-SEARCH-006: Pull-to-refresh en resultados

| Campo | Valor |
|-------|-------|
| **ID** | TC-SEARCH-006 |
| **Prioridad** | P1 |
| **Módulo** | SEARCH |
| **Título** | Actualizar resultados con pull-down |

**Precondiciones:** Usuario logueado, resultados visibles

**Pasos:**
1. Estar en Results Screen con resultados cargados
2. Deslizar hacia abajo desde la parte superior de la lista

**Resultado Esperado:**
- Mostrar indicador de refresh circular
- Realizar request de búsqueda nuevamente
- Actualizar lista de resultados
- Animación de refresh completada
- Indicador de última actualización visible

---

## Módulo: Resultados (RESULTS)

### TC-RESULTS-001: Ver lista de resultados

| Campo | Valor |
|-------|-------|
| **ID** | TC-RESULTS-001 |
| **Prioridad** | P0 |
| **Módulo** | RESULTS |
| **Título** | Mostrar cards de negocios correctamente |

**Precondiciones:** Resultados devueltos por API

**Pasos:**
1. Realizar búsqueda exitosa
2. Observar Results Screen

**Resultado Esperado:**
- Lista scrolleable de cards
- Cada card muestra:
  - Imagen del negocio (o placeholder)
  - Nombre del negocio
  - Calificación (1-5 estrellas o número)
  - Distancia aproximada
  - Tiempo estimado de entrega
- Posibilidad de hacer scroll suave
- Imágenes se cargan progresivamente

---

### TC-RESULTS-002: Tap en card para ver detalle

| Campo | Valor |
|-------|-------|
| **ID** | TC-RESULTS-002 |
| **Prioridad** | P1 |
| **Módulo** | RESULTS |
| **Título** | Navegación a detalle de negocio |

**Precondiciones:** Resultados visibles

**Pasos:**
1. Estar en Results Screen
2. Tocar en una card de negocio

**Resultado Esperado:**
- Navegación a Detail Screen
- Carga de datos del negocio
- Mostrar información completa (nombre, descripción, menú, horario)
- Botón de atrás funcional para regresar a resultados

---

### TC-RESULTS-003: Orden de resultados

| Campo | Valor |
|-------|-------|
| **ID** | TC-RESULTS-003 |
| **Prioridad** | P1 |
| **Módulo** | RESULTS |
| **Título** | Resultados ordenados por calificación |

**Precondiciones:** Múltiples resultados disponibles

**Pasos:**
1. Realizar búsqueda: "comida"
2. Observar orden de los resultados

**Resultado Esperado:**
- Resultados ordenados por calificación promedio descendente
- Negocio con mayor calificación aparece primero
- En caso de empate: ordenar por cantidad de calificaciones
- Badge "Mejor valorado" en negocio #1

---

## Módulo: Negocio (BUSINESS)

### TC-BUSINESS-001: Ver detalle completo del negocio

| Campo | Valor |
|-------|-------|
| **ID** | TC-BUSINESS-001 |
| **Prioridad** | P1 |
| **Módulo** | BUSINESS |
| **Título** | Mostrar información detallada |

**Precondiciones:** Usuario en Detail Screen

**Pasos:**
1. Navegar a Detail Screen de un negocio

**Resultado Esperado:**
- Banner/imagen del negocio visible
- Nombre del negocio como título
- Calificación con promedio y cantidad de reseñas
- Categoría/tipo de comida
- Descripción del negocio
- Horario de atención
- Dirección con opción de ver en mapa
- Menú completo con precios

---

### TC-BUSINESS-002: Ver menú del negocio

| Campo | Valor |
|-------|-------|
| **ID** | TC-BUSINESS-002 |
| **Prioridad** | P1 |
| **Módulo** | BUSINESS |
| **Título** | Listar platillos disponibles |

**Precondiciones:** Detail Screen cargada

**Pasos:**
1. Estar en Detail Screen
2. Hacer scroll hasta sección de menú

**Resultado Esperado:**
- Lista de platillos con:
  - Nombre del platillo
  - Descripción breve
  - Precio formateado (ej: "$85.00 MXN")
  - Indicador de disponibilidad
- Platillos disponibles vs no disponibles diferenciados visualmente

---

## Módulo: Favoritos (FAVORITES)

### TC-FAV-001: Marcar negocio como favorito

| Campo | Valor |
|-------|-------|
| **ID** | TC-FAV-001 |
| **Prioridad** | P1 |
| **Módulo** | FAVORITES |
| **Título** | Agregar a favoritos |

**Precondiciones:** Usuario logueado, en Detail Screen

**Pasos:**
1. Estar en Detail Screen de un negocio
2. Tocar botón de corazón (vacío)

**Resultado Esperado:**
- Ícono cambia a corazón lleno (rojo)
- Feedback visual: animación de latido
- Toast: "Agregado a favoritos"
- Guardar en base de datos
- Contador de favoritos se actualiza

---

### TC-FAV-002: Quitar de favoritos

| Campo | Valor |
|-------|-------|
| **ID** | TC-FAV-002 |
| **Prioridad** | P1 |
| **Módulo** | FAVORITES |
| **Título** | Remover de favoritos |

**Precondiciones:** Usuario logueado, negocio ya en favoritos

**Pasos:**
1. Estar en Detail Screen de negocio favoritado
2. Tocar botón de corazón (lleno)

**Resultado Esperado:**
- Ícono cambia a corazón vacío
- Toast: "Eliminado de favoritos"
- Eliminar de base de datos
- Contador de favoritos se actualiza

---

### TC-FAV-003: Ver lista de favoritos

| Campo | Valor |
|-------|-------|
| **ID** | TC-FAV-003 |
| **Prioridad** | P1 |
| **Módulo** | FAVORITES |
| **Título** | Acceder a favoritos guardados |

**Precondiciones:** Usuario logueado con negocios favoritados

**Pasos:**
1. Abrir navegación/bottom menu
2. Seleccionar "Favoritos"

**Resultado Esperado:**
- Mostrar lista de negocios guardados
- Cada item: imagen, nombre, calificación
- Swipe o botón para quitar de favoritos
- Empty state si no hay favoritos: "Aún no tienes favoritos"

---

## Módulo: Calificaciones (RATINGS)

### TC-RATING-001: Calificar un negocio

| Campo | Valor |
|-------|-------|
| **ID** | TC-RATING-001 |
| **Prioridad** | P1 |
| **Módulo** | RATINGS |
| **Título** | Crear calificación con estrellas |

**Precondiciones:** Usuario logueado, experiencia con el negocio

**Pasos:**
1. Estar en Detail Screen
2. Tocar "Calificar"
3. Seleccionar 4 estrellas
4. [Opcional] Ingresar comentario: "Muy rico"
5. Presionar "Enviar"

**Resultado Esperado:**
- Diálogo de calificación cerrado
- Toast: "¡Gracias por tu calificación!"
- Promedio actualizado en la UI
- Contador de reseñas incrementado

---

### TC-RATING-002: Ver calificaciones existentes

| Campo | Valor |
|-------|-------|
| **ID** | TC-RATING-002 |
| **Prioridad** | P2 |
| **Módulo** | RATINGS |
| **Título** | Mostrar lista de reseñas |

**Precondiciones:** Negocio con calificaciones

**Pasos:**
1. Estar en Detail Screen
2. Desplazarse a sección de calificaciones

**Resultado Esperado:**
- Promedio general visible (ej: 4.2 de 5)
- Cantidad de reseñas (ej: "Basado en 15 reseñas")
- Lista de reseñas con:
  - Nombre del usuario (anónimo: "Usuario A.")
  - Calificación (estrellas)
  - Comentario
  - Fecha de la reseña

---

## Módulo: API (Backend)

### TC-API-001: Endpoint /api/auth/login

| Campo | Valor |
|-------|-------|
| **ID** | TC-API-001 |
| **Prioridad** | P0 |
| **Módulo** | API |
| **Título** | Autenticación exitosa vía API |

**Precondiciones:** Usuario existente en DB

**Request:**
```http
POST /api/auth/login
Content-Type: application/json

{
    "correo": "test@comesur.com",
    "password": "Test1234"
}
```

**Resultado Esperado:**
```json
{
    "success": true,
    "data": {
        "user": {
            "id_usuario": 1,
            "nombre": "Usuario Test",
            "correo": "test@comesur.com",
            "rol": "estudiante"
        },
        "token": "eyJhbGciOiJIUzI1NiIs..."
    }
}
```

**Código HTTP:** 200

---

### TC-API-002: Endpoint /api/negocios/filtrar con resultados

| Campo | Valor |
|-------|-------|
| **ID** | TC-API-002 |
| **Prioridad** | P0 |
| **Módulo** | API |
| **Título** | Búsqueda con filtros devuelve resultados |

**Request:**
```http
GET /api/negocios/filtrar?tipoComida=hamburguesa&presupuesto=100
```

**Resultado Esperado:**
```json
{
    "success": true,
    "data": [
        {
            "platillo": "Hamburguesa Clásica",
            "precio": 85.00,
            "negocio": "La Casa del Burger",
            "calificacionPromedio": 4.5
        }
    ],
    "meta": {
        "total": 1,
        "timestamp": "2026-03-25T12:00:00Z"
    }
}
```

**Código HTTP:** 200

---

### TC-API-003: Endpoint /api/negocios/filtrar sin resultados

| Campo | Valor |
|-------|-------|
| **ID** | TC-API-003 |
| **Prioridad** | P0 |
| **Módulo** | API |
| **Título** | Búsqueda sin coincidencias |

**Request:**
```http
GET /api/negocios/filtrar?tipoComida=comidaNoExiste
```

**Resultado Esperado:**
```json
{
    "success": false,
    "error": {
        "message": "No hay comidas que coincidan con los filtros especificados",
        "code": "NO_RESULTS_FOUND"
    }
}
```

**Código HTTP:** 404

---

### TC-API-004: Endpoint /api/negocios/filtrar con parámetros inválidos

| Campo | Valor |
|-------|-------|
| **ID** | TC-API-004 |
| **Prioridad** | P1 |
| **Módulo** | API |
| **Título** | Validación de parámetros |

**Request:**
```http
GET /api/negocios/filtrar?presupuesto=-50
```

**Resultado Esperado:**
```json
{
    "success": false,
    "error": {
        "message": "El presupuesto debe ser mayor a 0",
        "code": "VALIDATION_ERROR"
    }
}
```

**Código HTTP:** 400

---

### TC-API-005: Rate limiting en /api/negocios/filtrar

| Campo | Valor |
|-------|-------|
| **ID** | TC-API-005 |
| **Prioridad** | P2 |
| **Módulo** | API |
| **Título** | Límite de requests excedido |

**Pasos:**
1. Realizar 31 requests en 1 minuto al endpoint /api/negocios/filtrar

**Resultado Esperado:**
```json
{
    "success": false,
    "error": {
        "message": "Has excedido el límite de requests. Intenta más tarde.",
        "code": "RATE_LIMIT_EXCEEDED"
    }
}
```

**Código HTTP:** 429

---

## Módulo: Errores (ERRORS)

### TC-ERR-001: Error de conexión

| Campo | Valor |
|-------|-------|
| **ID** | TC-ERR-001 |
| **Prioridad** | P0 |
| **Módulo** | ERRORS |
| **Título** | Manejo de error de red |

**Pasos:**
1. Desconectar dispositivo de internet
2. Abrir aplicación ComeSur
3. Intentar iniciar sesión

**Resultado Esperado:**
- Mostrar mensaje de error: "No hay conexión a internet. Verifica tu conexión e intenta de nuevo."
- Botón "Reintentar" visible
- Campos de formulario conservados

---

### TC-ERR-002: Timeout de servidor

| Campo | Valor |
|-------|-------|
| **ID** | TC-ERR-002 |
| **Prioridad** | P1 |
| **Módulo** | ERRORS |
| **Título** | Manejo de timeout |

**Pasos:**
1. Configurar mock server para demorar respuesta > 30 segundos
2. Realizar búsqueda de comida

**Resultado Esperado:**
- Mostrar mensaje: "La solicitud tardó demasiado. Intenta de nuevo."
- Botón "Reintentar"
- No mostrar pantalla en blanco

---

## Matriz de Trazabilidad

| Caso de Prueba | Caso de Uso | User Story | Prioridad |
|----------------|-------------|------------|-----------|
| TC-AUTH-001 | CU-01 | US-02 | P0 |
| TC-AUTH-002 | CU-01 | US-02 | P0 |
| TC-AUTH-005 | CU-01 | US-01 | P1 |
| TC-SEARCH-001 | CU-02 | US-05 | P0 |
| TC-SEARCH-002 | CU-02 | US-06 | P0 |
| TC-SEARCH-003 | CU-02 | US-08 | P0 |
| TC-RESULTS-001 | CU-03 | US-07 | P0 |
| TC-BUSINESS-001 | CU-03 | US-09 | P1 |
| TC-FAV-001 | CU-04 | US-10 | P1 |
| TC-FAV-003 | CU-04 | US-11 | P1 |
| TC-RATING-001 | CU-05 | US-12 | P1 |
| TC-API-002 | CU-02 | US-05 | P0 |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
