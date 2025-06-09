// src/handler.js
const proposalService = require('./services/proposalService');
const reviewService = require('./services/reviewService');
const investmentService = require('./services/investmentService');
const ProposalType = require('./models/proposalType');
const Currency = require('./models/currency');

module.exports.createUpdateProposal = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const token = event.headers.Authorization?.replace('Bearer ', '');

    const proposalObj = {
      proposalID: body.proposalID || null,
      title: body.title || 'Test Proposal',
      userID: body.userID || 1,
      proposalTypeID: body.proposalTypeID || 1
    };

    if (!proposalObj.title || !proposalObj.userID || !proposalObj.proposalTypeID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Faltan campos requeridos' })
      };
    }

    const result = await proposalService.createUpdateProposalService(proposalObj, token);

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
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

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

    const result = await reviewService.reviewProposalService(reviewObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: result.success,
        returnValue: result.returnValue,
        message: 'Propuesta revisada exitosamente'
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

module.exports.invest = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const token = event.headers.Authorization?.replace('Bearer ', '');

    const investmentObj = {
      proposalID: body.proposalID,
      userID: body.userID || 1,
      amount: body.amount || 1000.00,
      paymentMethodID: body.paymentMethodID || 1
    };

    if (!investmentObj.proposalID || !investmentObj.userID || !investmentObj.amount || !investmentObj.paymentMethodID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Faltan campos requeridos' })
      };
    }

    const result = await investmentService.investService(investmentObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: result.success,
        returnValue: result.returnValue,
        message: 'Inversión procesada exitosamente'
      })
    };
  } catch (err) {
    console.error('Error en invest:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

module.exports.vote = async (event) => {
  try {
    const proposalTypes = await ProposalType.findAll();
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        data: proposalTypes.map(pt => pt.toJSON())
      })
    };
  } catch (err) {
    console.error('Error en vote:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        error: err.message
      })
    };
  }
};

module.exports.comment = async (event) => {
  try {
    const currencies = await Currency.findAll();
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        data: currencies.map(c => c.toJSON())
      })
    };
  } catch (err) {
    console.error('Error en comment:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        error: err.message
      })
    };
  }
};