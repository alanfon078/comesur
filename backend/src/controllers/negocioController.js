// Alan Yael Fonseca Ruiz
const db = require('../config/db');

const filtrarComida = async (req, res) => {
    try {
        const { tipoComida, presupuesto } = req.query;
        let query = `
            SELECT p.nombre AS platillo, p.precio, n.nombre AS negocio, n.calificacionPromedio 
            FROM Producto p
            JOIN Negocio n ON p.negocio_id = n.id
            WHERE p.disponible = true
        `;
        const queryParams = [];

        if (tipoComida) {
            query += ` AND n.tipoComida LIKE ?`;
            queryParams.push(`%${tipoComida}%`);
        }

        if (presupuesto && !isNaN(presupuesto) && Number(presupuesto) > 0) {
            query += ` AND p.precio <= ?`;
            queryParams.push(Number(presupuesto));
        }

        query += ` ORDER BY n.calificacionPromedio DESC`;

        const [resultados] = await db.execute(query, queryParams);

        if (resultados.length === 0) {
            return res.status(404).json({
                mensaje: 'No hay comidas que coincidan con los filtros especificados'
            });
        }

        res.status(200).json(resultados);
    } catch (error) {
        res.status(500).json({ mensaje: 'Error al procesar la búsqueda' });
    }
};

module.exports = {
    filtrarComida
};