# ComeSur - Arquitectura del Sistema

## 1. Vista General de Arquitectura

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         COMESUR - ARQUITECTURA                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                    CLIENTE MÓVIL                                 │   │
│   │   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │   │
│   │   │   Flutter   │  │   Material  │  │  HTTP       │             │   │
│   │   │   App 3.4   │  │   Design    │  │  Client     │             │   │
│   │   └─────────────┘  └─────────────┘  └─────────────┘             │   │
│   │   ┌─────────────────────────────────────────────────────────┐     │   │
│   │   │              Feature Modules                            │     │   │
│   │   │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │     │   │
│   │   │  │   Auth   │  │  Filtros │  │ Negocios │              │     │   │
│   │   │  └──────────┘  └──────────┘  └──────────┘              │     │   │
│   │   └─────────────────────────────────────────────────────────┘     │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                    │
│                                    │ HTTPS/REST                         │
│                                    ▼                                    │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                    SERVIDOR VPS                                   │   │
│   │   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │   │
│   │   │  Node.js    │  │   Express    │  │    PM2       │             │   │
│   │   │    v20      │  │     5.0      │  │  (Cluster)   │             │   │
│   │   └─────────────┘  └─────────────┘  └─────────────┘             │   │
│   │   ┌─────────────────────────────────────────────────────────┐     │   │
│   │   │              Arquitectura MVC                            │     │   │
│   │   │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │     │   │
│   │   │  │ Controllers│  │ Services │  │ Repos    │              │     │   │
│   │   │  └──────────┘  └──────────┘  └──────────┘              │     │   │
│   │   └─────────────────────────────────────────────────────────┘     │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                    │
│                                    │ MySQL Protocol                     │
│                                    ▼                                    │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                 BASE DE DATOS MySQL 8.0                         │   │
│   │   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│   │   │  Usuario  │  │  Negocio │  │  Comida  │  │ Calific. │       │   │
│   │   └──────────┘  └──────────┘  └──────────┘  └──────────┘       │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Arquitectura Frontend (Flutter)

### Estructura de Carpetas

```
frontend/lib/
├── main.dart                    # Entry point
├── app.dart                     # Configuración global
│
├── config/
│   ├── theme.dart              # Definición de temas
│   └── routes.dart             # Definición de rutas
│
├── core/
│   ├── constants/             # Constantes de la app
│   ├── errors/                # Manejo de errores
│   ├── network/               # Cliente HTTP
│   └── utils/                 # Utilidades
│
└── features/                  # Feature Modules
    ├── auth/
    │   ├── data/
    │   │   ├── models/        # Modelos de datos
    │   │   └── repositories/  # Repositorios
    │   ├── domain/
    │   │   └── entities/      # Entidades
    │   └── presentation/
    │       ├── screens/       # Pantallas
    │       └── widgets/       # Widgets específicos
    │
    ├── foodfilter/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── negocios/
        ├── data/
        ├── domain/
        └── presentation/
```

### Flujo de Datos (BLoC Pattern)

```
┌─────────────────────────────────────────────────────────────────┐
│                        FEATURE MODULE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐           │
│  │   Screen    │◀──▶│    BLoC     │◀──▶│ Repository │           │
│  │  (Widget)    │    │  (State)    │    │             │           │
│  └─────────────┘    └──────┬──────┘    └──────┬──────┘           │
│                            │                  │                   │
│                            ▼                  ▼                   │
│                    ┌─────────────┐    ┌─────────────┐            │
│                    │   Events    │    │  Data Source│            │
│                    │             │    │  (API/Local)│            │
│                    └─────────────┘    └─────────────┘            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Arquitectura Backend (Node.js)

### Estructura de Carpetas

```
backend/src/
├── server.js                  # Entry point
│
├── config/
│   ├── db.js                  # Conexión a MySQL
│   └── env.js                 # Variables de entorno
│
├── routes/
│   ├── index.js              # Router principal
│   ├── authRoutes.js         # Rutas de autenticación
│   └── negocioRoutes.js     # Rutas de negocios
│
├── controllers/
│   ├── authController.js    # Lógica de autenticación
│   └── negocioController.js  # Lógica de negocios
│
├── services/
│   ├── authService.js       # Servicios de auth
│   └── negocioService.js     # Servicios de negocios
│
├── repositories/
│   ├── userRepository.js    # Acceso a datos usuario
│   └── negocioRepository.js # Acceso a datos negocio
│
├── middleware/
│   ├── auth.js              # Middleware de autenticación
│   ├── errorHandler.js      # Manejo de errores
│   └── validator.js         # Validación de inputs
│
├── models/
│   ├── User.js              # Modelo de usuario
│   └── Negocio.js          # Modelo de negocio
│
└── utils/
    ├── logger.js           # Logging
    └── responseHelper.js   # Helper de respuestas
```

### Patrón MVC Simplificado

```
┌─────────────────────────────────────────────────────────────────┐
│                         REQUEST FLOW                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Client ──▶ Routes ──▶ Middleware ──▶ Controller ──▶ Service   │
│                                                         │       │
│                                                         ▼       │
│                                                    Repository    │
│                                                         │       │
│                                                         ▼       │
│                                                    Database     │
│                                                         │       │
│                                                         ▼       │
│  Client ◀── Response ◀── Controller ◀── Service ◀──── Repository│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Patrones de Diseño

### Frontend Patterns

| Patrón | Uso | Implementación |
|--------|-----|----------------|
| Feature First | Organización de código | Carpetas por feature |
| BLoC | State Management | flutter_bloc package |
| Repository | Acceso a datos | Abstraction layer |
| Dependency Injection | Inyección de dependencias | get_it / Provider |

### Backend Patterns

| Patrón | Uso | Implementación |
|--------|-----|----------------|
| MVC | Arquitectura | Controllers/Services/Models |
| Repository | Acceso a datos | Separación lógica/DB |
| Middleware | Cross-cutting concerns | Express middleware |
| Singleton | Conexión a DB | Pool de conexiones |

---

## 5. Seguridad de la Aplicación

### Autenticación

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO DE AUTENTICACIÓN                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Usuario envía credenciales                                   │
│     POST /api/auth/login { email, password }                     │
│                                                                 │
│  2. Server valida credenciales                                   │
│     - Verificar email existe                                    │
│     - Comparar password con bcrypt hash                         │
│                                                                 │
│  3. Server genera JWT token                                      │
│     - Payload: { userId, role, exp }                           │
│     - Expiración: 24 horas                                      │
│                                                                 │
│  4. Client almacena token                                       │
│     - SecureStorage para Flutter                                 │
│                                                                 │
│  5. Requests subsecuentes incluyen token                        │
│     Authorization: Bearer <token>                               │
│                                                                 │
│  6. Server valida token en cada request                          │
│     - Verificar firma                                           │
│     - Verificar expiración                                      │
│     - Extraer userId del payload                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Rate Limiting

| Endpoint | Límite | Ventana |
|----------|--------|---------|
| /api/auth/* | 10 req | 1 minuto |
| /api/* | 100 req | 1 minuto |
| /api/negocios/filtrar | 30 req | 1 minuto |

---

## 6. Manejo de Errores

### Estrategia de Errores

```javascript
// Categorías de error
const ErrorTypes = {
    VALIDATION_ERROR: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_ERROR: 500
};

// Middleware de manejo de errores
app.use((err, req, res, next) => {
    const statusCode = err.statusCode || 500;
    const message = err.message || 'Error interno del servidor';
    
    res.status(statusCode).json({
        success: false,
        error: {
            message,
            code: err.code,
            ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
        }
    });
});
```

---

## 7. Logging y Monitoreo

### Estrategia de Logging

| Nivel | Uso | Ejemplo |
|-------|-----|---------|
| error | Errores que requieren acción | DB connection failed |
| warn | Situaciones inesperadas | Rate limit approaching |
| info | Eventos importantes | New user registered |
| debug | Información de debug | Request/Response bodies |

### Herramientas

| Componente | Herramienta |
|------------|-------------|
| Backend Logging | Winston |
| Error Tracking | Sentry |
| APM | Clinic.js |
| Uptime | UptimeRobot |
| Frontend Analytics | Firebase Analytics |

---

## 8. Diagramas de Secuencia

### Búsqueda de Comida

```
┌─────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────┐
│  Flutter │     │   HTTP   │     │ Controller│     │ Service │     │  DB  │
└────┬────┘     └────┬─────┘     └─────┬────┘     └─────┬────┘     └──┬───┘
     │               │                 │                │              │
     │ 1.get('/filtrar')               │                │              │
     │───────────▶│                   │                │              │
     │            │ 2.get('/filtrar')│                │              │
     │            │────────────────▶│                │              │
     │            │                  │ 3.filtrar()     │              │
     │            │                  │────────────────▶│              │
     │            │                  │                 │ 4.SELECT...  │
     │            │                  │                 │─────────────▶│
     │            │                  │                 │◀─────────────│
     │            │                  │◀────────────────│              │
     │            │◀────────────────│                  │              │
     │◀───────────│                  │                  │              │
     │            │                  │                  │              │
     │ 5.Display Results             │                  │              │
     │            │                  │                  │              │
```

---

## 9. Consideraciones de Rendimiento

### Frontend

| Optimización | Implementación |
|-------------|----------------|
| Lazy Loading | Code splitting por feature |
| Image Caching | cached_network_image |
| List Virtualization | ListView.builder |
| State Optimization | Selective rebuilds con BLoC |

### Backend

| Optimización | Implementación |
|-------------|----------------|
| Connection Pool | mysql2 pool con 10 conexiones |
| Query Optimization | Índices apropiados |
| Response Caching | Cache en memoria |
| Compression | gzip middleware |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
