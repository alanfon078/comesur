// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const resenaController = require('../controllers/resenaController');
const { verifyToken } = require('../middleware/authMiddleware');

const resenaLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 20,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

router.use(verifyToken);
router.use(resenaLimiter);

router.post('/', resenaController.crearOActualizarResena);
router.get('/negocio/:id', resenaController.obtenerMiResena);

module.exports = router;
