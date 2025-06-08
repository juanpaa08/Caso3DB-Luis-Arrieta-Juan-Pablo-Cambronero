const jwt = require('jsonwebtoken');
const { invest } = require('../data-access/investmentData');

const JWT_SECRET = 'tu_secreto_jwt';

async function investService(investmentObj, token) {
  const decoded = jwt.verify(token, JWT_SECRET);
  if (!decoded.roles.includes('Investor') || decoded.userID !== investmentObj.userID) {
    throw new Error('Usuario no autorizado');
  }

  const result = await invest({
    proposalID: investmentObj.proposalID,
    userID: investmentObj.userID,
    amount: investmentObj.amount,
    paymentMethodID: investmentObj.paymentMethodID
  });

  return {
    success: result.success,
    returnValue: result.returnValue // Propagar el valor de retorno
  };
}

module.exports = { investService };