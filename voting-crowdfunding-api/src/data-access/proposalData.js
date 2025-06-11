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
      .input('IntegrityHash', sql.VarBinary(512), Buffer.from(integrityHash))
      .input('TargetGroups', sql.NVarChar(sql.MAX), JSON.stringify(proposalData.targetGroups || []))
      .input('Documents', sql.NVarChar(sql.MAX), JSON.stringify(proposalData.documents || []))
      .output('Status', sql.NVarChar(50));

    const result = await request.execute('sp_CreateUpdateProposal');
    const record = result.recordset[0]; // Accede al primer registro del recordset
    if (!record) {
      throw new Error('No se recibió respuesta del procedimiento almacenado');
    }

    return {
      proposalID: record.proposalID,
      status: record.status,
      integrityHash: integrityHash.toString('hex')
    };
  } catch (err) {
    throw new Error(`Error al llamar a sp_CreateUpdateProposal: ${err.message}`);
  }
}

module.exports = { createUpdateProposal };