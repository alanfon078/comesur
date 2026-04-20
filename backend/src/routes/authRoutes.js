// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const authController = require('../controllers/authController');

const authLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 10,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, error: { message: 'Demasiadas solicitudes, intenta más tarde', code: 'RATE_LIMIT_EXCEEDED' } }
});

router.post('/register', authLimiter, authController.register);
router.post('/login', authLimiter, authController.login);
router.post('/google', authLimiter, authController.loginGoogle);
router.post('/facebook', authLimiter, authController.loginFacebook);

module.exports = router;
