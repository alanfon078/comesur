# ComeSur - Historias de Usuario

## Formato de Historia de Usuario

```
COMO     [Actor]
QUIERO   [Funcionalidad]
PARA     [Beneficio/Valor]
```

---

## Épica 1: Autenticación y Perfil

### US-01: Registro en la app

```
COMO      Visitante nuevo
QUIERO    registrarme con mi correo y contraseña
PARA      crear una cuenta y acceder a la app
```

**Criterios de Aceptación:**
- [ ] Formulario con campos: nombre, correo, contraseña
- [ ] Validación de formato de correo
- [ ] Validación de contraseña (mín 8 caracteres)
- [ ] Confirmación de contraseña
- [ ] Mensaje de error si el correo ya existe
- [ ] Navegación a Login tras registro exitoso

**Estimación:** 3 puntos de historia

---

### US-02: Iniciar sesión

```
COMO      Usuario registrado
QUIERO    iniciar sesión con mi correo y contraseña
PARA      acceder a mi cuenta y buscar comida
```

**Criterios de Aceptación:**
- [ ] Campos: usuario/correo, contraseña
- [ ] Botón "Iniciar Sesión"
- [ ] Navegación a Filter Screen tras login exitoso
- [ ] Mensaje de error para credenciales inválidas
- [ ] Opción "Olvidé mi contraseña"

**Estimación:** 2 puntos de historia

---

### US-03: Login con Google

```
COMO      Usuario que prefiere OAuth
QUIERO    iniciar sesión con mi cuenta de Google
PARA      evitar crear otra contraseña
```

**Criterios de Aceptación:**
- [ ] Botón "Login con Google"
- [ ] Flujo OAuth con Google
- [ ] Crear cuenta automáticamente si es primera vez
- [ ] Mantener sesión al cerrar y abrir app

**Estimación:** 5 puntos de historia (depende de Google SDK)

---

### US-04: Cerrar sesión

```
COMO      Usuario autenticado
QUIERO    cerrar mi sesión
PARA      que otra persona no acceda a mi cuenta
```

**Criterios de Aceptación:**
- [ ] Opción en menú/perfil
- [ ] Confirmación antes de cerrar
- [ ] Limpiar tokens y datos de sesión
- [ ] Navegar a Login

**Estimación:** 1 punto de historia

---

## Épica 2: Búsqueda y Descubrimiento

### US-05: Buscar por tipo de comida

```
COMO      Usuario con hambre
QUIERO    buscar por tipo de comida (ej. hamburguesas)
PARA      encontrar opciones rápidamente
```

**Criterios de Aceptación:**
- [ ] Campo de texto para tipo de comida
- [ ] Placeholder: "Ej. Hamburguesa, Tacos..."
- [ ] Validación: campo requerido
- [ ] Envío al presionar botón
- [ ] Resultados ordenados por calificación

**Estimación:** 3 puntos de historia (IMPLEMENTADO)

---

### US-06: Filtrar por presupuesto

```
COMO      Usuario con presupuesto limitado
QUIERO    filtrar por precio máximo
PARA      ver solo opciones que puedo pagar
```

**Criterios de Aceptación:**
- [ ] Campo numérico opcional
- [ ] Placeholder: "Ej. 40"
- [ ] Validación: número > 0
- [ ] Filtrar resultados <= presupuesto
- [ ] Combinable con tipo de comida

**Estimación:** 2 puntos de historia (IMPLEMENTADO)

---

### US-07: Ver resultados de búsqueda

```
COMO      Usuario que buscó comida
QUIERO    ver los resultados en una lista
PARA      comparar opciones disponibles
```

**Criterios de Aceptación:**
- [ ] Lista scrolleable de cards
- [ ] Cada card muestra: platillo, precio, negocio, rating
- [ ] Mostrar precio con formato moneda
- [ ] Tap para ver detalle (futuro)
- [ ] Pull-to-refresh

**Estimación:** 3 puntos de historia (IMPLEMENTADO)

---

### US-08: Sin resultados

```
COMO      Usuario que no encontró opciones
QUIERO    saber que no hay resultados
PARA      modificar mis filtros
```

**Criterios de Aceptación:**
- [ ] Mostrar empty state con ícono
- [ ] Mensaje: "No hay comidas que coincidan..."
- [ ] Botón "Modificar Filtros"
- [ ] Navegación de vuelta a filtros

**Estimación:** 1 punto de historia

---

### US-09: Ver detalle de negocio

```
COMO      Usuario interesado en un negocio
QUIERO    ver información detallada
PARA      decidir si ir o no
```

**Criterios de Aceptación:**
- [ ] Banner con imagen del negocio
- [ ] Nombre, calificación, categoría
- [ ] Menú completo
- [ ] Dirección y horario
- [ ] Botón de favorito
- [ ] Lista de calificaciones

**Estimación:** 5 puntos de historia

---

## Épica 3: Favoritos

### US-10: Marcar como favorito

```
COMO      Usuario que encontró un buen lugar
QUIERO    guardarlo en favoritos
PARA      encontrarlo fácilmente después
```

**Criterios de Aceptación:**
- [ ] Botón de corazón en cada card
- [ ] Toggle de estado (lleno/vacío)
- [ ] Guardar en base de datos
- [ ] Feedback visual inmediato

**Estimación:** 2 puntos de historia

---

### US-11: Ver favoritos

```
COMO      Usuario que quiere ver sus guardados
QUIERO    acceder a mi lista de favoritos
PARA      elegir rápidamente dónde comer
```

**Criterios de Aceptación:**
- [ ] Acceso desde bottom navigation
- [ ] Lista de negocios guardados
- [ ] Posibilidad de quitar de favoritos
- [ ] Empty state si no hay favoritos

**Estimación:** 3 puntos de historia

---

## Épica 4: Calificaciones

### US-12: Calificar un negocio

```
COMO      Usuario que probó un lugar
QUIERO    calificar mi experiencia
PARA      ayudar a otros usuarios
```

**Criterios de Aceptación:**
- [ ] Sistema de 1-5 estrellas
- [ ] Campo de comentario (opcional)
- [ ] Una calificación por usuario por negocio
- [ ] Editar calificación existente
- [ ] Confirmación al enviar

**Estimación:** 3 puntos de historia

---

### US-13: Ver calificaciones

```
COMO      Usuario investigando un lugar
QUIERO    leer opiniones de otros
PARA      saber qué esperar
```

**Criterios de Aceptación:**
- [ ] Ver promedio de rating
- [ ] Lista de comentarios
- [ ] Mostrar autor y fecha
- [ ] Ordenar por más recientes/relevantes

**Estimación:** 2 puntos de historia

---

## Épica 5: Gestión de Negocios

### US-14: Registrar mi negocio

```
COMO      Dueño de un local de comida
QUIERO    registrar mi negocio en la plataforma
PARA      ganar visibilidad
```

**Criterios de Aceptación:**
- [ ] Formulario de registro de negocio
- [ ] Campos: nombre, dirección, categoría, descripción
- [ ] Subir fotos del local
- [ ] Validación de datos
- [ ] Pendiente de aprobación admin

**Estimación:** 5 puntos de historia

---

### US-15: Gestionar menú

```
COMO      Dueño de negocio
QUIERO    agregar y editar platillos
PARA      mantener mi menú actualizado
```

**Criterios de Aceptación:**
- [ ] CRUD de platillos
- [ ] Campos: nombre, descripción, precio
- [ ] Marcar disponible/no disponible
- [ ] Vista previa del menú

**Estimación:** 5 puntos de historia

---

### US-16: Ver estadísticas

```
COMO      Dueño de negocio
QUIERO    ver cuántas personas me encuentran
PARA      entender mi rendimiento
```

**Criterios de Aceptación:**
- [ ] Número de vistas
- [ ] Número de favoritos
- [ ] Calificación promedio
- [ ] Cantidad de calificaciones

**Estimación:** 3 puntos de historia

---

## Priorización MoSCoW

| Prioridad | Historias | Puntos |
|-----------|-----------|--------|
| Must Have | US-01, US-02, US-05, US-06, US-07, US-08 | 11 |
| Should Have | US-10, US-11, US-12, US-13 | 10 |
| Could Have | US-03, US-04, US-09, US-14, US-15, US-16 | 22 |
| Won't Have | - | - |

---

## Velocidad del Sprint

| Sprint | Historias | Puntos | Estado |
|--------|-----------|--------|--------|
| 1 | US-02, US-05, US-06 | 7 | ✅ Completado |
| 2 | US-07, US-08 | 4 | 🔄 En curso |
| 3 | US-01, US-04 | 4 | 📋 Planificado |
| 4 | US-10, US-11 | 5 | 📋 Planificado |
| 5 | US-12, US-13 | 5 | 📋 Planificado |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
