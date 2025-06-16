// src/handlers/vote.js
const jwt = require('jsonwebtoken');
const { vote } = require('../services/voteService');

async function voteHandler(event) {
  try {
    console.log('Event Headers:', event.headers);
    const authHeader = event.headers?.authorization || event.headers?.Authorization;
    console.log('Auth Header Value:', authHeader);
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token requerido' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }
    const token = authHeader.split(' ')[1];
    console.log('Extracted Token:', token);
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET || 'tu_secreta'); // Verificación básica del token
      console.log('Decoded Token:', decoded);
    } catch (err) {
      console.log('Token Verification Error:', err.message);
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token inválido' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }

    // Validar proposalID desde la ruta
    const proposalIDFromPath = parseInt(event.pathParameters?.proposalID, 10);
    if (isNaN(proposalIDFromPath)) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'proposalID inválido' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }

    const body = JSON.parse(event.body || '{}');
    const { userID, votingID, proposalID, decision, biometricDataID } = body;

    if (!userID || !votingID || !proposalID || !decision || !biometricDataID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'userID, votingID, proposalID, decision y biometricDataID son requeridos' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }

    if (isNaN(parseInt(userID)) || isNaN(parseInt(votingID)) || isNaN(parseInt(proposalID)) || isNaN(parseInt(biometricDataID))) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'userID, votingID y proposalID deben ser números válidos' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }

    const result = await vote({ userID, votingID, proposalID, decision, biometricDataID });

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: 'Voto registrado exitosamente',
        voteID: result.voteID,
      }),
      headers: { 'Access-Control-Allow-Origin': '*' },
    };
  } catch (err) {
    console.error('ERROR EN VOTE:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error inesperado' }),
      headers: { 'Access-Control-Allow-Origin': '*' },
    };
  }
}

module.exports = { voteHandler };