# ComeSur - Plan de Tareas Detallado

## Tabla de Contenido
1. [Información del Proyecto](#información-del-proyecto)
2. [Tareas por Fase](#tareas-por-fase)
3. [Tecnologías](#tecnologías)
4. [Matriz de Priorización](#matriz-de-priorización)

---

## Información del Proyecto

| Campo | Detalle |
|-------|---------|
| **Nombre** | ComeSur |
| **Tipo** | Aplicación móvil para discovery gastronómico |
| **Versión Actual** | 1.0 (Foundation) |
| **Próxima Versión** | 1.1 (Core Discovery) |
| **Estado General** | En desarrollo |
| **Metodología** | Specification Driven Development (SDD) |

### Objetivos del Producto

| Objetivo | Métrica | Meta |
|----------|---------|------|
| Adquisición de usuarios | Downloads en 6 meses | 1,000 |
| Retención | MAU (Monthly Active Users) | 60% |
| Engagement | Búsquedas por usuario/mes | 5 |
| Cobertura | Negocios registrados | 50 |

---

## Tareas por Fase

### Fase 1: Foundation (Completada ✅)

#### 1.1 Configuración del Proyecto
- [ ] Configurar repositorio Git
- [ ] Crear estructura de carpetas Flutter
- [ ] Configurar dependencias en pubspec.yaml
- [ ] Configurar backend Node.js con Express
- [ ] Crear package.json y dependencias
- [ ] Configurar ESLint y Prettier

#### 1.2 UI Base
- [ ] Implementar tema claro/oscuro (Material Design)
- [ ] Crear navegación principal
- [ ] Implementar splash screen
- [ ] Configurar colores primario (#4CAF50) y secundarios

#### 1.3 Pantalla de Login
- [ ] Crear formulario de inicio de sesión
- [ ] Validar formato de correo electrónico
- [ ] Validar longitud mínima de contraseña (8 caracteres)
- [ ] Implementar navegación a pantalla de filtros tras login exitoso
- [ ] Mostrar mensaje de error para credenciales inválidas
- [ ] Integrar con endpoint POST /auth/login

#### 1.4 Pantalla de Filtros
- [ ] Crear campo de texto para tipo de comida
- [ ] Implementar placeholder "Ej. Hamburguesa, Tacos..."
- [ ] Crear campo numérico para presupuesto máximo
- [ ] Validar que tipo de comida sea campo requerido
- [ ] Validar que presupuesto sea número > 0
- [ ] Implementar botón de búsqueda
- [ ] Integrar con endpoint GET /negocios/filtrar

#### 1.5 Backend Básico
- [ ] Configurar servidor Express
- [ ] Crear conexión a MySQL
- [ ] Implementar endpoint POST /auth/login
- [ ] Implementar endpoint GET /negocios/filtrar
- [ ] Generar datos mock para pruebas

#### 1.6 Pantalla de Resultados
- [ ] Mostrar lista scrolleable de cards
- [ ] Cada card debe mostrar: platillo, precio, negocio, rating
- [ ] Formatear precio como moneda MXN
- [ ] Mostrar calificación con estrellas visuales
- [ ] Implementar ordenamiento por calificación descendente
- [ ] Mostrar mensaje cuando no hay resultados
- [ ] Mostrar indicador de carga durante búsqueda

---

### Fase 2: Core Discovery (En Desarrollo 🔄)

#### 2.1 Pantalla de Detalle de Negocio (Alta Prioridad - 3 días)
- [ ] Crear banner con imagen del negocio
- [ ] Mostrar nombre, calificación, categoría
- [ ] Implementar menú completo
- [ ] Mostrar dirección y horario
- [ ] Crear botón de favorito
- [ ] Mostrar lista de calificaciones
- [ ] Integrar con endpoint GET /negocios/:id
- [ ] Implementar navegación desde Results

#### 2.2 Manejo de Errores Mejorado (Alta Prioridad - 2 días)
- [ ] Implementar mensajes de error amigables
- [ ] Crear manejo de errores de conexión
- [ ] Implementar retry automático para requests fallidas
- [ ] Mostrar código de error cuando aplica
- [ ] Integrar con sistema de logging (Winston)

#### 2.3 Estados de Carga (Media Prioridad - 1 día)
- [ ] Crear loading spinners para todas las operaciones async
- [ ] Implementar skeleton loaders para listas
- [ ] Animaciones de transición entre pantallas
- [ ] Indicador de progreso para operaciones largas

#### 2.4 Empty States Personalizados (Media Prioridad - 1 día)
- [ ] Diseñar empty state con ícono para sin resultados
- [ ] Mensaje: "No hay comidas que coincidan con los filtros..."
- [ ] Crear botón "Modificar Filtros"
- [ ] Implementar navegación de vuelta a filtros

#### 2.5 Historial de Búsquedas (Baja Prioridad - 2 días)
- [ ] Guardar búsquedas recientes en local storage
- [ ] Mostrar historial en pantalla de filtros
- [ ] Permitir selección de búsqueda anterior
- [ ] Limitar a 10 búsquedas recientes

---

### Fase 3: Social Features (Planificado 📋)

#### 3.1 Sistema de Favoritos (Alta Prioridad - 5 días)
- [ ] Crear botón de corazón en cada card
- [ ] Implementar toggle de estado (lleno/vacío)
- [ ] Guardar en base de datos (tabla Favorito)
- [ ] Mostrar feedback visual inmediato
- [ ] Implementar endpoint GET /favoritos
- [ ] Implementar endpoint POST /favoritos
- [ ] Implementar endpoint DELETE /favoritos/:idNegocio
- [ ] Crear pantalla de favoritos
- [ ] Implementar empty state si no hay favoritos

#### 3.2 Sistema de Calificaciones (Alta Prioridad - 4 días)
- [ ] Crear sistema de 1-5 estrellas
- [ ] Agregar campo de comentario (opcional)
- [ ] Implementar una calificación por usuario por negocio
- [ ] Permitir editar calificación existente
- [ ] Crear confirmación al enviar
- [ ] Mostrar promedio de rating
- [ ] Mostrar lista de comentarios con autor y fecha

#### 3.3 Perfil de Usuario (Media Prioridad - 3 días)
- [ ] Crear pantalla de perfil
- [ ] Mostrar nombre, correo y rol
- [ ] Mostrar historial de calificaciones
- [ ] Mostrar favoritos guardados
- [ ] Implementar opción de cerrar sesión

#### 3.4 Login con Google (Media Prioridad - 2 días)
- [ ] Configurar Google OAuth
- [ ] Crear botón "Login con Google"
- [ ] Implementar flujo OAuth
- [ ] Crear cuenta automáticamente si es primera vez
- [ ] Mantener sesión al cerrar y abrir app

#### 3.5 Login con Facebook (Baja Prioridad - 2 días)
- [ ] Configurar Facebook OAuth
- [ ] Crear botón "Login con Facebook"
- [ ] Implementar flujo OAuth

---

### Fase 4: Business Tools (Planificado 📋)

#### 4.1 Dashboard para Negocios (Alta Prioridad - 5 días)
- [ ] Crear pantalla de dashboard para negocios
- [ ] Mostrar número de vistas
- [ ] Mostrar número de favoritos
- [ ] Mostrar calificación promedio
- [ ] Mostrar cantidad de calificaciones

#### 4.2 CRUD de Menú (Alta Prioridad - 4 días)
- [ ] Crear formulario para agregar platillos
- [ ] Campos: nombre, descripción, precio
- [ ] Implementar edición de platillos
- [ ] Implementar eliminación de platillos
- [ ] Permitir marcar disponible/no disponible
- [ ] Vista previa del menú

#### 4.3 Gestión de Disponibilidad (Media Prioridad - 3 días)
- [ ] Crear menú diario
- [ ] Permitir seleccionar platillos del menú del día
- [ ] Configurar horario de disponibilidad

#### 4.4 Estadísticas (Media Prioridad - 3 días)
- [ ] Crear gráficos de visitas
- [ ] Mostrar tendencias de calificaciones
- [ ] Exportar reportes

#### 4.5 Notificaciones de Calificaciones (Baja Prioridad - 2 días)
- [ ] Implementar notificaciones push
- [ ] Notificar cuando se recibe nueva calificación

---

## Tareas por Historia de Usuario

### Épica 1: Autenticación y Perfil

| ID | Historia | Estado | Estimación |
|----|----------|--------|-------------|
| US-01 | Registro en la app | 📋 Planificado | 3 pts |
| US-02 | Iniciar sesión | ✅ Completado | 2 pts |
| US-03 | Login con Google | 📋 Planificado | 5 pts |
| US-04 | Cerrar sesión | 📋 Planificado | 1 pt |

### Épica 2: Búsqueda y Descubrimiento

| ID | Historia | Estado | Estimación |
|----|----------|--------|-------------|
| US-05 | Buscar por tipo de comida | ✅ Completado | 3 pts |
| US-06 | Filtrar por presupuesto | ✅ Completado | 2 pts |
| US-07 | Ver resultados de búsqueda | ✅ Completado | 3 pts |
| US-08 | Sin resultados | 🔄 En curso | 1 pt |
| US-09 | Ver detalle de negocio | 📋 Planificado | 5 pts |

### Épica 3: Favoritos

| ID | Historia | Estado | Estimación |
|----|----------|--------|-------------|
| US-10 | Marcar como favorito | 📋 Planificado | 2 pts |
| US-11 | Ver favoritos | 📋 Planificado | 3 pts |

### Épica 4: Calificaciones

| ID | Historia | Estado | Estimación |
|----|----------|--------|-------------|
| US-12 | Calificar un negocio | 📋 Planificado | 3 pts |
| US-13 | Ver calificaciones | 📋 Planificado | 2 pts |

### Épica 5: Gestión de Negocios

| ID | Historia | Estado | Estimación |
|----|----------|--------|-------------|
| US-14 | Registrar mi negocio | 📋 Planificado | 5 pts |
| US-15 | Gestionar menú | 📋 Planificado | 5 pts |
| US-16 | Ver estadísticas | 📋 Planificado | 3 pts |

---

## Requisitos Funcionales

### RF-01: Autenticación de Usuarios

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-01.1 | Sistema debe permitir login con correo y contraseña | Alta | ✅ |
| RF-01.2 | Sistema debe validar formato de correo electrónico | Alta | ✅ |
| RF-01.3 | Sistema debe validar longitud mínima de contraseña (8 caracteres) | Alta | ✅ |
| RF-01.4 | Sistema debe mantener sesión activa con tokens JWT | Alta | ✅ |
| RF-01.5 | Sistema debe permitir login con Google OAuth | Media | 📋 |
| RF-01.6 | Sistema debe permitir login con Facebook OAuth | Baja | 📋 |
| RF-01.7 | Sistema debe permitir cerrar sesión | Alta | 📋 |
| RF-01.8 | Sistema debe limpiar datos de sesión al cerrar | Alta | 📋 |

### RF-02: Búsqueda y Filtrado

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-02.1 | Sistema debe permitir buscar por tipo de comida | Alta | ✅ |
| RF-02.2 | Sistema debe permitir filtrar por presupuesto máximo | Media | ✅ |
| RF-02.3 | Sistema debe ordenar resultados por calificación descendente | Alta | ✅ |
| RF-02.4 | Sistema debe mostrar mensaje cuando no hay resultados | Alta | 🔄 |
| RF-02.5 | Sistema debe manejar errores de conexión | Alta | 🔄 |
| RF-02.6 | Sistema debe mostrar indicador de carga durante búsqueda | Alta | ✅ |
| RF-02.7 | Sistema debe permitir modificar filtros y repetir búsqueda | Alta | 🔄 |

### RF-03: Visualización de Resultados

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-03.1 | Sistema debe mostrar lista scrolleable de resultados | Alta | ✅ |
| RF-03.2 | Cada resultado debe mostrar: platillo, precio, negocio, rating | Alta | ✅ |
| RF-03.3 | Sistema debe formatear precio como moneda MXN | Alta | ✅ |
| RF-03.4 | Sistema debe mostrar calificación con estrellas visuales | Alta | ✅ |
| RF-03.5 | Sistema debe permitir tap en resultado para ver detalle | Media | 📋 |
| RF-03.6 | Sistema debe mostrar imagen placeholder si no hay foto | Media | 📋 |

### RF-04: Sistema de Favoritos

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-04.1 | Usuario debe poder marcar negocio como favorito | Media | 📋 |
| RF-04.2 | Usuario debe poder desmarcar negocio de favoritos | Media | 📋 |
| RF-04.3 | Sistema debe persistir favoritos en base de datos | Media | 📋 |
| RF-04.4 | Sistema debe mostrar indicador visual en favoritos | Media | 📋 |
| RF-04.5 | Sistema debe permitir ver lista de favoritos | Media | 📋 |

### RF-05: Sistema de Calificaciones

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-05.1 | Usuario debe poder calificar negocio (1-5 estrellas) | Media | 📋 |
| RF-05.2 | Usuario debe poder agregar comentario (opcional) | Media | 📋 |
| RF-05.3 | Sistema debe calcular promedio de calificaciones | Media | ✅ |
| RF-05.4 | Sistema debe permitir editar calificación existente | Baja | 📋 |
| RF-05.5 | Sistema debe mostrar historial de calificaciones | Baja | 📋 |

### RF-06: Gestión de Menú (Negocio)

| ID | Descripción | Prioridad | Estado |
|----|-------------|-----------|--------|
| RF-06.1 | Negocio debe poder agregar platillos al menú | Media | 📋 |
| RF-06.2 | Negocio debe poder editar platillos existentes | Media | 📋 |
| RF-06.3 | Negocio debe poder eliminar platillos | Media | 📋 |
| RF-06.4 | Negocio debe poder marcar platillo como disponible/no disponible | Media | 📋 |
| RF-06.5 | Sistema debe mostrar menú actualizado a usuarios | Media | 📋 |

---

## Requisitos No Funcionales

### RNF-01: Rendimiento

| ID | Descripción | Métrica | Meta | Estado |
|----|-------------|---------|------|--------|
| RNF-01.1 | Tiempo de respuesta API búsqueda | < 500ms | 95% requests | 📋 |
| RNF-01.2 | Tiempo de carga de pantalla | < 2s | WiFi/4G | 📋 |
| RNF-01.3 | Tiempo de inicio de app | < 3s | cold start | 📋 |
| RNF-01.4 | Animaciones | 60 FPS | Sin drops | 📋 |

### RNF-02: Disponibilidad

| ID | Descripción | Meta | Estado |
|----|-------------|------|--------|
| RNF-02.1 | Uptime del servicio | 99.5% | 📋 |
| RNF-02.2 | Ventana de mantenimiento | 2-6 AM CST | 📋 |
| RNF-02.3 | Plan de recuperación ante desastres | < 4 horas | 📋 |

### RNF-03: Seguridad

| ID | Descripción | Implementación | Estado |
|----|-------------|----------------|--------|
| RNF-03.1 | Comunicación cifrada | HTTPS/TLS 1.2+ | 📋 |
| RNF-03.2 | Almacenamiento seguro de contraseñas | bcrypt hash | 📋 |
| RNF-03.3 | Tokens con expiración | JWT 24h | 📋 |
| RNF-03.4 | Validación de inputs | Sanitización server-side | 📋 |
| RNF-03.5 | Rate limiting | 100 req/min por IP | 📋 |

### RNF-04: Compatibilidad

| ID | Descripción | Meta | Estado |
|----|-------------|------|--------|
| RNF-04.1 | Android mínimo | 5.0 (API 21) | 📋 |
| RNF-04.2 | iOS mínimo | 12.0 | 📋 |
| RNF-04.3 | Orientación | Portrait | 📋 |
| RNF-04.4 | Idiomas | Español (es-MX) | ✅ |

---

## Matriz de Priorización

### MoSCoW

| Prioridad | Historias | Puntos Totales |
|-----------|-----------|----------------|
| Must Have | US-02, US-05, US-06, US-07, US-08, US-09 | 16 pts |
| Should Have | US-10, US-11, US-12, US-13 | 10 pts |
| Could Have | US-03, US-04, US-14, US-15, US-16 | 17 pts |
| Won't Have | US-01.5, US-01.6 | - |

###优先级 (Kanban)

| Columna | Descripción | Tareas |
|---------|-------------|--------|
| **To Do** | Pendientes de desarrollo | Todas las tareas de Fases 3 y 4 |
| **In Progress** | En desarrollo actualmente | US-08, RF-02.5, RF-02.7, F02.2 |
| **Code Review** | Esperando revisión | RF-02.4, RF-02.6 |
| **Done** | Completadas | Todas las tareas de Fase 1 |

---

## Roadmap de Versiones

| Versión | Nombre | Fecha Planeada | Estado | Entregables |
|---------|--------|----------------|--------|-------------|
| 1.0 | Foundation | Feb 2026 | ✅ Completado | Login, Filtros, Búsqueda, Resultados |
| 1.1 | Core Discovery | Mar 2026 | 🔄 En desarrollo | Detalle negocio, manejo errores, loading states |
| 2.0 | Social Features | May 2026 | 📋 Planificado | Favoritos, Calificaciones, Perfil, OAuth |
| 3.0 | Business Tools | Ago 2026 | 📋 Planificado | Dashboard negocio, CRUD menú, Estadísticas |

---

## Sprint Planning (Versión 1.1)

### Sprint 4 (1 semana)
- Pantalla de detalle de negocio
- Estados de carga

### Sprint 5 (1 semana)
- Manejo de errores
- Empty states

### Sprint 6 (1 semana)
- Historial de búsquedas
- Testing

---

## Checklist de Criterios de Aceptación

### Versión 1.1 - Core Discovery

- [ ] Detalle muestra información completa del negocio
- [ ] Loading spinners en todas las operaciones async
- [ ] Mensajes de error amigables para el usuario
- [ ] Empty state cuando no hay resultados

### Versión 2.0 - Social Features

- [ ] Usuario puede marcar/desmarcar favoritos
- [ ] Favoritos persisten entre sesiones
- [ ] Usuario puede calificar (1-5)
- [ ] Usuario puede comentar
- [ ] Perfil muestra historial

### Versión 3.0 - Business Tools

- [ ] Negocio puede crear/editar menú
- [ ] Negocio puede marcar platillos disponibles/no disponibles
- [ ] Dashboard muestra calificaciones recibidas
- [ ] Admin puede moderar comentarios

---

## Tecnologías

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Frontend | Flutter | 3.4 |
| Diseño UI | Material Design | - |
| Backend | Node.js | v20 |
| Framework HTTP | Express | 5.0 |
| Base de Datos | MySQL | 8.0 |
| Autenticación | JWT | - |
| hashing | bcrypt | - |
| Deployment | VPS | - |
| SSL | HTTPS | TLS 1.2+ |

---

## Autores del Proyecto

- **Alan Yael Fonseca Ruiz**
- **Zaid Jared Cerna Duran**
- **Ambar Paola Fujarte Herrera**
- **Janetzy Maldonado Nava**
- **Erik Jesus Ramirez Diaz Ruiz**

---

## Estado de las Especificaciones

| Documento | Estado | Última Actualización |
|-----------|--------|---------------------|
| Product Vision | ✅ Completo | 2026-03-25 |
| Product Roadmap | ✅ Completo | 2026-03-25 |
| UI/UX Specs | ✅ Completo | 2026-03-25 |
| Functional Specs | ✅ Completo | 2026-03-25 |
| Technical Specs | ✅ Completo | 2026-03-25 |
| Test Specs | ✅ Completo | 2026-03-25 |

---

## Símbolos de Estado

| Símbolo | Significado |
|---------|-------------|
| ✅ | Completado |
| 🔄 | En desarrollo |
| 📋 | Planificado |
| ⏸️ | En pausa |
| ❌ | Cancelado |

---

*Documento generado: 2026-03-26*
*Versión: 1.0*
*Proyecto: ComeSur - Specification Driven Development*