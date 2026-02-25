// Alan Yael Fonseca Ruiz
const express = require('express');
const router = express.Router();
const negocioController = require('../controllers/negocioController');

router.get('/filtrar', negocioController.filtrarComida);

module.exports = router;