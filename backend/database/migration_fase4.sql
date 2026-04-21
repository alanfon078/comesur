-- ============================================================
-- ComeSur - Migración Fase 4: Business Tools
-- Autor: Alan Yael Fonseca Ruiz
-- Fecha: 2026-04-21
-- ============================================================

USE comesur_db;

-- 1. Contador de vistas de cada negocio (para el dashboard del dueño)
ALTER TABLE Negocio
    ADD COLUMN IF NOT EXISTS totalVistas INT DEFAULT 0;

-- Nuevos endpoints REST disponibles (requieren rol 'Dueño' + JWT):
--   GET    /api/negocios/mio                                         -> Obtener mi negocio + menú + menuDelDia
--   GET    /api/negocios/:id/dashboard                               -> Estadísticas del negocio (incl. totalVistas)
--   GET    /api/negocios/:id/estadisticas                            -> Distribución y tendencias de calificaciones
--   PATCH  /api/negocios/:id/horario                                 -> Actualizar horario apertura/cierre
--   PATCH  /api/negocios/:id/menu-del-dia                            -> Actualizar menú del día (IDs de productos)
--   POST   /api/negocios/:id/productos                               -> Agregar platillo
--   PUT    /api/negocios/:id/productos/:productoId                   -> Editar platillo
--   DELETE /api/negocios/:id/productos/:productoId                   -> Eliminar platillo
--   PATCH  /api/negocios/:id/productos/:productoId/disponibilidad    -> Toggle disponibilidad
