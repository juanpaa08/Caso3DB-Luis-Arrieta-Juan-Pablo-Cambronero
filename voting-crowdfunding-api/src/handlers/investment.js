// src/handlers/investment.js
const { investService } = require('../services/investmentService');

module.exports.invest = async (event) => {
  try {
    console.log('Event Headers:', event.headers);
    const authHeader = event.headers?.authorization || event.headers?.Authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return {
        statusCode: 401,
        body: JSON.stringify({ success: false, error: 'Token requerido' }),
        headers: { 'Access-Control-Allow-Origin': '*' },
      };
    }
    const token = authHeader.split(' ')[1];
    console.log('Extracted Token:', token);

    const body = JSON.parse(event.body || '{}');
    const investmentObj = {
      projectID: body.projectID,
      userID: body.userID,
      amount: body.amount,
      paymentMethodID: body.paymentMethodID,
    };

    // Validar todos los campos requeridos
    if (!investmentObj.projectID || isNaN(parseInt(investmentObj.projectID))) {
      return { statusCode: 400, body: JSON.stringify({ success: false, error: 'projectID inválido o requerido' }) };
    }
    if (!investmentObj.userID || isNaN(parseInt(investmentObj.userID))) {
      return { statusCode: 400, body: JSON.stringify({ success: false, error: 'userID inválido o requerido' }) };
    }
    if (!investmentObj.amount || isNaN(parseFloat(investmentObj.amount)) || parseFloat(investmentObj.amount) <= 0) {
      return { statusCode: 400, body: JSON.stringify({ success: false, error: 'amount inválido o requerido' }) };
    }
    if (!investmentObj.paymentMethodID || isNaN(parseInt(investmentObj.paymentMethodID))) {
      return { statusCode: 400, body: JSON.stringify({ success: false, error: 'paymentMethodID inválido o requerido' }) };
    }

    const result = await investService(investmentObj, token);

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: result.success,
        data: result.data || {},
        message: 'Inversión procesada exitosamente',
      }),
      headers: { 'Access-Control-Allow-Origin': '*' },
    };
  } catch (err) {
    console.error('Error en invest:', err);
    let statusCode = 500;
    let errorMessage = err.message || 'Error del servidor';
    if (err.message.includes('THROW')) {
      statusCode = 400; // Asumir que los errores del SP son de validación
    }
    return {
      statusCode,
      body: JSON.stringify({ success: false, error: errorMessage }),
      headers: { 'Access-Control-Allow-Origin': '*' },
    };
  }
};