const sql = require('mssql'); // <-- Usa mssql puro (sin msnodesqlv8)
const { Sequelize } = require('sequelize');

const config = {
  server: 'localhost',
   user: 'root',
   password: '12345',
  database: 'Caso3DB',
  options: {
    encrypt: false, // Para desarrollo local
    trustServerCertificate: true, // Necesario si no tienes certificado SSL
  },
  pool: {
    max: 10,
    min: 1,
    idleTimeoutMillis: 30000
  }
};

// Conexión para mssql (Stored Procedures)
let pool;
async function getConnection() {
  if (!pool) {
    pool = await sql.connect(config);
  }
  return pool;
}

// Conexión para Sequelize (ORM)
const sequelize = new Sequelize('Caso3DB', 'root', '12345', {
  host: 'localhost',
  dialect: 'mssql',
  dialectOptions: {
    options: {
      encrypt: false,
      trustServerCertificate: true
    }
  },
  logging: false // Desactiva logs SQL para mantener la consola limpia
});

// Verificar conexión de Sequelize
sequelize.authenticate()
  .then(() => console.log('Conexión Sequelize establecida'))
  .catch(err => console.error('Error en conexión Sequelize:', err));

// Cierra la conexión al terminar
process.on('beforeExit', async () => {
  if (pool) await pool.close();
  await sequelize.close();
});

module.exports = { getConnection, sql, sequelize};