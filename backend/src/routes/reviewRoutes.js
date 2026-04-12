const express = require('express');
const router = express.Router();
const { crearReseña } = require('../controllers/reviewController');
router.post('/agregar', crearReseña);
module.exports = router;
