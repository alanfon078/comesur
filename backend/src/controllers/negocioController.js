// Alan Yael Fonseca Ruiz
const db = require('../config/db');
const logger = require('../config/logger');

const filtrarComida = async (req, res) => {
    try {
        const { tipoComida, presupuesto } = req.query;
        let query = `
            SELECT p.id AS producto_id, p.nombre AS platillo, p.precio,
                   n.id AS negocio_id, n.nombre AS negocio, n.calificacionPromedio
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

        logger.info('Ejecutando búsqueda de comida', { tipoComida, presupuesto });
        const [resultados] = await db.execute(query, queryParams);

        if (resultados.length === 0) {
            logger.info('Búsqueda sin resultados', { tipoComida, presupuesto });
            return res.status(404).json({
                success: false,
                error: {
                    message: 'No hay comidas que coincidan con los filtros especificados',
                    code: 'NO_RESULTS_FOUND'
                }
            });
        }

        res.status(200).json({ success: true, data: resultados });
    } catch (error) {
        logger.error('Error al filtrar comida', { error: error.message, stack: error.stack });
        res.status(500).json({
            success: false,
            error: { message: 'Error al procesar la búsqueda', code: 'INTERNAL_ERROR' }
        });
    }
};

const obtenerNegocio = async (req, res) => {
    const { id } = req.params;

    const parsedId = parseInt(id, 10);
    if (!id || isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({
            success: false,
            error: { message: 'ID de negocio inválido', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        logger.info('Consultando detalle de negocio', { negocio_id: id });

        // Obtener info del negocio
        const [negocios] = await db.execute(
            `SELECT id, nombre, descripcion, tipoComida AS categoria,
                    calificacionPromedio, direccion,
                    horarioApertura, horarioCierre
             FROM Negocio WHERE id = ?`,
            [id]
        );

        if (negocios.length === 0) {
            logger.warn('Negocio no encontrado', { negocio_id: id });
            return res.status(404).json({
                success: false,
                error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' }
            });
        }

        const negocio = negocios[0];

        // Obtener menú del negocio
        const [menu] = await db.execute(
            `SELECT id, nombre, descripcion, precio, disponible
             FROM Producto WHERE negocio_id = ? ORDER BY nombre ASC`,
            [id]
        );

        // Obtener reseñas del negocio
        const [resenas] = await db.execute(
            `SELECT r.id, r.calificacion, r.comentario, r.fecha, u.nombre AS autor
             FROM Resena r
             JOIN Usuario u ON r.usuario_id = u.id
             WHERE r.negocio_id = ?
             ORDER BY r.fecha DESC`,
            [id]
        );

        res.status(200).json({
            success: true,
            data: {
                ...negocio,
                menu,
                resenas
            }
        });
    } catch (error) {
        logger.error('Error al obtener detalle de negocio', { negocio_id: id, error: error.message, stack: error.stack });
        res.status(500).json({
            success: false,
            error: { message: 'Error al obtener el detalle del negocio', code: 'INTERNAL_ERROR' }
        });
    }
};

module.exports = {
    filtrarComida,
    obtenerNegocio
};