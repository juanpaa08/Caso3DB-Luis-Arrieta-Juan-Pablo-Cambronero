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

    const result = await request.execute('sp_Invertir');

    // Manejar los múltiples conjuntos de resultados
    const contribution = result.recordsets[0][0]; // Primer conjunto: detalles de la contribución
    const installments = result.recordsets[1]; // Segundo conjunto: cuotas
    const reviews = result.recordsets[2]; // Tercer conjunto: revisiones

    return {
      success: true,
      contribution: {
        contributionID: contribution.contributionID,
        projectID: contribution.projectID,
        userID: contribution.userID,
        investedAmount: contribution.investedAmount,
        totalRequested: contribution.totalRequested,
        alreadyInvested: contribution.alreadyInvested,
        equityPercent: contribution.equityPercent,
        cryptoKeyID: contribution.cryptoKeyID,
        cryptoKeyAction: contribution.cryptoKeyAction,
        statusID: contribution.statusID,
      },
      installments: installments.map(i => ({
        contributionID: i.contributionID,
        dueDate: i.dueDate,
        installmentAmount: i.installmentAmount,
      })),
      reviews: reviews.map(r => ({
        contributionID: r.contributionID,
        reviewDate: r.reviewDate,
        milestone: r.milestone,
      })),
    };
  } catch (err) {
    throw new Error(`Error al llamar a sp_Invertir: ${err.message}`);
  }
}

module.exports = { invest };