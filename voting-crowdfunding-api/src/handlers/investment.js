// src/handlers/investment.js
const { investService } = require('../services/investmentService');

module.exports.invest = async (event) => {
  try {
    const body = JSON.parse(event.body || '{}');
    const token = event.headers.Authorization?.replace('Bearer ', '');

    const investmentObj = {
      projectID: body.projectID,
      userID: body.userID || 1,
      amount: body.amount || 1000.00,
      paymentMethodID: body.paymentMethodID || 1
    };

    if (!investmentObj.projectID || !investmentObj.userID || !investmentObj.amount || !investmentObj.paymentMethodID) {
      return {
        statusCode: 400,
        body: JSON.stringify({ success: false, error: 'Faltan campos requeridos' })
      };
    }

    const result = await investService(investmentObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: result.success,
        data: {
          contribution: result.contribution,
          installments: result.installments,
          reviews: result.reviews
        },
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