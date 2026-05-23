// Alan Yael Fonseca Ruiz
const db = require('../config/db');
const logger = require('../config/logger');

const filtrarComida = async (req, res) => {
    try {
        const { tipoComida, presupuesto } = req.query;

        if (presupuesto && parseFloat(presupuesto) <= 0) {
            return res.status(400).json({
                success: false,
                error: {
                    message: "El presupuesto debe ser mayor a 0",
                    code: "VALIDATION_ERROR"
                }
            });
        }
        
        let query = `
            SELECT p.id AS producto_id, p.nombre AS platillo, p.precio,
                   n.id AS negocio_id, n.nombre AS negocio, n.calificacionPromedio,
                   n.latitud, n.longitud, n.direccion
            FROM Producto p
            JOIN Negocio n ON p.negocio_id = n.id
            WHERE p.disponible = true
        `;
        const queryParams = [];

        if (tipoComida) {
            // Buscar en la categoría del negocio o en el nombre del platillo
            query += ` AND (n.tipoComida LIKE ? OR p.nombre LIKE ?)`;
            queryParams.push(`%${tipoComida}%`, `%${tipoComida}%`);
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

        // Incrementar contador de vistas (silenciosamente para no bloquear la respuesta)
        db.execute('UPDATE Negocio SET totalVistas = totalVistas + 1 WHERE id = ?', [parsedId]).catch(() => {});

        // Obtener info del negocio
        const [negocios] = await db.execute(
            `SELECT id, nombre, descripcion, tipoComida AS categoria,
                    calificacionPromedio, direccion,
                    latitud, longitud,
                    horarioApertura, horarioCierre, menuDelDia
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

        // Parsear menuDelDia si existe
        let menuDelDia = [];
        if (negocio.menuDelDia) {
            try { menuDelDia = JSON.parse(negocio.menuDelDia); } catch (_) {}
        }

        res.status(200).json({
            success: true,
            data: {
                ...negocio,
                menu,
                resenas,
                menuDelDia,
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

// GET /api/negocios/mio - Obtener el negocio del dueño autenticado
const obtenerMiNegocio = async (req, res) => {
    const usuarioId = req.usuario.id;
    try {
        const [negocios] = await db.execute(
            `SELECT id, nombre, descripcion, tipoComida AS categoria,
                    calificacionPromedio, direccion, horarioApertura, horarioCierre,
                    menuDelDia
             FROM Negocio WHERE dueno_id = ?`,
            [usuarioId]
        );
        if (negocios.length === 0) {
            return res.status(404).json({
                success: false,
                error: { message: 'No tienes un negocio registrado', code: 'NOT_FOUND' }
            });
        }
        const negocio = negocios[0];
        const [menu] = await db.execute(
            'SELECT id, nombre, descripcion, precio, disponible FROM Producto WHERE negocio_id = ? ORDER BY nombre ASC',
            [negocio.id]
        );

        // Parsear menuDelDia
        let menuDelDia = [];
        if (negocio.menuDelDia) {
            try { menuDelDia = JSON.parse(negocio.menuDelDia); } catch (_) {}
        }

        res.status(200).json({ success: true, data: { ...negocio, menu, menuDelDia } });
    } catch (error) {
        logger.error('Error al obtener mi negocio', { error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// GET /api/negocios/:id/dashboard - Estadísticas del negocio para el dueño
const obtenerDashboard = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    if (isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'ID inválido', code: 'VALIDATION_ERROR' } });
    }

    try {
        const [negocioRows] = await db.execute(
            'SELECT dueno_id, COALESCE(totalVistas, 0) AS totalVistas FROM Negocio WHERE id = ?', [parsedId]
        );
        if (negocioRows.length === 0) {
            return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        }
        if (negocioRows[0].dueno_id !== req.usuario.id) {
            return res.status(403).json({ success: false, error: { message: 'No tienes permiso para ver este dashboard', code: 'FORBIDDEN' } });
        }

        const [[{ totalFavoritos }]] = await db.execute(
            'SELECT COUNT(*) AS totalFavoritos FROM Favorito WHERE negocio_id = ?', [parsedId]
        );
        const [[{ totalResenas, promedioCalificacion }]] = await db.execute(
            'SELECT COUNT(*) AS totalResenas, AVG(calificacion) AS promedioCalificacion FROM Resena WHERE negocio_id = ?', [parsedId]
        );
        const [[{ totalProductos, productosDisponibles }]] = await db.execute(
            'SELECT COUNT(*) AS totalProductos, SUM(disponible) AS productosDisponibles FROM Producto WHERE negocio_id = ?', [parsedId]
        );

        logger.info('Dashboard consultado', { negocio_id: parsedId });
        res.status(200).json({
            success: true,
            data: {
                totalFavoritos,
                totalResenas,
                promedioCalificacion: promedioCalificacion ? parseFloat(promedioCalificacion).toFixed(2) : '0.00',
                totalProductos,
                productosDisponibles: productosDisponibles || 0,
                totalVistas: negocioRows[0].totalVistas,
            }
        });
    } catch (error) {
        logger.error('Error al obtener dashboard', { negocio_id: parsedId, error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// Helper para verificar que el negocio pertenece al usuario autenticado
const _verificarDueno = async (negocioId, usuarioId) => {
    const [rows] = await db.execute('SELECT dueno_id FROM Negocio WHERE id = ?', [negocioId]);
    if (rows.length === 0) return { error: 'NOT_FOUND' };
    if (rows[0].dueno_id !== usuarioId) return { error: 'FORBIDDEN' };
    return { ok: true };
};

// POST /api/negocios/:id/productos - Agregar platillo al menú
const agregarProducto = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    if (isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'ID inválido', code: 'VALIDATION_ERROR' } });
    }

    const { nombre, descripcion, precio } = req.body;
    if (!nombre || precio === undefined || precio === null) {
        return res.status(400).json({ success: false, error: { message: 'Nombre y precio son requeridos', code: 'VALIDATION_ERROR' } });
    }
    const parsedPrecio = parseFloat(precio);
    if (isNaN(parsedPrecio) || parsedPrecio <= 0) {
        return res.status(400).json({ success: false, error: { message: 'El precio debe ser mayor a 0', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        const [result] = await db.execute(
            'INSERT INTO Producto (negocio_id, nombre, descripcion, precio, disponible) VALUES (?, ?, ?, ?, TRUE)',
            [parsedId, nombre.trim(), descripcion ? descripcion.trim() : null, parsedPrecio]
        );

        logger.info('Producto agregado', { negocio_id: parsedId, nombre });
        res.status(201).json({ success: true, data: { id: result.insertId, negocio_id: parsedId, nombre: nombre.trim(), descripcion: descripcion || null, precio: parsedPrecio, disponible: true } });
    } catch (error) {
        logger.error('Error al agregar producto', { error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// PUT /api/negocios/:id/productos/:productoId - Actualizar platillo
const actualizarProducto = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    const parsedProductoId = parseInt(req.params.productoId, 10);
    if (isNaN(parsedId) || parsedId <= 0 || isNaN(parsedProductoId) || parsedProductoId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'IDs inválidos', code: 'VALIDATION_ERROR' } });
    }

    const { nombre, descripcion, precio } = req.body;
    if (!nombre || precio === undefined || precio === null) {
        return res.status(400).json({ success: false, error: { message: 'Nombre y precio son requeridos', code: 'VALIDATION_ERROR' } });
    }
    const parsedPrecio = parseFloat(precio);
    if (isNaN(parsedPrecio) || parsedPrecio <= 0) {
        return res.status(400).json({ success: false, error: { message: 'El precio debe ser mayor a 0', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        const [result] = await db.execute(
            'UPDATE Producto SET nombre = ?, descripcion = ?, precio = ? WHERE id = ? AND negocio_id = ?',
            [nombre.trim(), descripcion ? descripcion.trim() : null, parsedPrecio, parsedProductoId, parsedId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: { message: 'Producto no encontrado', code: 'NOT_FOUND' } });
        }

        logger.info('Producto actualizado', { producto_id: parsedProductoId, negocio_id: parsedId });
        res.status(200).json({ success: true, data: { id: parsedProductoId, nombre: nombre.trim(), descripcion: descripcion || null, precio: parsedPrecio } });
    } catch (error) {
        logger.error('Error al actualizar producto', { error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// DELETE /api/negocios/:id/productos/:productoId - Eliminar platillo
const eliminarProducto = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    const parsedProductoId = parseInt(req.params.productoId, 10);
    if (isNaN(parsedId) || parsedId <= 0 || isNaN(parsedProductoId) || parsedProductoId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'IDs inválidos', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        const [result] = await db.execute(
            'DELETE FROM Producto WHERE id = ? AND negocio_id = ?',
            [parsedProductoId, parsedId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: { message: 'Producto no encontrado', code: 'NOT_FOUND' } });
        }

        logger.info('Producto eliminado', { producto_id: parsedProductoId, negocio_id: parsedId });
        res.status(200).json({ success: true, data: { message: 'Producto eliminado correctamente' } });
    } catch (error) {
        logger.error('Error al eliminar producto', { error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// PATCH /api/negocios/:id/productos/:productoId/disponibilidad - Toggle disponibilidad
const toggleDisponibilidad = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    const parsedProductoId = parseInt(req.params.productoId, 10);
    if (isNaN(parsedId) || parsedId <= 0 || isNaN(parsedProductoId) || parsedProductoId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'IDs inválidos', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        const [result] = await db.execute(
            'UPDATE Producto SET disponible = NOT disponible WHERE id = ? AND negocio_id = ?',
            [parsedProductoId, parsedId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, error: { message: 'Producto no encontrado', code: 'NOT_FOUND' } });
        }

        const [[producto]] = await db.execute('SELECT disponible FROM Producto WHERE id = ?', [parsedProductoId]);
        logger.info('Disponibilidad cambiada', { producto_id: parsedProductoId, disponible: producto.disponible });
        res.status(200).json({ success: true, data: { id: parsedProductoId, disponible: !!producto.disponible } });
    } catch (error) {
        logger.error('Error al cambiar disponibilidad', { error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// GET /api/negocios/:id/estadisticas - Distribución y tendencias de calificaciones para el dueño
const obtenerEstadisticas = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    if (isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'ID inválido', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        // Contadores generales
        const [[{ totalFavoritos }]] = await db.execute(
            'SELECT COUNT(*) AS totalFavoritos FROM Favorito WHERE negocio_id = ?', [parsedId]
        );
        const [[{ totalResenas, promedioCalificacion }]] = await db.execute(
            'SELECT COUNT(*) AS totalResenas, AVG(calificacion) AS promedioCalificacion FROM Resena WHERE negocio_id = ?', [parsedId]
        );
        const [[{ totalVistas }]] = await db.execute(
            'SELECT COALESCE(totalVistas, 0) AS totalVistas FROM Negocio WHERE id = ?', [parsedId]
        );

        // Distribución de calificaciones (1★ a 5★)
        const [dist] = await db.execute(
            `SELECT calificacion, COUNT(*) AS cantidad
             FROM Resena WHERE negocio_id = ?
             GROUP BY calificacion ORDER BY calificacion`,
            [parsedId]
        );
        const distribucion = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
        dist.forEach(row => { distribucion[row.calificacion] = Number(row.cantidad); });

        // Tendencia mensual (últimos 6 meses)
        const [tendencia] = await db.execute(
            `SELECT
                DATE_FORMAT(fecha, '%Y-%m') AS periodo,
                COUNT(*) AS resenas,
                ROUND(AVG(calificacion), 2) AS promedio
             FROM Resena
             WHERE negocio_id = ? AND fecha >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
             GROUP BY periodo
             ORDER BY periodo ASC`,
            [parsedId]
        );

        logger.info('Estadísticas consultadas', { negocio_id: parsedId });
        res.status(200).json({
            success: true,
            data: {
                totalVistas,
                totalFavoritos,
                totalResenas,
                promedioCalificacion: promedioCalificacion ? parseFloat(promedioCalificacion).toFixed(2) : '0.00',
                distribucion,
                tendencia,
            }
        });
    } catch (error) {
        logger.error('Error al obtener estadísticas', { negocio_id: parsedId, error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// PATCH /api/negocios/:id/horario - Actualizar horario de apertura y cierre
const actualizarHorario = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    if (isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'ID inválido', code: 'VALIDATION_ERROR' } });
    }

    const { horarioApertura, horarioCierre } = req.body;
    // Aceptar null explícito para limpiar horario
    const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/;
    if (horarioApertura !== null && horarioApertura !== undefined && !timeRegex.test(horarioApertura)) {
        return res.status(400).json({ success: false, error: { message: 'Formato de horario inválido (HH:MM)', code: 'VALIDATION_ERROR' } });
    }
    if (horarioCierre !== null && horarioCierre !== undefined && !timeRegex.test(horarioCierre)) {
        return res.status(400).json({ success: false, error: { message: 'Formato de horario inválido (HH:MM)', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        await db.execute(
            'UPDATE Negocio SET horarioApertura = ?, horarioCierre = ? WHERE id = ?',
            [horarioApertura || null, horarioCierre || null, parsedId]
        );

        logger.info('Horario actualizado', { negocio_id: parsedId, horarioApertura, horarioCierre });
        res.status(200).json({
            success: true,
            data: { horarioApertura: horarioApertura || null, horarioCierre: horarioCierre || null }
        });
    } catch (error) {
        logger.error('Error al actualizar horario', { negocio_id: parsedId, error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

// PATCH /api/negocios/:id/menu-del-dia - Guardar los IDs de productos del menú del día
const actualizarMenuDelDia = async (req, res) => {
    const parsedId = parseInt(req.params.id, 10);
    if (isNaN(parsedId) || parsedId <= 0) {
        return res.status(400).json({ success: false, error: { message: 'ID inválido', code: 'VALIDATION_ERROR' } });
    }

    const { productoIds } = req.body;
    if (!Array.isArray(productoIds)) {
        return res.status(400).json({ success: false, error: { message: 'productoIds debe ser un arreglo', code: 'VALIDATION_ERROR' } });
    }
    // Validar que todos sean enteros positivos
    if (productoIds.some(id => !Number.isInteger(id) || id <= 0)) {
        return res.status(400).json({ success: false, error: { message: 'Todos los IDs deben ser enteros positivos', code: 'VALIDATION_ERROR' } });
    }

    try {
        const check = await _verificarDueno(parsedId, req.usuario.id);
        if (check.error === 'NOT_FOUND') return res.status(404).json({ success: false, error: { message: 'Negocio no encontrado', code: 'NOT_FOUND' } });
        if (check.error === 'FORBIDDEN') return res.status(403).json({ success: false, error: { message: 'No tienes permiso', code: 'FORBIDDEN' } });

        // Verificar que los productos pertenecen al negocio
        if (productoIds.length > 0) {
            const [productos] = await db.execute(
                `SELECT id FROM Producto WHERE negocio_id = ? AND id IN (${productoIds.map(() => '?').join(',')})`,
                [parsedId, ...productoIds]
            );
            if (productos.length !== productoIds.length) {
                return res.status(400).json({ success: false, error: { message: 'Algunos productos no pertenecen a este negocio', code: 'VALIDATION_ERROR' } });
            }
        }

        const menuJson = JSON.stringify(productoIds);
        await db.execute('UPDATE Negocio SET menuDelDia = ? WHERE id = ?', [menuJson, parsedId]);

        logger.info('Menú del día actualizado', { negocio_id: parsedId, cantidad: productoIds.length });
        res.status(200).json({ success: true, data: { menuDelDia: productoIds } });
    } catch (error) {
        logger.error('Error al actualizar menú del día', { negocio_id: parsedId, error: error.message });
        res.status(500).json({ success: false, error: { message: 'Error interno', code: 'INTERNAL_ERROR' } });
    }
};

module.exports = {
    filtrarComida,
    obtenerNegocio,
    obtenerMiNegocio,
    obtenerDashboard,
    obtenerEstadisticas,
    actualizarHorario,
    actualizarMenuDelDia,
    agregarProducto,
    actualizarProducto,
    eliminarProducto,
    toggleDisponibilidad,
};