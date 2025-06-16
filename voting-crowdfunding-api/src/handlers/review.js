// src/handlers/review.js
const jwt = require('jsonwebtoken');
const { reviewProposalService } = require('../services/reviewService');

async function reviewProposal(event) {
  try {
    console.log('Event Headers:', event.headers);
    const authHeader = event.headers?.authorization || event.headers?.Authorization;
    console.log('Auth Header Value:', authHeader);
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token requerido' }),
      };
    }
    const token = authHeader.split(' ')[1];
    console.log('Extracted Token:', token);
    let userID, roles;
    try {
      const decoded = jwt.verify(token, 'tu_secreto_jwt'); // Usa la clave secreta correcta
      console.log('Decoded Token:', decoded);
      userID = decoded.userID;
      roles = decoded.roles || [];
    } catch (err) {
      console.log('Token Verification Error:', err.message);
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token inválido' }),
      };
    }

    if (!roles.includes('ProposalReviewer')) {
      return {
        statusCode: 403,
        body: JSON.stringify({ error: 'Rol ProposalReviewer requerido' }),
      };
    }

    // Validar proposalID desde la ruta
    const proposalID = parseInt(event.pathParameters?.proposalID, 10);
    if (isNaN(proposalID)) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'proposalID inválido' }),
      };
    }

    const body = JSON.parse(event.body || '{}');
    const { reviewerID, validationResult, aiPayload } = body;

    if (!reviewerID || !validationResult) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'reviewerID y validationResult son requeridos' }),
      };
    }

    const result = await reviewProposalService({
      proposalID,
      reviewerID,
      validationResult,
      aiPayload,
      token, // Pasa el token al servicio
    });

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Propuesta revisada exitosamente',
        success: result.success,
      }),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  } catch (err) {
    console.error('Error en reviewProposal:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error del servidor' }),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  }
}

module.exports = { reviewProposal };