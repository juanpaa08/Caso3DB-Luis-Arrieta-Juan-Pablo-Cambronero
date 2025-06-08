const { investService } = require('../services/investmentService');

module.exports.invest = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const token = event.headers.Authorization?.replace('Bearer ', '');

    const investmentObj = {
      proposalID: body.proposalID,
      userID: body.userID,
      amount: body.amount,
      paymentMethodID: body.paymentMethodID
    };

    if (!investmentObj.proposalID || !investmentObj.userID || !investmentObj.amount || !investmentObj.paymentMethodID) {
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
        returnValue: result.returnValue, // Usar el valor real del SP
        message: 'Inversión procesada exitosamente'
      })
    };
  } catch (err) {
    console.error('Error en invertir:', err);
    return {
      statusCode: 400,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};