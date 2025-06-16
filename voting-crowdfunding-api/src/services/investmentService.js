// src/services/investmentService.js
const { invest } = require('../data-access/investmentData');
const jwt = require('jsonwebtoken');

const JWT_SECRET = 'tu_secreto_jwt';

async function investService(investmentObj, token) {
  try {
    // Verificar el token JWT
    const decoded = jwt.verify(token, JWT_SECRET);
    if (!decoded.userID || decoded.userID !== investmentObj.userID) {
      throw new Error('Token inválido o userID no coincide');
    }

    // Llamar a la capa de datos
    const result = await invest(investmentObj);

    return result;
  } catch (err) {
    if (err.message.includes('THROW')) {
      throw { status: 400, message: err.message };
    }
    throw new Error(`Error en investService: ${err.message}`);
  }
}

module.exports = { investService };