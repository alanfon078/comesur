# 3.3 Informe de Prueba de Software (Test Report)

**Proyecto:** ComeSur  
**Versión del Sistema:** 1.0.0+1  
**Fecha de Emisión:** 25 de Mayo de 2026  
**Responsable (QA Lead):** Erik Jesús Ramírez Díaz  

## 1. Resumen Ejecutivo
El presente informe detalla los resultados obtenidos tras la ejecución del ciclo de pruebas de Integración, Unidad y Aceptación (UAT) para la versión Release Candidate de ComeSur. El objetivo principal fue verificar el correcto funcionamiento del algoritmo de filtrado, el sistema de autenticación dual y el módulo de reseñas. El sistema es estable y cumple con el criterio de "Go/No-Go" para su despliegue inicial.

## 2. Alcance de las Pruebas
Se ejecutaron los casos de prueba definidos en el documento `02-test-cases.md`. 
* **Ambientes utilizados:** Emuladores Android (API 33), Instancia local de Node.js v20, Base de datos MySQL Community Server v8.0.
* **Herramientas:** Jest + Supertest (Backend), `flutter_test` (Frontend), Pruebas Manuales UAT.

## 3. Resumen de Ejecución y Métricas

| Módulo | Casos Totales | Pasados (Pass) | Fallidos (Fail) | Tasa de Éxito |
| :--- | :---: | :---: | :---: | :---: |
| Autenticación (AUTH) | 7 | 7 | 0 | 100% |
| Búsqueda y Filtros (SEARCH) | 6 | 6 | 0 | 100% |
| Resultados y Negocios | 5 | 4 | 1 | 80% |
| Favoritos y Reseñas | 5 | 5 | 0 | 100% |
| Endpoints API (Integración)| 5 | 5 | 0 | 100% |
| **Total General** | **28** | **27** | **1** | **96.4%** |

*Nota: La tasa de éxito general superó el umbral mínimo aceptable del 95% estipulado en el Plan de Pruebas.*

## 4. Defectos Encontrados (Bug Log)

| ID Defecto | Caso Relacionado | Severidad | Descripción del Problema | Estado Actual |
| :--- | :--- | :--- | :--- | :--- |
| BUG-001 | TC-RESULTS-001 | Menor | Las imágenes de placeholder de los negocios muestran un retraso visual (parpadeo) al hacer scroll rápido en la lista de resultados. | Resuelto (Se implementó caché de imágenes). |
| BUG-002 | TC-API-005 | Mayor | El Rate Limiter de Express estaba bloqueando peticiones legítimas al refrescar la lista varias veces mediante el pull-to-refresh. | Resuelto (Ajuste en `express-rate-limit` en el backend). |
| BUG-003 | TC-RESULTS-003 | Menor | Cuando dos negocios tienen la misma calificación exacta (ej. 4.5), el orden alfabético no se estaba respetando en la consulta SQL. | Abierto (Agendado para el próximo Sprint). |

## 5. Resultados de Pruebas de Aceptación (UAT)
Con base en la sesión de pruebas con usuarios finales realizada el 21 de Mayo de 2026:
* **Evaluador:** Eric Daniel Vázquez Moreno (Usuario Externo)
* **Total de pruebas ejecutadas:** 24
* **Pruebas exitosas:** 23
* **Porcentaje de éxito UAT:** 95.8%

## 6. Anexos y Evidencias de Ejecución

### 6.1 Pruebas de Integración (Backend)
![Evidencia de Pruebas Jest API](./evidencias/terminal_backend_pass.png)
*Figura 1: Ejecución exitosa de los casos de prueba de integración de la API para el filtrado de negocios.*

### 6.2 Pruebas Funcionales UI (Frontend)
![Evidencia Filtro Vacío](./evidencias/empty_state.png)
*Figura 2: Caso de prueba TC-SEARCH-003 mostrando el Empty State correctamente.*