// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const cors = require('cors'); // <-- 1. Importamos cors
const app = express();
require('dotenv').config();

const PORT = process.env.PORT || 3000;
const negocioRoutes = require('./routes/negocioRoutes');

// --- Middlewares ---
app.use(cors()); // <-- 2. Habilitamos cors para permitir conexiones desde Flutter Web
app.use(express.json());

// --- Rutas ---
app.get('/api', (req, res) => {
    res.json({ mensaje: 'API de ComeSur en línea y funcionando.' });
});

app.use('/api/negocios', negocioRoutes);

app.listen(PORT, () => {
    console.log(`Servidor de ComeSur ejecutándose en el puerto ${PORT}`);
});