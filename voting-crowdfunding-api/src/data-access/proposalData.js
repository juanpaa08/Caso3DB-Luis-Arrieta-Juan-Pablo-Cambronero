const { getConnection, sql } = require('../../db');
const crypto = require('crypto');

async function createUpdateProposal(proposalData) {
  try {
    console.log('Parámetros enviados a sp_CreateUpdateProposal:', proposalData);

    // Validar que proposalTypeID esté presente
    if (!proposalData.proposalTypeID) {
      throw new Error('El proposalTypeID es obligatorio');
    }

    const pool = await getConnection();
    const integrityHash = proposalData.integrityHash || crypto.createHash('sha256').update(JSON.stringify(proposalData)).digest();

    const request = pool.request()
      .input('ProposalID', sql.Int, proposalData.proposalID)
      .input('Name', sql.NVarChar(150), proposalData.name || proposalData.title)
      .input('UserID', sql.Int, proposalData.userID)
      .input('ProposalTypeID', sql.Int, proposalData.proposalTypeID) // Ya no permitimos NULL
      .input('IntegrityHash', sql.VarBinary(512), integrityHash)
      .output('Status', sql.NVarChar(50));

    const result = await request.execute('sp_CreateUpdateProposal');
    return {
      proposalID: proposalData.proposalID || result.recordset[0]?.proposalID,
      status: result.output.Status,
      integrityHash: integrityHash.toString('hex')
    };
  } catch (err) {
    throw new Error(`Error al llamar a sp_CreateUpdateProposal: ${err.message}, Detalles: ${JSON.stringify(err)}`);
  }
}

module.exports = { createUpdateProposal };