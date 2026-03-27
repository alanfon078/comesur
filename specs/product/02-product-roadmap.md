# ComeSur - Roadmap del Producto

## Resumen de Versiones

| Versión | Nombre | Fecha Planeada | Estado |
|---------|--------|----------------|--------|
| 1.0 | Foundation | Feb 2026 | ✅ Completado |
| 1.1 | Core Discovery | Mar 2026 | 🔄 En desarrollo |
| 2.0 | Social Features | May 2026 | 📋 Planificado |
| 3.0 | Business Tools | Ago 2026 | 📋 Planificado |

---

## Versión 1.0 - Foundation (Completado ✅)

### Objetivo
Establecer las bases técnicas y funcionales de la aplicación.

### Funcionalidades Entregadas

| ID | Funcionalidad | Sprint |
|----|---------------|--------|
| F01.1 | Estructura del proyecto Flutter | Sprint 1 |
| F01.2 | Tema claro/oscuro | Sprint 1 |
| F01.3 | Pantalla de Login básica | Sprint 2 |
| F01.4 | Pantalla de Filtros | Sprint 2 |
| F01.5 | Backend con Express | Sprint 3 |
| F01.6 | Endpoint de filtrado | Sprint 3 |

### Criterios de Aceptación

- [x] App compila en Android
- [x] Tema claro/oscuro funciona
- [x] Login naviga a Filtros
- [x] API responde con datos mock
- [x] Resultados se muestran en lista

---

## Versión 1.1 - Core Discovery (En Desarrollo 🔄)

### Objetivo
Complementar el flujo de discovery con resultados detallados y manejo de errores.

### Funcionalidades Planificadas

| ID | Funcionalidad | Prioridad | Estimación |
|----|---------------|-----------|------------|
| F02.1 | Pantalla de detalle de negocio | Alta | 3 días |
| F02.2 | Manejo de errores mejorado | Alta | 2 días |
| F02.3 | Estados de carga (loading) | Media | 1 día |
| F02.4 | Empty states personalizados | Media | 1 día |
| F02.5 | Historial de búsquedas | Baja | 2 días |

### Sprint Planning

#### Sprint 4 (1 semana)
- Pantalla de detalle de negocio
- Estados de carga

#### Sprint 5 (1 semana)
- Manejo de errores
- Empty states

#### Sprint 6 (1 semana)
- Historial de búsquedas
- Testing

### Criterios de Aceptación

- [ ] Detalle muestra información completa del negocio
- [ ] Loading spinners en todas las operaciones async
- [ ] Mensajes de error amigables para el usuario
- [ ] Empty state cuando no hay resultados

---

## Versión 2.0 - Social Features (Planificado 📋)

### Objetivo
Añadir funcionalidades sociales para aumentar engagement.

### Funcionalidades Planificadas

| ID | Funcionalidad | Prioridad | Estimación |
|----|---------------|-----------|------------|
| F03.1 | Sistema de favoritos | Alta | 5 días |
| F03.2 | Calificaciones (1-5 estrellas) | Alta | 4 días |
| F03.3 | Comentarios | Media | 3 días |
| F03.4 | Perfil de usuario | Media | 3 días |
| F03.5 | Login con Google | Media | 2 días |
| F03.6 | Login con Facebook | Baja | 2 días |

### Dependencias

- Requiere autenticación implementada (F01)
- Requiere modelo de usuario en BD

### Criterios de Aceptación

- [ ] Usuario puede marcar/desmarcar favoritos
- [ ] Favoritos persisten entre sesiones
- [ ] Usuario puede calificar (1-5)
- [ ] Usuario puede comentar
- [ ] Perfil muestra historial

---

## Versión 3.0 - Business Tools (Planificado 📋)

### Objetivo
Proporcionar herramientas para dueños de negocios.

### Funcionalidades Planificadas

| ID | Funcionalidad | Prioridad | Estimación |
|----|---------------|-----------|------------|
| F04.1 | Dashboard para negocios | Alta | 5 días |
| F04.2 | CRUD de menú | Alta | 4 días |
| F04.3 | Gestión de disponibilidad | Media | 3 días |
| F04.4 | Estadísticas básicas | Media | 3 días |
| F04.5 | Notificaciones de calificaciones | Baja | 2 días |

### Roles de Usuario Adicionales

| Rol | Descripción | Permisos |
|-----|-------------|----------|
| negocio | Dueño de local | Gestionar su negocio, ver estadísticas |
| admin | Administrador | Moderar contenido, gestionar usuarios |

### Criterios de Aceptación

- [ ] Negocio puede crear/editar menú
- [ ] Negocio puede marcar platillos disponibles/no disponibles
- [ ] Dashboard muestra calificaciones recibidas
- [ ] Admin puede moderar comentarios

---

## Métricas de Seguimiento

### Versión 1.x

| Métrica | Baseline | Target | Herramienta |
|---------|----------|--------|-------------|
| Crash Rate | N/A | < 1% | Firebase Crashlytics |
| ANR Rate | N/A | < 0.1% | Play Console |
| API Latency | N/A | < 500ms | APM |
| Build Time | N/A | < 5 min | CI/CD |

### Versión 2.0+

| Métrica | Target | Herramienta |
|---------|--------|-------------|
| DAU/MAU | > 30% | Analytics |
| Retention D7 | > 40% | Analytics |
| Session Length | > 2 min | Analytics |
| NPS | > 40 | Survey |

---

## Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Retraso en autenticación | Media | Alto | Implementar auth básico primero |
| Problemas de conectividad | Baja | Medio | Cache local, offline graceful |
| Escalabilidad de BD | Baja | Alto | Diseño de esquemas optimizado |
| Adopción baja | Media | Alto | Marketing en campus universitario |

---

## Decisions Log

| Fecha | Decisión | Justificación |
|-------|----------|---------------|
| Feb 2026 | Flutter sobre React Native | Curva de aprendizaje, single codebase |
| Feb 2026 | MySQL sobre MongoDB | Datos estructurados, relaciones |
| Mar 2026 | Express sobre NestJS | Simplicidad para MVP |
| Mar 2026 | Auth nativo vs Firebase | Control total, menor dependencia |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
*Próxima revisión: 2026-04-01*
