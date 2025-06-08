const { reviewProposalService } = require('../services/reviewService');

module.exports.reviewProposal = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const token = event.headers.Authorization?.replace('Bearer ', '');
    const proposalID = event.pathParameters.proposalID;

    const reviewObj = {
      proposalID: parseInt(proposalID),
      reviewerID: body.reviewerID,
      validationResult: body.validationResult,
      aiPayload: body.aiPayload
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
        returnValue: result.returnValue, // Usar el valor real del SP
        message: 'Propuesta revisada exitosamente'
      })
    };
  } catch (err) {
    console.error('Error en reviewProposal:', err);
    return {
      statusCode: 400,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};