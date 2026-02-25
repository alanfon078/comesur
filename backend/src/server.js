// Alan Yael Fonseca Ruiz
const express = require('express');
const app = express();
require('dotenv').config();

const PORT = process.env.PORT || 3000;
const negocioRoutes = require('./routes/negocioRoutes');

app.use(express.json());

app.get('/api', (req, res) => {
    res.json({ mensaje: 'API de ComeSur en línea y funcionando.' });
});

app.use('/api/negocios', negocioRoutes);

app.listen(PORT, () => {
    console.log(`Servidor de ComeSur ejecutándose en el puerto ${PORT}`);
});