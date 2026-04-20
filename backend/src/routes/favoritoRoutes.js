// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const favoritoController = require('../controllers/favoritoController');
const { verifyToken } = require('../middleware/authMiddleware');

const favoritoLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 50,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

router.use(favoritoLimiter);
router.use(verifyToken);

router.get('/', favoritoController.obtenerFavoritos);
router.post('/', favoritoController.agregarFavorito);
router.delete('/:idNegocio', favoritoController.eliminarFavorito);

module.exports = router;
