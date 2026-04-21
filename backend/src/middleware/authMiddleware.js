// Autor: Alan Yael Fonseca Ruiz
const jwt = require('jsonwebtoken');
const logger = require('../config/logger');

const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
            success: false,
            error: { message: 'Token de autenticación requerido', code: 'UNAUTHORIZED' }
        });
    }

    const token = authHeader.split(' ')[1];
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'comesur_secret_key');
        req.usuario = decoded;
        next();
    } catch (err) {
        logger.warn('Token inválido o expirado', { error: err.message });
        return res.status(401).json({
            success: false,
            error: { message: 'Token inválido o expirado', code: 'UNAUTHORIZED' }
        });
    }
};

const esDueno = (req, res, next) => {
    if (req.usuario.rol !== 'Dueño') {
        return res.status(403).json({
            success: false,
            error: { message: 'Acceso denegado. Solo propietarios de negocios pueden realizar esta acción.', code: 'FORBIDDEN' }
        });
    }
    next();
};

module.exports = { verifyToken, esDueno };
