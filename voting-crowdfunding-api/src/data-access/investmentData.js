// src/data-access/investmentData.js
const { getConnection, sql } = require('../../db');

async function invest(investmentData) {
  try {
    const pool = await getConnection();
    const request = pool.request()
      .input('proposalID', sql.Int, investmentData.proposalID)
      .input('userID', sql.Int, investmentData.userID)
      .input('amount', sql.Decimal(18, 2), investmentData.amount)
      .input('paymentMethodID', sql.Int, investmentData.paymentMethodID);

    const result = await request.execute('invertir');
    return {
      success: result.returnValue === 0,
      returnValue: result.returnValue
    };
  } catch (err) {
    throw new Error(`Error al llamar a invertir: ${err.message}`);
  }
}

module.exports = { invest };