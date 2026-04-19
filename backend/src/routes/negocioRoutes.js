// Alan Yael Fonseca Ruiz
const express = require('express');
const router = express.Router();
const negocioController = require('../controllers/negocioController');

router.get('/filtrar', negocioController.filtrarComida);
router.get('/:id', negocioController.obtenerNegocio);

module.exports = router;