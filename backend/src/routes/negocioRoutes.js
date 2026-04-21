// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const negocioController = require('../controllers/negocioController');
const { verifyToken, esDueno } = require('../middleware/authMiddleware');

const filtrarLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 30,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

const detalleLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 100,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

const duenoLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 60,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

// Rutas públicas (solo lectura)
router.get('/filtrar', filtrarLimiter, negocioController.filtrarComida);

// Rutas protegidas para dueños de negocios
router.get('/mio', duenoLimiter, verifyToken, esDueno, negocioController.obtenerMiNegocio);
router.get('/:id/dashboard', duenoLimiter, verifyToken, esDueno, negocioController.obtenerDashboard);
router.get('/:id/estadisticas', duenoLimiter, verifyToken, esDueno, negocioController.obtenerEstadisticas);
router.patch('/:id/horario', duenoLimiter, verifyToken, esDueno, negocioController.actualizarHorario);
router.patch('/:id/menu-del-dia', duenoLimiter, verifyToken, esDueno, negocioController.actualizarMenuDelDia);
router.post('/:id/productos', duenoLimiter, verifyToken, esDueno, negocioController.agregarProducto);
router.put('/:id/productos/:productoId', duenoLimiter, verifyToken, esDueno, negocioController.actualizarProducto);
router.delete('/:id/productos/:productoId', duenoLimiter, verifyToken, esDueno, negocioController.eliminarProducto);
router.patch('/:id/productos/:productoId/disponibilidad', duenoLimiter, verifyToken, esDueno, negocioController.toggleDisponibilidad);

// Ruta de detalle pública (debe ir después de /mio y /filtrar)
router.get('/:id', detalleLimiter, negocioController.obtenerNegocio);

module.exports = router;