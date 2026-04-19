// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const negocioController = require('../controllers/negocioController');

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

router.get('/filtrar', filtrarLimiter, negocioController.filtrarComida);
router.get('/:id', detalleLimiter, negocioController.obtenerNegocio);

module.exports = router;