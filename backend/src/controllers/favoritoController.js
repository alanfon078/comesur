// Autor: Alan Yael Fonseca Ruiz
const db = require('../config/db');
const logger = require('../config/logger');

// GET /api/favoritos — Favoritos del usuario autenticado
const obtenerFavoritos = async (req, res) => {
    const usuarioId = req.usuario.id;
    try {
        const [rows] = await db.execute(
            `SELECT f.id, f.created_at,
                    n.id AS negocio_id, n.nombre, n.tipoComida AS categoria,
                    n.calificacionPromedio, n.direccion
             FROM Favorito f
             JOIN Negocio n ON f.negocio_id = n.id
             WHERE f.usuario_id = ?
             ORDER BY f.created_at DESC`,
            [usuarioId]
        );
        res.status(200).json({ success: true, data: rows });
    } catch (error) {
        logger.error('Error al obtener favoritos', { error: error.message, usuarioId });
        res.status(500).json({
            success: false,
            error: { message: 'Error al obtener favoritos', code: 'INTERNAL_ERROR' }
        });
    }
};

// POST /api/favoritos — Agregar negocio a favoritos
const agregarFavorito = async (req, res) => {
    const usuarioId = req.usuario.id;
    const { negocio_id } = req.body;

    if (!negocio_id || isNaN(parseInt(negocio_id)) || parseInt(negocio_id) <= 0) {
        return res.status(400).json({
            success: false,
            error: { message: 'ID de negocio inválido', code: 'VALIDATION_ERROR' }
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

        const [result] = await db.execute(
            'INSERT IGNORE INTO Favorito (usuario_id, negocio_id) VALUES (?, ?)',
            [usuarioId, negocio_id]
        );

        if (result.affectedRows === 0) {
            return res.status(409).json({
                success: false,
                error: { message: 'El negocio ya está en tus favoritos', code: 'DUPLICATE_ENTRY' }
            });
        }

        logger.info('Favorito agregado', { usuarioId, negocio_id });
        res.status(201).json({ success: true, data: { id: result.insertId, negocio_id } });
    } catch (error) {
        logger.error('Error al agregar favorito', { error: error.message, usuarioId });
        res.status(500).json({
            success: false,
            error: { message: 'Error al agregar favorito', code: 'INTERNAL_ERROR' }
        });
    }
};

// DELETE /api/favoritos/:idNegocio — Quitar negocio de favoritos
const eliminarFavorito = async (req, res) => {
    const usuarioId = req.usuario.id;
    const { idNegocio } = req.params;

    const parsedId = parseInt(idNegocio, 10);
    if (!idNegocio || isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({
            success: false,
            error: { message: 'ID de negocio inválido', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const [result] = await db.execute(
            'DELETE FROM Favorito WHERE usuario_id = ? AND negocio_id = ?',
            [usuarioId, parsedId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                error: { message: 'Favorito no encontrado', code: 'NOT_FOUND' }
            });
        }

        logger.info('Favorito eliminado', { usuarioId, negocio_id: parsedId });
        res.status(200).json({ success: true, message: 'Favorito eliminado' });
    } catch (error) {
        logger.error('Error al eliminar favorito', { error: error.message, usuarioId });
        res.status(500).json({
            success: false,
            error: { message: 'Error al eliminar favorito', code: 'INTERNAL_ERROR' }
        });
    }
};

module.exports = { obtenerFavoritos, agregarFavorito, eliminarFavorito };
