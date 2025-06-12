// src/services/reviewService.js
const jwt = require('jsonwebtoken');
const { reviewProposal } = require('../data-access/reviewData');

const JWT_SECRET = 'tu_secreto_jwt';

async function reviewProposalService(reviewObj, token) {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    if (!decoded.roles.includes('ProposalReviewer') || decoded.userID !== reviewObj.reviewerID) {
      throw new Error('Usuario no autorizado');
    }

    const result = await reviewProposal({
      proposalID: reviewObj.proposalID,
      reviewerID: reviewObj.reviewerID,
      validationResult: reviewObj.validationResult,
      aiPayload: reviewObj.aiPayload
    });

    return {
      success: result.success,
      returnValue: result.returnValue,
      status: result.status
    };
  } catch (err) {
    throw new Error(`Error en servicio de revisión: ${err.message}`);
  }
}

module.exports = { reviewProposalService };