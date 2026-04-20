// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const router = express.Router();
const perfilController = require('../controllers/perfilController');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);
router.get('/', perfilController.obtenerPerfil);

module.exports = router;
