# ComeSur - Plan de Pruebas

## 1. Introducción

### Objetivo
Este documento define la estrategia de pruebas para la aplicación ComeSur, garantizando que todas las funcionalidades implementadas cumplan con los requisitos especificados y proporcionen una experiencia de usuario de calidad.

### Alcance
- **En alcance:** Aplicación móvil Flutter (frontend) y API REST (backend)
- **Fuera de alcance:** Integraciones de terceros no implementadas, automatización de infraestructura

---

## 2. Estrategia de Pruebas

### Pirámide de Pruebas

```
                    ┌─────────────┐
                    │     E2E     │  10%
                    │   (Cypress) │
                    ├─────────────┤
                    │  Integración│  30%
                    │  (Supertest)│
                    ├─────────────┤
                    │   Unidad    │  60%
                    │ (flutter_test│
                    │   Jest)     │
                    └─────────────┘
```

### Niveles de Prueba

| Nivel | Herramienta | Cobertura Objetivo | Responsabilidad |
|-------|-------------|-------------------|-----------------|
| Unidad | flutter_test | 80% | Equipo Frontend |
| Integración | supertest | 70% | Equipo Backend |
| E2E | Flutter Driver/Cypress | 100% flujos críticos | QA |

---

## 3. Ambiente de Pruebas

### Infraestructura

| Ambiente | Propósito | URL | Base de Datos |
|----------|-----------|-----|---------------|
| Desarrollo | Debug local | localhost:3000 | MySQL local |
| Testing | Pruebas automatizadas | localhost:3001 | MySQL test |
| Staging | Validación pre-producción | api-staging.comesur.app | RDS MySQL |

### Datos de Prueba

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| Usuarios de prueba | 10 | Para login y operaciones |
| Negocios | 20 | Con menú variado |
| Comidas | 100 | Variedad de precios y categorías |
| Calificaciones | 50 | Para tests de rating |

---

## 4. Tipos de Prueba

### 4.1 Pruebas Funcionales

| ID | Tipo | Descripción |
|----|------|-------------|
| TF-01 | Unidad | Validación de formulario de login |
| TF-02 | Unidad | Lógica de filtros de búsqueda |
| TF-03 | Integración | Endpoint /api/negocios/filtrar |
| TF-04 | E2E | Flujo completo: Login → Buscar → Ver resultados |

### 4.2 Pruebas de Interfaz

| ID | Tipo | Descripción |
|----|------|-------------|
| TI-01 | Visual | Renderizado correcto de Login Screen |
| TI-02 | Visual | Renderizado de Filter Screen |
| TI-03 | Visual | Renderizado de Results Screen |
| TI-04 | Responsive | Adaptación a diferentes tamaños de pantalla |

### 4.3 Pruebas de Rendimiento

| ID | Tipo | Objetivo |
|----|------|----------|
| TR-01 | Carga | API responde < 500ms con 100 requests concurrentes |
| TR-02 | Inicio | App inicia < 3 segundos en dispositivo medio |
| TR-03 | Scroll | Lista de resultados con scroll fluido a 60fps |

### 4.4 Pruebas de Seguridad

| ID | Tipo | Descripción |
|----|------|-------------|
| TS-01 | Auth | Token JWT expirado es rechazado |
| TS-02 | Auth | SQL injection en búsqueda es bloqueado |
| TS-03 | Input | XSS en comentarios es sanitizado |

---

## 5. Casos de Prueba Prioritarios

### P0 - Críticos (Must Pass)

1. **TC-001:** Login con credenciales válidas
2. **TC-002:** Login con credenciales inválidas
3. **TC-003:** Búsqueda de comida por tipo
4. **TC-004:** Filtrar por presupuesto máximo
5. **TC-005:** Ver resultados de búsqueda
6. **TC-006:** Sin resultados - mensaje de empty state

### P1 - Altos

7. **TC-007:** Registro de nuevo usuario
8. **TC-008:** Logout exitoso
9. **TC-009:** Pull-to-refresh en resultados
10. **TC-010:** Navegación entre pantallas

### P2 - Medios

11. **TC-011:** Marcar negocio como favorito
12. **TC-012:** Ver detalle de negocio
13. **TC-013:** Calificar un negocio
14. **TC-014:** Ver calificaciones existentes

---

## 6. Schedule de Pruebas

### Sprint 1 (Completado)

| Fecha | Actividad | Estado |
|-------|-----------|--------|
| 2026-03-18 | Pruebas de login | ✅ Pass |
| 2026-03-19 | Pruebas de filtro básico | ✅ Pass |

### Sprint 2 (En Curso)

| Fecha | Actividad | Responsable | Estado |
|-------|-----------|-------------|--------|
| 2026-03-24 | Pruebas de resultados | QA Dev | 🔄 En curso |
| 2026-03-25 | Pruebas E2E | QA Dev | 📋 Pendiente |
| 2026-03-26 | Reporte de defectos | QA Lead | 📋 Pendiente |

### Sprint 3 (Planificado)

| Fecha | Actividad |
|-------|-----------|
| 2026-04-01 | Pruebas de registro |
| 2026-04-02 | Pruebas de favoritos |
| 2026-04-03 | Pruebas de calificaciones |

---

## 7. Criterios de Entrada/Salida

### Criterios de Entrada
- Código mergeado en branch de feature
- Lint y typecheck passing
- Unit tests passing
- Build exitoso

### Criterios de Salida
- 0 defectos P0 abiertos
- Cobertura mínima 70%
- Aprobación de QA Lead
- Documentación actualizada

---

## 8. Gestión de Defectos

### Severidad

| Nivel | Descripción | SLA |
|-------|-------------|-----|
| Critical | App no funcional | 4 horas |
| High | Funcionalidad principal afectada | 24 horas |
| Medium | Funcionalidad secundaria afectada | 72 horas |
| Low | Mejora cosmética | Sprint siguiente |

### Flujo de Defectos

```
Nuevo → Asignado → En Progreso → Resuelto → Verificado → Cerrado
         ↓
       No es bug / No se reproduce / Duplicate
```

---

## 9. Herramientas y Reportes

### Herramientas

| Propósito | Herramienta |
|-----------|-------------|
| Unit Testing | flutter_test |
| Integración API | Postman / supertest |
| E2E | flutter_driver |
| Cobertura | coverage |
| Bug Tracking | GitHub Issues |

### Reportes

| Reporte | Frecuencia | Destinatarios |
|---------|------------|---------------|
| Ejecución de tests | Diaria | Equipo |
| Cobertura | Semanal | Team Lead |
| Defectos | Por sprint | Product Owner |
| Calidad final | Pre-release | Stakeholders |

---

## 10. Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Ambiente de pruebas inestable | Media | Alto | Scripts de setup automático |
| Datos de prueba insuficientes | Baja | Medio | Seeders automatizados |
| Cambios de API sin notificar | Media | Alto | Comunicación diaria |
| Device lab limitado | Alta | Medio | Testing en dispositivos reales prioritario |

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
*Autor: Equipo de QA ComeSur*
