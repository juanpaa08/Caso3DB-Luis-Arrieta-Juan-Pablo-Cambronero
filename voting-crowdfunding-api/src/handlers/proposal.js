// src/handlers/proposal.js
const jwt = require('jsonwebtoken');
const { createUpdateProposalService } = require('../services/proposalService');

async function createUpdateProposal(event) {
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
      const decoded = jwt.verify(token, 'tu_secreto_jwt');
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

    if (!roles.includes('ProposalCreator')) {
      return {
        statusCode: 403,
        body: JSON.stringify({ error: 'Rol ProposalCreator requerido' }),
      };
    }

    const body = JSON.parse(event.body || '{}');
    const { proposalID, title, userID: bodyUserID, proposalTypeID, targetGroups, documents } = body;

    if (!title || !bodyUserID || !proposalTypeID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'title, userID y proposalTypeID son requeridos' }),
      };
    }

    const result = await createUpdateProposalService({
      proposalID: proposalID || null, // Usar el proposalID del cuerpo JSON
      title,
      userID: bodyUserID,
      proposalTypeID,
      targetGroups: targetGroups || [],
      documents: documents || [],
      token,
    });

    if (result.status && result.status.startsWith('Error:')) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: result.status }),
      };
    }

    return {
      statusCode: 201,
      body: JSON.stringify(result),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  } catch (err) {
    console.error('Error en createUpdateProposal:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error del servidor' }),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  }
}

module.exports = { createUpdateProposal };