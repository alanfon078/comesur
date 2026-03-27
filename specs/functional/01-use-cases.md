# ComeSur - Casos de Uso

## 1. Diagrama de Actores

```
                    ┌─────────────────────┐
                    │     COMESUR        │
                    │                     │
                    │  ┌───────────────┐ │
                    │  │   Estudiante   │ │
                    │  └───────┬───────┘ │
                    │  ┌───────┴───────┐ │
                    │  │   Visitante    │ │
                    │  └───────┬───────┘ │
                    │  ┌───────┴───────┐ │
                    │  │   Negocio      │ │
                    │  └───────┬───────┘ │
                    │  ┌───────┴───────┐ │
                    │  │    Admin       │ │
                    │  └───────────────┘ │
                    └─────────────────────┘

Actor Primario: Usuario (Estudiante/Visitante)
Actores Secundarios: Sistema, Base de Datos
```

---

## 2. Caso de Uso: CU-01 Autenticación

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-01 |
| Nombre | Autenticarse en el sistema |
| Prioridad | Alta |
| Actor | Usuario |
| Precondición | Usuario no ha iniciado sesión |

### Flujo Principal

```
ACTOR                        SISTEMA
  │                              │
  │──打开 App─────────────────▶│
  │                              │
  │                              │──Muestra Login Screen
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
  │                              │
  │──Ingresa credenciales──────▶│
  │                              │
  │                              │──Valida credenciales
  │                              │──Crea sesión
  │                              │──Navega a Filter Screen
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
  │                              │
```

### Flujos Alternativos

| ID | Alternativa | Condición |
|----|-------------|-----------|
| ALT-01 | Login social (Google) | Usuario selecciona Google |
| ALT-02 | Login social (Facebook) | Usuario selecciona Facebook |
| ALT-03 | Registro | Usuario selecciona "Crear cuenta" |
| ALT-04 | Credenciales inválidas | Validación falla |

### Postcondiciones

- Usuario autenticado tiene sesión activa
- Token de acceso almacenado localmente

### Excepciones

| ID | Excepción | Manejo |
|----|-----------|--------|
| EX-01 | Red no disponible | Mostrar mensaje de error |
| EX-02 | Credenciales incorrectas | Mostrar error específico |

---

## 3. Caso de Uso: CU-02 Buscar Comida

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-02 |
| Nombre | Buscar comida con filtros |
| Prioridad | Alta |
| Actor | Usuario |
| Precondición | Usuario autenticado |

### Flujo Principal

```
ACTOR                        SISTEMA
  │                              │
  │──Ingresa tipo de comida─────▶│
  │                              │
  │──[Opcional]─────────────────▶│
  │   Ingresa presupuesto máximo  │
  │                              │
  │──Presiona "Aplicar Filtros"─▶│
  │                              │
  │                              │──Valida formulario
  │                              │──Muestra loading
  │                              │──Envía request API
  │                              │──Recibe respuesta
  │                              │──Navega a Results
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
  │                              │
```

### Datos de Entrada

| Campo | Tipo | Requerido | Validación |
|-------|------|-----------|------------|
| tipoComida | String | Sí | 1-100 caracteres |
| presupuesto | Number | No | > 0, max 10000 |

### Flujos Alternativos

| ID | Alternativa | Condición |
|----|-------------|-----------|
| ALT-01 | Solo tipo de comida | Presupuesto vacío |
| ALT-02 | Solo presupuesto | Tipo vacío (no debería pasar) |
| ALT-03 | Sin resultados | API retorna 404 |

### Postcondiciones

- Resultados mostrados en lista ordenada por calificación

### Excepciones

| ID | Excepción | Manejo |
|----|-----------|--------|
| EX-01 | Error de red | Mostrar SnackBar |
| EX-02 | Timeout | Mostrar mensaje de timeout |

---

## 4. Caso de Uso: CU-03 Ver Detalle de Negocio (Futuro)

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-03 |
| Nombre | Ver detalle de un negocio |
| Prioridad | Media |
| Actor | Usuario |
| Precondición | Usuario en Results Screen |

### Flujo Principal

```
ACTOR                        SISTEMA
  │                              │
  │──Toca en card de resultado─▶│
  │                              │
  │                              │──Navega a Detail Screen
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
  │                              │
  │──Visualiza información──────│
  │   - Nombre del negocio      │
  │   - Calificación             │
  │   - Menú                     │
  │   - Ubicación                │
  │   - Horario                  │
```

### Datos Mostrados

| Campo | Fuente |
|-------|--------|
| Nombre | Negocio.nombre_negocio |
| Descripción | Negocio.descripcion |
| Calificación | AVG(Calificacion.puntuacion) |
| Menú | Comida WHERE id_negocio = ? |
| Dirección | Negocio.direccion |
| Categoría | Negocio.categoria |

---

## 5. Caso de Uso: CU-04 Gestionar Favoritos (Futuro)

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-04 |
| Nombre | Marcar/desmarcar negocios como favoritos |
| Prioridad | Media |
| Actor | Usuario autenticado |

### Flujo Principal

```
ACTOR                        SISTEMA
  │                              │
  │──Toca ícono ❤️ en negocio──▶│
  │                              │
  │                              │──Toggle estado favorito
  │                              │──Guarda en BD
  │                              │──Actualiza UI
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
```

### Estados del Favorito

| Estado | Ícono | Color | Acción |
|--------|-------|-------|--------|
| No favorito | favorite_border | null | Agregar a favoritos |
| Favorito | favorite | red | Quitar de favoritos |

---

## 6. Caso de Uso: CU-05 Calificar Negocio (Futuro)

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-05 |
| Nombre | Calificar y comentar un negocio |
| Prioridad | Media |
| Actor | Usuario autenticado |

### Flujo Principal

```
ACTOR                        SISTEMA
  │                              │
  │──Toca "Calificar"──────────▶│
  │                              │
  │                              │──Muestra diálogo de rating
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
  │                              │
  │──Selecciona 1-5 estrellas──▶│
  │                              │
  │──[Opcional]─────────────────▶│
  │   Escribe comentario         │
  │                              │
  │──Presiona "Enviar"──────────▶│
  │                              │
  │                              │──Valida datos
  │                              │──Guarda en BD
  │                              │──Actualiza promedio
  │◀─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│
```

### Validaciones

| Campo | Regla |
|-------|-------|
| Puntuación | Requerida, 1-5 |
| Comentario | Opcional, max 500 caracteres |

---

## 7. Caso de Uso: CU-06 Gestionar Menú (Negocio)

### Información General

| Campo | Valor |
|-------|-------|
| ID | CU-06 |
| Nombre | CRUD de platillos en menú |
| Prioridad | Media |
| Actor | Usuario con rol "negocio" |

### Operaciones

| Operación | Descripción |
|-----------|-------------|
| Create | Agregar nuevo platillo |
| Read | Ver menú actual |
| Update | Modificar platillo existente |
| Delete | Eliminar platillo |

### Datos del Platillo

| Campo | Tipo | Requerido |
|-------|------|-----------|
| nombre | VARCHAR(120) | Sí |
| descripcion | TEXT | No |
| precio | DECIMAL(8,2) | Sí |
| disponible | BOOLEAN | Sí |

---

## 8. Matriz de Trazabilidad

| CU | Requisito Funcional |
|----|---------------------|
| CU-01 | RF-01 Autenticación |
| CU-02 | RF-02 Búsqueda con filtros |
| CU-03 | RF-03 Detalle de negocio |
| CU-04 | RF-04 Sistema de favoritos |
| CU-05 | RF-05 Calificaciones |
| CU-06 | RF-06 Gestión de menú |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
