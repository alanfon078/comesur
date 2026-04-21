// Autor: Alan Yael Fonseca Ruiz
const db = require('../config/db');
const logger = require('../config/logger');

// GET /api/perfil — Información del usuario autenticado
const obtenerPerfil = async (req, res) => {
    const usuarioId = req.usuario.id;

    try {
        // Datos básicos del usuario
        const [usuarios] = await db.execute(
            'SELECT id, nombre, correo, rol FROM Usuario WHERE id = ?',
            [usuarioId]
        );

        if (usuarios.length === 0) {
            return res.status(404).json({
                success: false,
                error: { message: 'Usuario no encontrado', code: 'NOT_FOUND' }
            });
        }

        const usuario = usuarios[0];

        // Historial de calificaciones del usuario
        const [calificaciones] = await db.execute(
            `SELECT r.id, r.calificacion, r.comentario, r.fecha,
                    n.id AS negocio_id, n.nombre AS negocio
             FROM Resena r
             JOIN Negocio n ON r.negocio_id = n.id
             WHERE r.usuario_id = ?
             ORDER BY r.fecha DESC`,
            [usuarioId]
        );

        // Favoritos del usuario
        const [favoritos] = await db.execute(
            `SELECT f.id, f.created_at,
                    n.id AS negocio_id, n.nombre, n.tipoComida AS categoria,
                    n.calificacionPromedio, n.direccion
             FROM Favorito f
             JOIN Negocio n ON f.negocio_id = n.id
             WHERE f.usuario_id = ?
             ORDER BY f.created_at DESC`,
            [usuarioId]
        );

        logger.info('Perfil consultado', { usuarioId });
        res.status(200).json({
            success: true,
            data: {
                ...usuario,
                calificaciones,
                favoritos
            }
        });
    } catch (error) {
        logger.error('Error al obtener perfil', { error: error.message, usuarioId });
        res.status(500).json({
            success: false,
            error: { message: 'Error al obtener el perfil', code: 'INTERNAL_ERROR' }
        });
    }
};

module.exports = { obtenerPerfil };
