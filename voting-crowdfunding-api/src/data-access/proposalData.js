// src/data-access/proposalData.js
const { getConnection, sql } = require('../../db');
const crypto = require('crypto');

async function createUpdateProposal(proposalData) {
  try {
    if (!proposalData.proposalTypeID) {
      throw new Error('El proposalTypeID es obligatorio');
    }

    const pool = await getConnection();
    const integrityHash = proposalData.integrityHash || crypto.createHash('sha256').update(`${proposalData.title}${Date.now()}`).digest();

    const request = pool.request()
      .input('ProposalID', sql.Int, proposalData.proposalID)
      .input('Name', sql.NVarChar(150), proposalData.title)
      .input('UserID', sql.Int, proposalData.userID)
      .input('ProposalTypeID', sql.Int, proposalData.proposalTypeID)
      .input('IntegrityHash', sql.VarBinary(512), Buffer.from(integrityHash, 'hex'))
      .output('Status', sql.NVarChar(50));

    const result = await request.execute('sp_CreateUpdateProposal');
    return {
      proposalID: proposalData.proposalID || result.recordset[0]?.proposalID,
      status: result.output.Status,
      integrityHash: integrityHash
    };
  } catch (err) {
    throw new Error(`Error al llamar a sp_CreateUpdateProposal: ${err.message}`);
  }
}

module.exports = { createUpdateProposal };