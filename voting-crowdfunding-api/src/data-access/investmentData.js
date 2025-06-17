// src/data-access/investmentData.js
const { getConnection, sql } = require('../../db');

async function invest(investmentData) {
  try {
    const pool = await getConnection();
    const request = pool.request()
      .input('projectID', sql.Int, investmentData.projectID)
      .input('userID', sql.Int, investmentData.userID)
      .input('amount', sql.Decimal(18, 2), investmentData.amount)
      .input('paymentMethodID', sql.Int, investmentData.paymentMethodID);

    const result = await request.execute('invertir');

    // Manejar el único conjunto de resultados
    const contribution = result.recordset[0] || {};

    return {
      success: true,
      data: {
        contribution: {
          contributionID: contribution.contributionID,
          projectID: contribution.projectID,
          userID: contribution.userID,
          investedAmount: contribution.investedAmount,
          totalRequested: contribution.totalRequested,
          alreadyInvested: contribution.alreadyInvested,
          equityPercent: contribution.equityPercent,
          encryptedAmount: contribution.encryptedAmount,
          prevHash: contribution.prevHash,
        },
      },
    };
  } catch (err) {
    throw new Error(`Error al llamar a invertir: ${err.message}`);
  }
}

module.exports = { invest };