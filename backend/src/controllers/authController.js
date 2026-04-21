// Autor: Alan Yael Fonseca Ruiz
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const axios = require('axios');
const { OAuth2Client } = require('google-auth-library');
const db = require('../config/db');
const logger = require('../config/logger');

const JWT_SECRET = process.env.JWT_SECRET || 'comesur_secret_key';
const JWT_EXPIRES_IN = '24h';

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// Genera un JWT con los datos del usuario
const generarToken = (usuario) => {
    return jwt.sign(
        { id: usuario.id, nombre: usuario.nombre, correo: usuario.correo, rol: usuario.rol },
        JWT_SECRET,
        { expiresIn: JWT_EXPIRES_IN }
    );
};

// POST /api/auth/register
const register = async (req, res) => {
    const { nombre, correo, contrasena } = req.body;

    if (!nombre || !correo || !contrasena) {
        return res.status(400).json({
            success: false,
            error: { message: 'Nombre, correo y contraseña son requeridos', code: 'VALIDATION_ERROR' }
        });
    }
    const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!correo || typeof correo !== 'string' || correo.length > 120 || !EMAIL_REGEX.test(correo)) {
        return res.status(400).json({
            success: false,
            error: { message: 'Formato de correo inválido', code: 'VALIDATION_ERROR' }
        });
    }
    if (contrasena.length < 8) {
        return res.status(400).json({
            success: false,
            error: { message: 'La contraseña debe tener al menos 8 caracteres', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const [existente] = await db.execute('SELECT id FROM Usuario WHERE correo = ?', [correo]);
        if (existente.length > 0) {
            return res.status(409).json({
                success: false,
                error: { message: 'El correo ya está registrado', code: 'DUPLICATE_ENTRY' }
            });
        }

        const hash = await bcrypt.hash(contrasena, 10);
        const [result] = await db.execute(
            'INSERT INTO Usuario (nombre, correo, contrasena, rol) VALUES (?, ?, ?, ?)',
            [nombre, correo, hash, 'Estudiante']
        );

        const usuario = { id: result.insertId, nombre, correo, rol: 'Estudiante' };
        const token = generarToken(usuario);

        logger.info('Usuario registrado', { correo });
        res.status(201).json({ success: true, data: { usuario, token } });
    } catch (error) {
        logger.error('Error al registrar usuario', { error: error.message });
        res.status(500).json({
            success: false,
            error: { message: 'Error al registrar usuario', code: 'INTERNAL_ERROR' }
        });
    }
};

// POST /api/auth/login
const login = async (req, res) => {
    const { correo, contrasena } = req.body;

    if (!correo || !contrasena) {
        return res.status(400).json({
            success: false,
            error: { message: 'Correo y contraseña son requeridos', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const [rows] = await db.execute(
            'SELECT id, nombre, correo, contrasena, rol FROM Usuario WHERE correo = ?',
            [correo]
        );

        if (rows.length === 0) {
            return res.status(401).json({
                success: false,
                error: { message: 'Credenciales inválidas', code: 'UNAUTHORIZED' }
            });
        }

        const usuarioDB = rows[0];
        // Bloquear login con contraseña para cuentas creadas vía OAuth
        if (!usuarioDB.contrasena) {
            return res.status(401).json({
                success: false,
                error: { message: 'Esta cuenta fue creada con Google o Facebook. Por favor, inicia sesión con el método correspondiente.', code: 'OAUTH_ACCOUNT' }
            });
        }
        const valida = await bcrypt.compare(contrasena, usuarioDB.contrasena);
        if (!valida) {
            return res.status(401).json({
                success: false,
                error: { message: 'Credenciales inválidas', code: 'UNAUTHORIZED' }
            });
        }

        const usuario = { id: usuarioDB.id, nombre: usuarioDB.nombre, correo: usuarioDB.correo, rol: usuarioDB.rol };
        const token = generarToken(usuario);

        logger.info('Login exitoso', { correo });
        res.status(200).json({ success: true, data: { usuario, token } });
    } catch (error) {
        logger.error('Error al iniciar sesión', { error: error.message });
        res.status(500).json({
            success: false,
            error: { message: 'Error al iniciar sesión', code: 'INTERNAL_ERROR' }
        });
    }
};

// POST /api/auth/google
const loginGoogle = async (req, res) => {
    const { idToken } = req.body;
    if (!idToken) {
        return res.status(400).json({
            success: false,
            error: { message: 'idToken de Google requerido', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const ticket = await googleClient.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID,
        });
        const payload = ticket.getPayload();
        const { sub: googleId, email, name } = payload;

        // Buscar por google_id o correo
        let [rows] = await db.execute(
            'SELECT id, nombre, correo, rol FROM Usuario WHERE google_id = ? OR correo = ?',
            [googleId, email]
        );

        let usuario;
        if (rows.length > 0) {
            usuario = rows[0];
            // Vincular google_id si no estaba vinculado
            await db.execute('UPDATE Usuario SET google_id = ? WHERE id = ?', [googleId, usuario.id]);
        } else {
            // Crear cuenta nueva (sin contraseña - cuenta OAuth, no permite login con contraseña)
            const [result] = await db.execute(
                'INSERT INTO Usuario (nombre, correo, contrasena, rol, google_id) VALUES (?, ?, NULL, ?, ?)',
                [name, email, 'Estudiante', googleId]
            );
            usuario = { id: result.insertId, nombre: name, correo: email, rol: 'Estudiante' };
        }

        const token = generarToken(usuario);
        logger.info('Login con Google exitoso', { correo: email });
        res.status(200).json({ success: true, data: { usuario, token } });
    } catch (error) {
        logger.error('Error en login con Google', { error: error.message });
        res.status(401).json({
            success: false,
            error: { message: 'No se pudo verificar el token de Google', code: 'UNAUTHORIZED' }
        });
    }
};

// POST /api/auth/facebook
const loginFacebook = async (req, res) => {
    const { accessToken } = req.body;
    if (!accessToken) {
        return res.status(400).json({
            success: false,
            error: { message: 'accessToken de Facebook requerido', code: 'VALIDATION_ERROR' }
        });
    }

    try {
        const fbResponse = await axios.get('https://graph.facebook.com/me', {
            params: { fields: 'id,name,email', access_token: accessToken }
        });
        const { id: facebookId, name, email } = fbResponse.data;

        if (!email) {
            return res.status(400).json({
                success: false,
                error: { message: 'Facebook no proporcionó el correo electrónico', code: 'VALIDATION_ERROR' }
            });
        }

        // Buscar por facebook_id o correo
        let [rows] = await db.execute(
            'SELECT id, nombre, correo, rol FROM Usuario WHERE facebook_id = ? OR correo = ?',
            [facebookId, email]
        );

        let usuario;
        if (rows.length > 0) {
            usuario = rows[0];
            await db.execute('UPDATE Usuario SET facebook_id = ? WHERE id = ?', [facebookId, usuario.id]);
        } else {
            const [result] = await db.execute(
                'INSERT INTO Usuario (nombre, correo, contrasena, rol, facebook_id) VALUES (?, ?, NULL, ?, ?)',
                [name, email, 'Estudiante', facebookId]
            );
            usuario = { id: result.insertId, nombre: name, correo: email, rol: 'Estudiante' };
        }

        const token = generarToken(usuario);
        logger.info('Login con Facebook exitoso', { correo: email });
        res.status(200).json({ success: true, data: { usuario, token } });
    } catch (error) {
        logger.error('Error en login con Facebook', { error: error.message });
        res.status(401).json({
            success: false,
            error: { message: 'No se pudo verificar el token de Facebook', code: 'UNAUTHORIZED' }
        });
    }
};

module.exports = { register, login, loginGoogle, loginFacebook };
