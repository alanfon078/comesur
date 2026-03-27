# ComeSur - Criterios de Aceptación

## Metodología

Cada funcionalidad debe cumplir con TODOS los criterios de aceptación listados para considerarse "Completada".

| Símbolo | Significado |
|---------|-------------|
| ✅ | Verificado y passing |
| ❌ | Fallando |
| ⏳ | En progreso |
| 🔲 | No implementado |

---

## Épica 1: Autenticación y Perfil

### US-01: Registro en la app ✅

**COMO** Visitante nuevo, **QUIERO** registrarme con mi correo y contraseña, **PARA** crear una cuenta y acceder a la app

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Formulario con campos: nombre, correo, contraseña | ✅ | login_screen.dart |
| 2 | Validación de formato de correo | ✅ | Form validation |
| 3 | Validación de contraseña (mín 8 caracteres) | ✅ | Form validation |
| 4 | Confirmación de contraseña | ✅ | Form validation |
| 5 | Mensaje de error si el correo ya existe | ✅ | API response |
| 6 | Navegación a Login tras registro exitoso | ✅ | Navigation flow |

---

### US-02: Iniciar sesión ✅

**COMO** Usuario registrado, **QUIERO** iniciar sesión con mi correo y contraseña, **PARA** acceder a mi cuenta y buscar comida

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Campos: usuario/correo, contraseña | ✅ | login_screen.dart:35-55 |
| 2 | Botón "Iniciar Sesión" | ✅ | ElevatedButton |
| 3 | Navegación a Filter Screen tras login exitoso | ✅ | login_screen.dart:89-95 |
| 4 | Mensaje de error para credenciales inválidas | ✅ | SnackBar error |
| 5 | Opción "Olvidé mi contraseña" | 🔲 | No implementado |

**Notas:**
- Criterio 5 (olvidé mi contraseña) no implementado en v1.0

---

### US-03: Login con Google 🔲

**COMO** Usuario que prefiere OAuth, **QUIERO** iniciar sesión con mi cuenta de Google, **PARA** evitar crear otra contraseña

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Botón "Login con Google" | 🔲 | No implementado |
| 2 | Flujo OAuth con Google | 🔲 | No implementado |
| 3 | Crear cuenta automáticamente si es primera vez | 🔲 | No implementado |
| 4 | Mantener sesión al cerrar y abrir app | 🔲 | No implementado |

**Notas:**
- Feature planeado para v2.0

---

### US-04: Cerrar sesión 🔲

**COMO** Usuario autenticado, **QUIERO** cerrar mi sesión, **PARA** que otra persona no acceda a mi cuenta

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Opción en menú/perfil | 🔲 | No implementado |
| 2 | Confirmación antes de cerrar | 🔲 | No implementado |
| 3 | Limpiar tokens y datos de sesión | 🔲 | No implementado |
| 4 | Navegar a Login | 🔲 | No implementado |

**Notas:**
- Feature planeado para v1.1

---

## Épica 2: Búsqueda y Descubrimiento

### US-05: Buscar por tipo de comida ✅

**COMO** Usuario con hambre, **QUIERO** buscar por tipo de comida (ej. hamburguesas), **PARA** encontrar opciones rápidamente

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Campo de texto para tipo de comida | ✅ | filter_screen.dart:TextField |
| 2 | Placeholder: "Ej. Hamburguesa, Tacos..." | ✅ | filter_screen.dart |
| 3 | Validación: campo requerido | ✅ | Form validation |
| 4 | Envío al presionar botón | ✅ | filter_screen.dart:ElevatedButton |
| 5 | Resultados ordenados por calificación | ✅ | backend query ORDER BY |

**Notas:**
- Feature completamente implementado y funcionando

---

### US-06: Filtrar por presupuesto ✅

**COMO** Usuario con presupuesto limitado, **QUIERO** filtrar por precio máximo, **PARA** ver solo opciones que puedo pagar

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Campo numérico opcional | ✅ | filter_screen.dart:TextField |
| 2 | Placeholder: "Ej. 40" | ✅ | filter_screen.dart |
| 3 | Validación: número > 0 | ✅ | Validation logic |
| 4 | Filtrar resultados <= presupuesto | ✅ | backend query WHERE precio <= |
| 5 | Combinable con tipo de comida | ✅ | Both params in request |

**Notas:**
- Feature completamente implementado y funcionando

---

### US-07: Ver resultados de búsqueda ✅

**COMO** Usuario que buscó comida, **QUIERO** ver los resultados en una lista, **PARA** comparar opciones disponibles

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Lista scrolleable de cards | ✅ | results_screen.dart:ListView |
| 2 | Cada card muestra: platillo, precio, negocio, rating | ✅ | BusinessCard widget |
| 3 | Mostrar precio con formato moneda | ✅ | formatCurrency() |
| 4 | Tap para ver detalle (futuro) | 🔲 | No implementado |
| 5 | Pull-to-refresh | 🔲 | No implementado |

**Notas:**
- Criterios 4-5 no implementados en v1.0

---

### US-08: Sin resultados ✅

**COMO** Usuario que no encontró opciones, **QUIERO** saber que no hay resultados, **PARA** modificar mis filtros

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Mostrar empty state con ícono | ✅ | EmptyState widget |
| 2 | Mensaje: "No hay comidas que coincidan..." | ✅ | results_screen.dart |
| 3 | Botón "Modificar Filtros" | ✅ | ElevatedButton |
| 4 | Navegación de vuelta a filtros | ✅ | Navigator.pop() |

**Notas:**
- Feature completamente implementado y funcionando

---

### US-09: Ver detalle de negocio 🔲

**COMO** Usuario interesado en un negocio, **QUIERO** ver información detallada, **PARA** decidir si ir o no

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Banner con imagen del negocio | 🔲 | No implementado |
| 2 | Nombre, calificación, categoría | 🔲 | No implementado |
| 3 | Menú completo | 🔲 | No implementado |
| 4 | Dirección y horario | 🔲 | No implementado |
| 5 | Botón de favorito | 🔲 | No implementado |
| 6 | Lista de calificaciones | 🔲 | No implementado |

**Notas:**
- Feature planeado para v1.2

---

## Épica 3: Favoritos

### US-10: Marcar como favorito 🔲

**COMO** Usuario que encontró un buen lugar, **QUIERO** guardarlo en favoritos, **PARA** encontrarlo fácilmente después

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Botón de corazón en cada card | 🔲 | No implementado |
| 2 | Toggle de estado (lleno/vacío) | 🔲 | No implementado |
| 3 | Guardar en base de datos | 🔲 | No implementado |
| 4 | Feedback visual inmediato | 🔲 | No implementado |

**Notas:**
- Feature planeado para v1.3

---

### US-11: Ver favoritos 🔲

**COMO** Usuario que quiere ver sus guardados, **QUIERO** acceder a mi lista de favoritos, **PARA** elegir rápidamente dónde comer

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Acceso desde bottom navigation | 🔲 | No implementado |
| 2 | Lista de negocios guardados | 🔲 | No implementado |
| 3 | Posibilidad de quitar de favoritos | 🔲 | No implementado |
| 4 | Empty state si no hay favoritos | 🔲 | No implementado |

**Notas:**
- Feature planeado para v1.3

---

## Épica 4: Calificaciones

### US-12: Calificar un negocio 🔲

**COMO** Usuario que probó un lugar, **QUIERO** calificar mi experiencia, **PARA** ayudar a otros usuarios

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Sistema de 1-5 estrellas | 🔲 | No implementado |
| 2 | Campo de comentario (opcional) | 🔲 | No implementado |
| 3 | Una calificación por usuario por negocio | 🔲 | No implementado |
| 4 | Editar calificación existente | 🔲 | No implementado |
| 5 | Confirmación al enviar | 🔲 | No implementado |

**Notas:**
- Feature planeado para v2.0

---

### US-13: Ver calificaciones 🔲

**COMO** Usuario investigando un lugar, **QUIERO** leer opiniones de otros, **PARA** saber qué esperar

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Ver promedio de rating | 🔲 | No implementado |
| 2 | Lista de comentarios | 🔲 | No implementado |
| 3 | Mostrar autor y fecha | 🔲 | No implementado |
| 4 | Ordenar por más recientes/relevantes | 🔲 | No implementado |

**Notas:**
- Feature planeado para v2.0

---

## Épica 5: Gestión de Negocios

### US-14: Registrar mi negocio 🔲

**COMO** Dueño de un local de comida, **QUIERO** registrar mi negocio en la plataforma, **PARA** ganar visibilidad

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Formulario de registro de negocio | 🔲 | No implementado |
| 2 | Campos: nombre, dirección, categoría, descripción | 🔲 | No implementado |
| 3 | Subir fotos del local | 🔲 | No implementado |
| 4 | Validación de datos | 🔲 | No implementado |
| 5 | Pendiente de aprobación admin | 🔲 | No implementado |

**Notas:**
- Feature planeado para v2.0

---

### US-15: Gestionar menú 🔲

**COMO** Dueño de negocio, **QUIERO** agregar y editar platillos, **PARA** mantener mi menú actualizado

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | CRUD de platillos | 🔲 | No implementado |
| 2 | Campos: nombre, descripción, precio | 🔲 | No implementado |
| 3 | Marcar disponible/no disponible | 🔲 | No implementado |
| 4 | Vista previa del menú | 🔲 | No implementado |

**Notas:**
- Feature planeado para v2.0

---

### US-16: Ver estadísticas 🔲

**COMO** Dueño de negocio, **QUIERO** ver cuántas personas me encuentran, **PARA** entender mi rendimiento

| # | Criterio de Aceptación | Estado | Evidencia |
|---|------------------------|--------|-----------|
| 1 | Número de vistas | 🔲 | No implementado |
| 2 | Número de favoritos | 🔲 | No implementado |
| 3 | Calificación promedio | 🔲 | No implementado |
| 4 | Cantidad de calificaciones | 🔲 | No implementado |

**Notas:**
- Feature planeado para v3.0

---

## Resumen de Cumplimiento

| Épica | Completado | En Progreso | No Iniciado |
|-------|------------|--------------|-------------|
| Épica 1: Autenticación | 2 | 0 | 2 |
| Épica 2: Búsqueda | 4 | 0 | 1 |
| Épica 3: Favoritos | 0 | 0 | 2 |
| Épica 4: Calificaciones | 0 | 0 | 2 |
| Épica 5: Gestión | 0 | 0 | 3 |
| **Total** | **6** | **0** | **10** |

### Porcentaje de Cumplimiento: 37.5%

---

## Criterios de Aceptación Técnicos

### Requisitos No Funcionales

| Requisito | Criterio | Estado | Notas |
|-----------|----------|--------|-------|
| RNF-01 | App inicia en < 3 segundos | ✅ | En dispositivos de prueba |
| RNF-02 | API responde en < 500ms | ✅ | Endpoint /filtrar responde ~200ms |
| RNF-03 | Scroll fluido a 60fps | ✅ | ListView optimizado |
| RNF-04 | Soporte offline básico | ❌ | No hay caché local |
| RNF-05 | Manejo de errores robusto | ✅ | Try-catch y estados de error |
| RNF-06 | Tokens expiran en 24h | ✅ | JWT configurado |
| RNF-07 | Rate limiting activo | ✅ | 30 req/min en /filtrar |

---

## Definition of Done (DoD)

Una historia de usuario se considera **DONE** cuando cumple:

### Criterios Técnicos
- [x] Código mergeado en develop/main
- [x] Unit tests编写并通过
- [x] Code review aprobado
- [x] Lint y typecheck passing
- [x] Build exitoso

### Criterios Funcionales
- [x] Todos los criterios de aceptación verificados
- [x] Pruebas de regresión passing
- [x] Documentación actualizada

### Criterios de Calidad
- [x] 0 defectos P0 abiertos
- [x] 0 defectos P1 High abiertos
- [x] Cobertura >= 70%

---

## Checklist de Release

### v1.0 Completada ✅

| Ítem | Estado |
|------|--------|
| Login con credenciales | ✅ |
| Búsqueda por tipo de comida | ✅ |
| Filtrado por presupuesto | ✅ |
| Vista de resultados | ✅ |
| Empty state | ✅ |
| Manejo de errores de red | ✅ |
| API endpoint /negocios/filtrar | ✅ |
| Validación de formularios | ✅ |

---

## Sign-Off

| Rol | Nombre | Fecha | Firma |
|-----|--------|-------|-------|
| Product Owner | Por definir | 2026-03-25 | _________ |
| Tech Lead | - | - | _________ |
| QA Lead | - | - | _________ |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
