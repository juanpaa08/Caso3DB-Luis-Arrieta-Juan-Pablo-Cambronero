const { createUpdateProposalService } = require('../services/proposalService');

module.exports.createUpdateProposal = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const token = event.headers.Authorization?.replace('Bearer ', '');

    const proposalObj = {
      proposalID: body.proposalID || null,
      title: body.title,
      userID: body.userID,
      proposalTypeID: body.proposalTypeID
    };

    if (!proposalObj.title || !proposalObj.userID || !proposalObj.proposalTypeID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Faltan campos requeridos' })
      };
    }

    const result = await createUpdateProposalService(proposalObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        proposalID: result.proposalID,
        status: result.status,
        integrityHash: result.integrityHash,
        aiPayload: result.aiPayload
      })
    };
  } catch (err) {
    console.error('Error en createUpdateProposal:', err);
    return {
      statusCode: 400,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};