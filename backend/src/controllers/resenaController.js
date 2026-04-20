// Autor: Alan Yael Fonseca Ruiz
const db = require('../config/db');
const logger = require('../config/logger');

// Recalcula calificacionPromedio del negocio
const actualizarPromedio = async (negocioId) => {
    await db.execute(
        `UPDATE Negocio
         SET calificacionPromedio = (
             SELECT COALESCE(ROUND(AVG(calificacion), 2), 0)
             FROM Resena WHERE negocio_id = ?
         )
         WHERE id = ?`,
        [negocioId, negocioId]
    );
};

// POST /api/resenas — Crear o editar calificación (una por usuario por negocio)
const crearOActualizarResena = async (req, res) => {
    const usuarioId = req.usuario.id;
    const { negocio_id, calificacion, comentario } = req.body;

    if (!negocio_id || isNaN(parseInt(negocio_id)) || parseInt(negocio_id) <= 0) {
        return res.status(400).json({
            success: false,
            error: { message: 'ID de negocio inválido', code: 'VALIDATION_ERROR' }
        });
    }

    const cal = parseInt(calificacion, 10);
    if (!calificacion || isNaN(cal) || cal < 1 || cal > 5) {
        return res.status(400).json({
            success: false,
            error: { message: 'La calificación debe ser un número entre 1 y 5', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        // Verificar que el negocio existe
        const [negocios] = await db.execute('SELECT id FROM Negocio WHERE id = ?', [negocio_id]);
        if (negocios.length === 0) {
            return res.status(404).json({
                success: false,
                error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' }
            });
        }

        // Verificar si ya existe reseña del usuario para este negocio
        const [existente] = await db.execute(
            'SELECT id FROM Resena WHERE usuario_id = ? AND negocio_id = ?',
            [usuarioId, negocio_id]
        );

        let result;
        let statusCode;

        if (existente.length > 0) {
            // Editar reseña existente
            [result] = await db.execute(
                'UPDATE Resena SET calificacion = ?, comentario = ?, fecha = NOW() WHERE usuario_id = ? AND negocio_id = ?',
                [cal, comentario || null, usuarioId, negocio_id]
            );
            statusCode = 200;
            logger.info('Reseña actualizada', { usuarioId, negocio_id });
        } else {
            // Crear nueva reseña
            [result] = await db.execute(
                'INSERT INTO Resena (usuario_id, negocio_id, calificacion, comentario) VALUES (?, ?, ?, ?)',
                [usuarioId, negocio_id, cal, comentario || null]
            );
            statusCode = 201;
            logger.info('Reseña creada', { usuarioId, negocio_id });
        }

        // Actualizar promedio del negocio
        await actualizarPromedio(negocio_id);

        res.status(statusCode).json({
            success: true,
            data: {
                negocio_id,
                calificacion: cal,
                comentario: comentario || null
            }
        });
    } catch (error) {
        logger.error('Error al guardar reseña', { error: error.message, usuarioId });
        res.status(500).json({
            success: false,
            error: { message: 'Error al guardar la reseña', code: 'INTERNAL_ERROR' }
        });
    }
};

// GET /api/resenas/negocio/:id — Obtener calificación del usuario autenticado para un negocio
const obtenerMiResena = async (req, res) => {
    const usuarioId = req.usuario.id;
    const { id } = req.params;

    const parsedId = parseInt(id, 10);
    if (!id || isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({
            success: false,
            error: { message: 'ID de negocio inválido', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const [rows] = await db.execute(
            'SELECT id, calificacion, comentario, fecha FROM Resena WHERE usuario_id = ? AND negocio_id = ?',
            [usuarioId, parsedId]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: { message: 'Sin reseña previa', code: 'NOT_FOUND' }
            });
        }

        res.status(200).json({ success: true, data: rows[0] });
    } catch (error) {
        logger.error('Error al obtener reseña', { error: error.message });
        res.status(500).json({
            success: false,
            error: { message: 'Error al obtener la reseña', code: 'INTERNAL_ERROR' }
        });
    }
};

module.exports = { crearOActualizarResena, obtenerMiResena };
