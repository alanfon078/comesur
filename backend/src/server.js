// Autor: Alan Yael Fonseca Ruiz
const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config();

const PORT = process.env.PORT || 3000;

const negocioRoutes = require('./routes/negocioRoutes');
const authRoutes = require('./routes/authRoutes');
const favoritoRoutes = require('./routes/favoritoRoutes');
const resenaRoutes = require('./routes/resenaRoutes');
const perfilRoutes = require('./routes/perfilRoutes');

// --- Middlewares ---
app.use(cors());
app.use(express.json());

// --- Rutas ---
app.get('/api', (req, res) => {
    res.json({ mensaje: 'API de ComeSur en línea y funcionando.' });
});

app.use('/api/auth', authRoutes);
app.use('/api/negocios', negocioRoutes);
app.use('/api/favoritos', favoritoRoutes);
app.use('/api/resenas', resenaRoutes);
app.use('/api/perfil', perfilRoutes);

app.listen(PORT, () => {
    console.log(`Servidor de ComeSur ejecutándose en el puerto ${PORT}`);
});

// Para pruebas con Supertest, es importante exportar el objeto `app` de Express sin iniciar el servidor. 
// Esto permite que Supertest lo utilice directamente sin necesidad de que el servidor esté escuchando
//  en un puerto específico, lo cual puede causar conflictos durante las pruebas.

// 1. Envolver el app.listen en un condicional
// Jest automáticamente establece NODE_ENV en 'test'. 
// Esto evita que el servidor se encienda y bloquee el puerto durante las pruebas.
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`Servidor de ComeSur ejecutándose en el puerto ${PORT}`);
  });
}

// 2. EXPORTAR la app de Express para que Supertest la pueda utilizar
module.exports = app;