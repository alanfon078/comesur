# ComeSur - Flujo de Navegación

## 1. Mapa de Navegación

```
                    ┌─────────────────┐
                    │    Splash       │
                    │   (1 seg)      │
                    └────────┬────────┘
                             │
                             ▼
              ┌──────────────────────────┐
              │                          │
              │       Login Screen       │◀──────────────────┐
              │                          │                    │
              └────────────┬─────────────┘                    │
                           │                                  │
              ┌────────────┴─────────────┐                    │
              │                          │                    │
              ▼                          ▼                    │
    ┌─────────────────┐     ┌─────────────────┐             │
    │   Registro      │     │  Filter Screen  │◀────────────┘
    │   (pendiente)    │     │                 │              │
    └────────┬────────┘     └────────┬────────┘              │
             │                         │                      │
             │                         ▼                      │
             │              ┌─────────────────┐              │
             │              │                 │              │
             └─────────────▶│  Results Screen │──────────────┘
                             │                 │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │ Detail Screen   │
                             │ (pendiente)     │
                             └─────────────────┘
```

---

## 2. Navegación Implementada

### Navigator 1.0 (Implementado)

```dart
// Navegación simple con Navigator.push
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => FilterScreen()),
);

// Navegación con resultado
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ResultsScreen(resultados: resultados)),
);
```

### Transiciones de Pantalla

| De | A | Transición | Duración |
|----|---|------------|----------|
| Login | Filter | Slide + Fade | 300ms |
| Filter | Results | Slide | 300ms |
| Results | Filter | Slide Back | 300ms |

---

## 3. Flujo de Usuario (Happy Path)

### CU1: Búsqueda de Comida

```
┌─────────────────────────────────────────────────────────────────┐
│  Paso 1: Login                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1.1 Usuario abre la app                                       │
│  1.2 Sistema muestra Login Screen                               │
│  1.3 Usuario ingresa credenciales                                │
│  1.4 Sistema valida (bypass en MVP)                            │
│  1.5 Sistema navega a Filter Screen                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Paso 2: Búsqueda                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  2.1 Sistema muestra formulario de filtros                    │
│      - Tipo de comida (requerido)                               │
│      - Presupuesto máximo (opcional)                           │
│  2.2 Usuario ingresa tipo de comida                            │
│  2.3 Usuario ingresa presupuesto (opcional)                   │
│  2.4 Usuario presiona "Aplicar Filtros"                         │
│  2.5 Sistema muestra loading                                    │
│  2.6 Sistema envía request al API                               │
│  2.7 Sistema recibe respuesta                                   │
│  2.8 Sistema navega a Results Screen                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Paso 3: Visualización de Resultados                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  3.1 Sistema muestra lista de resultados                        │
│      - Platillo, precio, negocio, calificación                │
│  3.2 Usuario puede:                                             │
│      - Scroll por más resultados                                │
│      - Tocar en resultado para ver detalle (futuro)           │
│      - Regresar y modificar filtros                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Flujo Alternativo - Sin Resultados

```
┌─────────────────────────────────────────────────────────────────┐
│  Escenario: Sin resultados                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  3.1 Sistema recibe respuesta 404                                │
│  3.2 Sistema muestra Empty State                                │
│      - Ícono de búsqueda vacía                                  │
│      - Mensaje: "No hay comidas que coincidan..."              │
│  3.3 Usuario puede:                                             │
│      - Presionar "Modificar Filtros"                           │
│      - Sistema regresa a Filter Screen                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Flujo de Error - Sin Conexión

```
┌─────────────────────────────────────────────────────────────────┐
│  Escenario: Error de conexión                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  2.5 Sistema muestra loading                                    │
│  2.6 Request falla por timeout o red                           │
│  2.7 Sistema muestra SnackBar                                   │
│      - Mensaje: "Error de conexión con el servidor..."          │
│      - Duración: 4 segundos                                     │
│  2.8 Sistema permanece en Filter Screen                        │
│  2.9 Usuario puede reintentar                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. Estados de Pantalla

### Filter Screen States

| Estado | Componente Visible | Descripción |
|--------|-------------------|-------------|
| Default | Form vacío | Campos sin datos |
| Filled | Form con datos | Datos ingresados |
| Loading | Form + Spinner | Enviando request |
| Error | Form + SnackBar | Error mostrado |

### Results Screen States

| Estado | Componente Visible | Descripción |
|--------|-------------------|-------------|
| Loading | Spinner centrado | Cargando datos |
| Success | Lista de cards | Resultados encontrados |
| Empty | Empty State UI | Sin resultados |
| Error | Error UI | Error del servidor |

---

## 7. Back Navigation

### Gestión del Back Button

```
┌─────────────────────────────────────────────────────────────────┐
│  Back desde Filter Screen                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Dispositivo ◀──┐                                              │
│                  │                                              │
│                  ▼                                              │
│         ┌─────────────────┐                                    │
│         │  AppBar Leading │                                    │
│         │    (←)          │                                    │
│         └────────┬────────┘                                    │
│                  │                                              │
│                  ▼                                              │
│         ┌─────────────────┐                                    │
│         │  Pop hasta Login │                                    │
│         └─────────────────┘                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Pop Behavior

| Pantalla Actual | Acción | Resultado |
|-----------------|--------|-----------|
| Filter | Back button | Pop a Login |
| Results | Back button | Pop a Filter |

---

## 8. Deep Links (Futuro)

### Esquema de URLs

```
comesur://
├── /login
├── /search?type={tipo}&budget={presupuesto}
├── /business/{id}
└── /favorites

https://comesur.app
├── /app/login
├── /app/search
├── /app/business/{id}
└── /app/favorites
```

### Estados de Deep Link

| URL | Pantalla Destino | Parámetros |
|-----|-----------------|------------|
| `/search?type=tacos&budget=50` | Results | tipo=tacos, presupuesto=50 |
| `/business/123` | Detail | id=123 |

---

## 9. Breadcrumbs y Navegación Contextual

### AppBar Contextual

```dart
// Filter Screen AppBar
AppBar(
  title: Text('¿Qué se te antoja?'),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
)

// Results Screen AppBar
AppBar(
  title: Text('Resultados'),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
)
```

---

## 10. Future Navigation (v2.0+)

### Bottom Navigation Bar (Planificado)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    Contenido principal                          │
│                                                                 │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   🔍           ❤️            👤                                  │
│  Buscar    Favoritos      Perfil                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Drawer Navigation (Planificado)

```
┌─────────────────────────────────────────────────────────────────┐
│  ┌─────────┐                                                    │
│  │  🍔      │  ComeSur                                          │
│  └─────────┘  usuario@email.com                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🔍 Buscar                                                     │
│                                                                 │
│  ❤️ Favoritos                                                  │
│                                                                 │
│  📍 Mis Negocios (si es negocio)                               │
│                                                                 │
│  ⭐ Calificaciones                                              │
│                                                                 │
│  ⚙️ Configuración                                             │
│                                                                 │
│  ❓ Ayuda                                                       │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🚪 Cerrar Sesión                                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 11. Criterios de Navegación

| Criterio | Descripción | Validación |
|----------|-------------|------------|
| Depth | Máximo 4 niveles de navegación | ✓ |
| Back可达 | Todo screen accesible tiene back | ✓ |
| No loops | No hay ciclos en navegación | ✓ |
| Estado preservado | Datos sobreviven pop/push | ✓ |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
