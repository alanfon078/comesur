# ComeSur - Tareas de Frontend

## Tabla de Contenido
1. [Información General](#información-general)
2. [Fase 1: Foundation](#fase-1-foundation)
3. [Fase 2: Core Discovery](#fase-2-core-discovery)
4. [Fase 3: Social Features](#fase-3-social-features)
5. [Fase 4: Business Tools](#fase-4-business-tools)
6. [Pantallas por Implementar](#pantallas-por-implementar)
7. [Componentes](#componentes)

---

## Información General

| Campo | Detalle |
|-------|---------|
| **Tecnología** | Flutter 3.4 |
| **Diseño** | Material Design |
| **Estado Actual** | Fase 1 completada |
| **Plataformas** | Android 5.0+, iOS 12.0+ |

---

## Fase 1: Foundation (Completada ✅)

### 1.1 Configuración del Proyecto
- [x] Crear proyecto Flutter
- [x] Configurar pubspec.yaml con dependencias
- [x] Estructura de carpetas por feature
- [x] Configurar Theme con Material Design
- [x] Configurar navegación (GoRouter/Navigator)

### 1.2 UI Base
- [x] Implementar tema claro (#FFFFFF, #000000)
- [x] Implementar tema oscuro (#000000, #FFFFFF)
- [x] Color primario verde (#4CAF50)
- [x] Configurar Material Icons

### 1.3 Pantalla de Login
- [x] Crear formulario con campos: correo, contraseña
- [x] Validar formato de correo electrónico
- [x] Validar contraseña mínima 8 caracteres
- [x] Mostrar errores de validación
- [x] Botón "Iniciar Sesión"
- [x] Llamar a POST /auth/login
- [x] Guardar token JWT
- [x] Navegar a pantalla de filtros tras login exitoso
- [x] Mostrar mensaje de error para credenciales inválidas

### 1.4 Pantalla de Filtros
- [x] Campo de texto para tipo de comida
- [x] Placeholder: "Ej. Hamburguesa, Tacos..."
- [x] Campo numérico para presupuesto máximo
- [x] Validar tipo de comida como requerido
- [x] Validar presupuesto > 0
- [x] Botón "Buscar"
- [x] Llamar a GET /negocios/filtrar

### 1.5 Pantalla de Resultados
- [x] Lista scrolleable (ListView.builder)
- [x] Card para cada resultado
- [x] Mostrar: platillo, precio, negocio, rating
- [x] Formatear precio como MXN ($1,234.56)
- [x] Mostrar estrellas visuales (1-5)
- [x] Indicador de carga (CircularProgressIndicator)
- [x] Mensaje cuando no hay resultados
- [x] Ordenamiento por calificación

---

## Fase 2: Core Discovery (En Desarrollo 🔄)

### 2.1 Pantalla de Detalle de Negocio (3 días)
- [ ] Banner con imagen del negocio
- [ ] Mostrar: nombre, calificación, categoría
- [ ] Mostrar: descripción, dirección, horario
- [ ] Mostrar: teléfono
- [ ] Lista de menú completo
- [ ] Botón de favorito (icono corazón)
- [ ] Lista de calificaciones
- [ ] Llamar GET /negocios/:id
- [ ] Implementar navegación desde Results

### 2.2 Manejo de Errores (2 días)
- [ ] SnackBar para errores
- [ ] Dialog para errores críticos
- [ ] Retry button en errores de red
- [ ] Mostrar código de error
- [ ] Estados: loading, error, success, empty

### 2.3 Estados de Carga (1 día)
- [ ] CircularProgressIndicator para operaciones async
- [ ] Skeleton loaders para listas
- [ ] Shimmer effect
- [ ] Animaciones de transición (Hero, FadeTransition)
- [ ] LinearProgressIndicator para operaciones largas

### 2.4 Empty States (1 día)
- [ ] Icono para sin resultados
- [ ] Mensaje: "No hay comidas que coincidan..."
- [ ] Botón "Modificar Filtros"
- [ ] Navegación de vuelta a filtros
- [ ] Empty states para: sin favoritos, sin calificaciones

### 2.5 Historial de Búsquedas (2 días)
- [ ] Guardar en SharedPreferences
- [ ] Mostrar historial en pantalla de filtros
- [ ] Chip para cada búsqueda reciente
- [ ] Tap para reutilizar búsqueda
- [ ] Limitar a 10 búsquedas
- [ ] Botón para borrar historial

---

## Fase 3: Social Features (Planificado 📋)

### 3.1 Sistema de Favoritos (5 días)

#### UI/UX
- [ ] Icono corazón en cada card de negocio
- [ ] Animación de pulse al marcar
- [ ] Color lleno/vacío
- [ ] Feedback visual inmediato

#### Funcionalidad
- [ ] Llamar POST /favoritos al marcar
- [ ] Llamar DELETE /favoritos al desmarcar
- [ ] Mostrar indicator deloading

#### Pantalla de Favoritos
- [ ] Bottom navigation item
- [ ] Lista de negocios favoritos
- [ ] Card con imagen, nombre, rating
- [ ] Botón para quitar de favoritos
- [ ] Empty state si no hay favoritos

### 3.2 Sistema de Calificaciones (4 días)

#### UI/UX
- [ ] Rating bar (1-5 estrellas)
- [ ] Animación de selección
- [ ] Campo de texto para comentario
- [ ] Indicador de "¿Ya calificaste?"

#### Funcionalidad
- [ ] POST /calificaciones para crear
- [ ] PUT /calificaciones para editar
- [ ] Validar 1-5 estrellas
- [ ] Mostrar promedio en negocio

#### Mostrar Calificaciones
- [ ] Lista de comentarios
- [ ] Avatar/nombre de usuario
- [ ] Fecha de calificación
- [ ] Puntuación con estrellas

### 3.3 Perfil de Usuario (3 días)

#### Pantalla de Perfil
- [ ] Avatar con imagen o iniciales
- [ ] Nombre del usuario
- [ ] Correo electrónico
- [ ] Rol (estudiante/negocio)
- [ ] Historial de calificaciones
- [ ] Lista de favoritos
- [ ] Opción "Cerrar Sesión"

#### Funcionalidad
- [ ] GET /usuarios/perfil
- [ ] PUT /usuarios/perfil
- [ ] Limpiar token al cerrar sesión

### 3.4 Login con Google (2 días)
- [ ] Botón "Iniciar sesión con Google"
- [ ] Icono de Google
- [ ] Flutter Google Sign In
- [ ] Manejo de callback
- [ ] Crear cuenta si no existe

### 3.5 Login con Facebook (2 días)
- [ ] Botón "Iniciar sesión con Facebook"
- [ ] Icono de Facebook
- [ ] Flutter Facebook Login
- [ ] Manejo de callback

---

## Fase 4: Business Tools (Planificado 📋)

### 4.1 Dashboard para Negocios (5 días)

#### Pantalla Dashboard
- [ ] Cards con métricas
- [ ] Número de vistas
- [ ] Número de favoritos
- [ ] Calificación promedio
- [ ] Cantidad de calificaciones
- [ ] Gráfico de visitas (fl_chart)

#### Funcionalidad
- [ ] GET /negocios/:id/estadisticas
- [ ] Refresh de datos

### 4.2 CRUD de Menú (4 días)

#### Agregar Platillo
- [ ] Formulario: nombre, descripción, precio
- [ ] Selector de imagen
- [ ] Toggle disponible/no disponible
- [ ] Validaciones
- [ ] POST /menu/platillos

#### Editar Platillo
- [ ] Precargar datos actuales
- [ ] Campos editables
- [ ] PUT /menu/platillos/:id

#### Eliminar Platillo
- [ ] Confirmación antes de eliminar
- [ ] DELETE /menu/platillos/:id

#### Vista Previa
- [ ] Lista del menú completo
- [ ] Indicador de disponibilidad
- [ ] Orden de platillos

### 4.3 Gestión de Disponibilidad (3 días)

#### Menú Diario
- [ ] Crear menú del día
- [ ] Seleccionar platillos disponibles
- [ ] Configurar horario
- [ ] POST /menu-diario

### 4.4 Estadísticas (3 días)

#### Gráficos
- [ ] Gráfico de barras (visitas)
- [ ] Gráfico lineal (tendencias)
- [ ] Distribución de calificaciones

### 4.5 Notificaciones (2 días)
- [ ] Firebase Cloud Messaging
- [ ] Notificaciones push
- [ ] Notificar nuevas calificaciones

---

## Pantallas por Implementar

| Pantalla | Estado | Prioridad |
|----------|--------|-----------|
| Login | ✅ | Alta |
| Filtros | ✅ | Alta |
| Resultados | ✅ | Alta |
| Detalle Negocio | 🔄 | Alta |
| Favoritos | 📋 | Alta |
| Perfil | 📋 | Media |
| Calificar | 📋 | Media |
| Registro | 📋 | Alta |
| Dashboard Negocio | 📋 | Media |
| Gestión Menú | 📋 | Alta |

---

## Componentes Reutilizables

### Common Widgets
- [x] AppButton (estilizado)
- [x] AppTextField (con validación)
- [x] LoadingIndicator
- [x] ErrorWidget
- [ ] EmptyStateWidget
- [x] RatingStars (estrellas)
- [ ] PriceFormat (formato MXN)
- [ ] BusinessCard
- [ ] FoodCard

### Estados
- [x] LoadingState
- [ ] ErrorState
- [ ] EmptyState
- [ ] SuccessState

---

## Navegación

### Rutas
- [x] /login → LoginScreen
- [x] /filtros → FiltersScreen
- [x] /resultados → ResultsScreen
- [ ] /negocio/:id → BusinessDetailScreen
- [ ] /favoritos → FavoritesScreen
- [ ] /perfil → ProfileScreen
- [ ] /calificar/:id → RatingScreen
- [ ] /registro → RegisterScreen
- [ ] /dashboard → DashboardScreen

### Bottom Navigation
- [ ] Buscar (filtros)
- [ ] Favoritos
- [ ] Perfil

---

## Integración con API

### HTTP Client
- [x] Configurar Dio
- [x] Headers con Authorization
- [ ] Retry interceptor
- [ ] Cache interceptor

### Modelos
- [x] User
- [x] Negocio
- [x] Comida
- [ ] Favorito
- [ ] Calificacion

### Repositorios
- [x] AuthRepository
- [x] NegocioRepository
- [ ] FavoritoRepository
- [ ] CalificacionRepository

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