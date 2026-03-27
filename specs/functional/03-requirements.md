# ComeSur - Requisitos Funcionales

## 1. Identificación de Requisitos

### Prefijos

| Prefijo | Significado |
|---------|-------------|
| RF- | Requisito Funcional |
| RNF- | Requisito No Funcional |
| UI- | Requisito de Interfaz |
| OP- | Operativo |

---

## 2. Requisitos Funcionales

### RF-01: Autenticación de Usuarios

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-01.1 | Sistema debe permitir login con correo y contraseña | Alta |
| RF-01.2 | Sistema debe validar formato de correo electrónico | Alta |
| RF-01.3 | Sistema debe validar longitud mínima de contraseña (8 caracteres) | Alta |
| RF-01.4 | Sistema debe mantener sesión activa con tokens JWT | Alta |
| RF-01.5 | Sistema debe permitir login con Google OAuth | Media |
| RF-01.6 | Sistema debe permitir login con Facebook OAuth | Baja |
| RF-01.7 | Sistema debe permitir cerrar sesión | Alta |
| RF-01.8 | Sistema debe limpiar datos de sesión al cerrar | Alta |

---

### RF-02: Búsqueda y Filtrado

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-02.1 | Sistema debe permitir buscar por tipo de comida | Alta |
| RF-02.2 | Sistema debe permitir filtrar por presupuesto máximo | Media |
| RF-02.3 | Sistema debe ordenar resultados por calificación descendente | Alta |
| RF-02.4 | Sistema debe mostrar mensaje cuando no hay resultados | Alta |
| RF-02.5 | Sistema debe manejar errores de conexión | Alta |
| RF-02.6 | Sistema debe mostrar indicador de carga durante búsqueda | Alta |
| RF-02.7 | Sistema debe permitir modificar filtros y repetir búsqueda | Alta |

---

### RF-03: Visualización de Resultados

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-03.1 | Sistema debe mostrar lista scrolleable de resultados | Alta |
| RF-03.2 | Cada resultado debe mostrar: platillo, precio, negocio, rating | Alta |
| RF-03.3 | Sistema debe formatear precio como moneda MXN | Alta |
| RF-03.4 | Sistema debe mostrar calificación con estrellas visuales | Alta |
| RF-03.5 | Sistema debe permitir tap en resultado para ver detalle | Media |
| RF-03.6 | Sistema debe mostrar imagen placeholder si no hay foto | Media |

---

### RF-04: Sistema de Favoritos

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-04.1 | Usuario debe poder marcar negocio como favorito | Media |
| RF-04.2 | Usuario debe poder desmarcar negocio de favoritos | Media |
| RF-04.3 | Sistema debe persistir favoritos en base de datos | Media |
| RF-04.4 | Sistema debe mostrar indicador visual en favoritos | Media |
| RF-04.5 | Sistema debe permitir ver lista de favoritos | Media |

---

### RF-05: Sistema de Calificaciones

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-05.1 | Usuario debe poder calificar negocio (1-5 estrellas) | Media |
| RF-05.2 | Usuario debe poder agregar comentario (opcional) | Media |
| RF-05.3 | Sistema debe calcular promedio de calificaciones | Media |
| RF-05.4 | Sistema debe permitir editar calificación existente | Baja |
| RF-05.5 | Sistema debe mostrar historial de calificaciones | Baja |

---

### RF-06: Gestión de Menú (Negocio)

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| RF-06.1 | Negocio debe poder agregar platillos al menú | Media |
| RF-06.2 | Negocio debe poder editar platillos existentes | Media |
| RF-06.3 | Negocio debe poder eliminar platillos | Media |
| RF-06.4 | Negocio debe poder marcar platillo como disponible/no disponible | Media |
| RF-06.5 | Sistema debe mostrar menú actualizado a usuarios | Media |

---

## 3. Requisitos No Funcionales

### RNF-01: Rendimiento

| ID | Descripción | Métrica | Meta |
|----|-------------|---------|------|
| RNF-01.1 | Tiempo de respuesta API búsqueda | < 500ms | 95% requests |
| RNF-01.2 | Tiempo de carga de pantalla | < 2s | WiFi/4G |
| RNF-01.3 | Tiempo de inicio de app | < 3s | cold start |
| RNF-01.4 | Animaciones | 60 FPS | Sin drops |

---

### RNF-02: Disponibilidad

| ID | Descripción | Meta |
|----|-------------|------|
| RNF-02.1 | Uptime del servicio | 99.5% |
| RNF-02.2 | Ventana de mantenimiento | 2-6 AM CST |
| RNF-02.3 | Plan de recuperación ante desastres | < 4 horas |

---

### RNF-03: Seguridad

| ID | Descripción | Implementación |
|----|-------------|---------------|
| RNF-03.1 | Comunicación cifrada | HTTPS/TLS 1.2+ |
| RNF-03.2 | Almacenamiento seguro de contraseñas | bcrypt hash |
| RNF-03.3 | Tokens con expiración | JWT 24h |
| RNF-03.4 | Validación de inputs | Sanitización server-side |
| RNF-03.5 | Rate limiting | 100 req/min por IP |

---

### RNF-04: Compatibilidad

| ID | Descripción | Meta |
|----|-------------|------|
| RNF-04.1 | Android mínimo | 5.0 (API 21) |
| RNF-04.2 | iOS mínimo | 12.0 |
| RNF-04.3 | Orientación | Portrait |
| RNF-04.4 | Idiomas | Español (es-MX) |

---

### RNF-05: Escalabilidad

| ID | Descripción | Meta |
|----|-------------|------|
| RNF-05.1 | Usuarios concurrentes | 500 |
| RNF-05.2 | Requests por segundo | 100 |
| RNF-05.3 | Capacidad de BD | 10,000 negocios |

---

## 4. Requisitos de Interfaz

### UI-01: Tema Claro

| ID | Descripción |
|----|-------------|
| UI-01.1 | Background blanco (#FFFFFF) |
| UI-01.2 | Texto primario negro (#000000) |
| UI-01.3 | Color primario verde (#4CAF50) |

### UI-02: Tema Oscuro

| ID | Descripción |
|----|-------------|
| UI-02.1 | Background negro (#000000) |
| UI-02.2 | Texto primario blanco (#FFFFFF) |
| UI-02.3 | Color primario verdeAccent |

### UI-03: Accesibilidad

| ID | Descripción | Prioridad |
|----|-------------|-----------|
| UI-03.1 | Soporte lectores de pantalla | Alta |
| UI-03.2 | Contraste mínimo 4.5:1 | Alta |
| UI-03.3 | Touch targets mínimo 48dp | Alta |
| UI-03.4 | Soporte scales de texto del sistema | Media |

---

## 5. Requisitos Operativos

### OP-01: Despliegue

| ID | Descripción | Frecuencia |
|----|-------------|------------|
| OP-01.1 | CI/CD con GitHub Actions | Cada push a main |
| OP-01.2 | Testing automatizado | Pre-deploy |
| OP-01.3 | Versionado semántico | Cada release |

### OP-02: Monitoreo

| ID | Descripción | Herramienta |
|----|-------------|------------|
| OP-02.1 | Logs de errores | Winston/Sentry |
| OP-02.2 | Métricas de uso | Firebase Analytics |
| OP-02.3 | Uptime monitoring | UptimeRobot |

---

## 6. Matriz de Trazabilidad

| Historia de Usuario | Requisitos |
|--------------------|-----------|
| US-01 Registro | RF-01.1, RF-01.2, RF-01.3 |
| US-02 Login | RF-01.1, RF-01.4, RNF-03.3 |
| US-05 Buscar comida | RF-02.1, RF-02.3, RF-02.6 |
| US-06 Filtrar presupuesto | RF-02.2, RF-02.3 |
| US-07 Ver resultados | RF-03.1, RF-03.2, RF-03.3 |
| US-10 Marcar favorito | RF-04.1, RF-04.2, RF-04.4 |
| US-12 Calificar | RF-05.1, RF-05.2, RF-05.3 |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
