const { getConnection, sql, sequelize } = require('../db');
const ProposalType = require('./models/proposalType');
const Currency = require('./models/currency');

// Función reutilizable para ejecutar SPs
const executeSP = async (spName, inputs) => {
  const pool = await getConnection();
  const request = pool.request();

  Object.entries(inputs).forEach(([key, { type, value }]) => {
    request.input(key, type, value);
  });

  const query = `
    DECLARE @returnValue INT;
    EXEC @returnValue = ${spName}
      ${Object.keys(inputs).map(k => `@${k}`).join(', ')};
    SELECT @returnValue AS returnValue;
  `;

  const result = await request.query(query);
  return result.recordset[0].returnValue;
};

module.exports.createUpdateProposal = async (event) => {
  try {
    const returnValue = await executeSP('crearActualizarPropuesta', {
      proposalID: { type: sql.Int, value: null },
      userID: { type: sql.Int, value: 1 },
      title: { type: sql.NVarChar, value: event.body?.title || 'Test Proposal' },
      description: { type: sql.NVarChar, value: event.body?.description || 'Test Description' },
      targetPopulation: { type: sql.NVarChar, value: 'Jóvenes' },
      fileData: { type: sql.VarBinary, value: null },
      statusID: { type: sql.Int, value: 1 }
    });

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, returnValue })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

// Similar para reviewProposal e invest (misma estructura)
module.exports.reviewProposal = async (event) => {
  try {
    const returnValue = await executeSP('revisarPropuesta', {
      proposalID: { type: sql.Int, value: event.pathParameters.id },
      reviewerID: { type: sql.Int, value: 1 },
      validationResult: { type: sql.NVarChar, value: 'Approved' },
      aiPayload: { type: sql.NVarChar, value: null }
    });

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, returnValue })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

module.exports.invest = async (event) => {
  try {
    const returnValue = await executeSP('invertir', {
      proposalID: { type: sql.Int, value: event.pathParameters.id },
      userID: { type: sql.Int, value: 1 },
      amount: { type: sql.Decimal(18,2), value: 1000.00 },
      paymentMethodID: { type: sql.Int, value: 1 }
    });

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, returnValue })
    };
  } catch (err) {
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