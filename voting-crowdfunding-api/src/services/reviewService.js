// src/services/reviewService.js
const jwt = require('jsonwebtoken');
const { reviewProposal } = require('../data-access/reviewData');

const JWT_SECRET = 'tu_secreto_jwt';

async function reviewProposalService({ proposalID, reviewerID, validationResult, aiPayload, token }) {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    if (!decoded.roles.includes('ProposalReviewer') || decoded.userID !== reviewerID) {
      throw new Error('Usuario no autorizado');
    }

    const result = await reviewProposal({
      proposalID,
      reviewerID,
      validationResult,
      aiPayload,
    });

    return {
      success: result.success,
    };
  } catch (err) {
    if (err.message.includes('Configuración del workflow incompleta')) {
      throw { status: 400, message: err.message };
    }
    throw new Error(`Error en servicio de revisión: ${err.message}`);
  }
}

module.exports = { reviewProposalService };