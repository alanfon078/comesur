// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const perfilController = require('../controllers/perfilController');
const { verifyToken } = require('../middleware/authMiddleware');

const perfilLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 60,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

router.use(perfilLimiter);
router.use(verifyToken);
router.get('/', perfilController.obtenerPerfil);

module.exports = router;
