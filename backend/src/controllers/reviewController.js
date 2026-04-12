const db = require('../config/db');
const crearReseña = async (req, res) => {
    try {
        const { negocio_id, usuario_id, calificacion, comentario } = req.body;
        const query = `INSERT INTO Reseña (negocio_id, usuario_id, calificacion, comentario, fecha) VALUES (?, ?, ?, ?, NOW())`;
        await db.execute(query, [negocio_id, usuario_id, calificacion, comentario]);
        res.status(201).json({ mensaje: '¡Reseña publicada con éxito!' });
    } catch (error) {
        res.status(500).json({ mensaje: 'Error al publicar la reseña' });
    }
};
module.exports = { crearReseña };
