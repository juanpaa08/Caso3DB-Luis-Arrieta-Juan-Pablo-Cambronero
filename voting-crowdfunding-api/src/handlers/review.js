// src/handlers/review.js
const { reviewProposalService } = require('../services/reviewService');

module.exports.reviewProposal = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const token = event.headers.Authorization?.replace('Bearer ', '');
    const proposalID = event.pathParameters?.proposalID;

    const reviewObj = {
      proposalID: parseInt(proposalID),
      reviewerID: body.reviewerID || 1,
      validationResult: body.validationResult || 'Approved',
      aiPayload: body.aiPayload || null
    };

    if (!reviewObj.proposalID || !reviewObj.reviewerID || !reviewObj.validationResult) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Faltan campos requeridos' })
      };
    }

    const result = await reviewProposalService(reviewObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: result.success,
        returnValue: result.returnValue,
        status: result.status,
        message: result.status === 'Aprobada' ? 'Propuesta revisada y aprobada exitosamente' : 'Propuesta revisada'
      })
    };
  } catch (err) {
    console.error('Error en reviewProposal:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};