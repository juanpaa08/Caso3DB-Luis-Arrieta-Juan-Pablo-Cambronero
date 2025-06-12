// src/handler.js
const ProposalType = require('./models/proposalType');
const Currency = require('./models/currency');


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