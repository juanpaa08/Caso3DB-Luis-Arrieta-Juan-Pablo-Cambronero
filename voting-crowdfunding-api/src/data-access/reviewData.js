const { getConnection, sql } = require('../../db');

async function reviewProposal(reviewData) {
  try {
    const pool = await getConnection();
    const request = pool.request()
      .input('proposalID', sql.Int, reviewData.proposalID)
      .input('reviewerID', sql.Int, reviewData.reviewerID)
      .input('validationResult', sql.NVarChar(255), reviewData.validationResult)
      .input('aiPayload', sql.NVarChar(sql.MAX), reviewData.aiPayload);

    const result = await request.execute('revisarPropuesta');
    return {
      success: result.returnValue === 0,
      returnValue: result.returnValue // Devolver el valor real del SP
    };
  } catch (err) {
    throw new Error(`Error al llamar a revisarPropuesta: ${err.message}`);
  }
}

module.exports = { reviewProposal };