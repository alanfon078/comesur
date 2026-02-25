// Autor: Alan Yael Fonseca Ruiz
const mysql = require('mysql2');

// Configuración del pool de conexiones para manejar múltiples usuarios simultáneos
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'root',
    database: process.env.DB_NAME || 'comesur_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Exportar promesas para usar async/await en los controladores
module.exports = pool.promise();