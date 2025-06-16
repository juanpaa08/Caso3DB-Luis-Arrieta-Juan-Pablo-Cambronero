// src/data-access/proposalData.js
const { getConnection, sql } = require('../../db');

async function createUpdateProposal(proposalData) {
  try {
    if (!proposalData.proposalTypeID) {
      throw new Error('El proposalTypeID es obligatorio');
    }

    const pool = await getConnection();

    // 1️⃣ Configuración del TVP para TargetGroups
    const targetGroupsTVP = new sql.Table();
    targetGroupsTVP.columns.add('groupID', sql.Int);
    (proposalData.targetGroups || []).forEach(groupID => {
      targetGroupsTVP.rows.add(parseInt(groupID) || 0);
    });
    console.log('TargetGroups TVP Data:', targetGroupsTVP.rows);

    // 2️⃣ Configuración del TVP para Documents
    const documentsTVP = new sql.Table();
    documentsTVP.columns.add('fileName', sql.NVarChar(50));
    documentsTVP.columns.add('size', sql.NVarChar(10));
    documentsTVP.columns.add('format', sql.NVarChar(10));
    documentsTVP.columns.add('uploadDate', sql.NVarChar(20));
    documentsTVP.columns.add('validationStatusID', sql.NVarChar(10));
    documentsTVP.columns.add('userID', sql.NVarChar(10));
    documentsTVP.columns.add('institutionID', sql.NVarChar(10));
    documentsTVP.columns.add('mediaTypeID', sql.NVarChar(10));
    documentsTVP.columns.add('documentTypeID', sql.NVarChar(10));

    (proposalData.documents || []).forEach(doc => {
      documentsTVP.rows.add(
        doc.fileName || null,
        doc.size || null,
        doc.format || null,
        doc.uploadDate || null,
        doc.validationStatusID || null,
        doc.userID || null,
        doc.institutionID || null,
        doc.mediaTypeID || null,
        doc.documentTypeID || null
      );
    });
    console.log('Documents TVP Data:', documentsTVP.rows);

    // 3️⃣ Configurar el request con los parámetros correctos
    const request = pool.request()
      .input('ProposalID', sql.Int, proposalData.proposalID || null)
      .input('Name', sql.NVarChar(150), proposalData.title)
      .input('UserID', sql.Int, proposalData.userID)
      .input('ProposalTypeID', sql.Int, proposalData.proposalTypeID)
      .input('IntegrityHash', sql.VarBinary(512), null)
      .input('TargetGroups', targetGroupsTVP)
      .input('Documents', documentsTVP)
      .output('Status', sql.NVarChar(50));

    const result = await request.execute('sp_CreateUpdateProposal');
    
    // Depuración
    console.log('Recordset:', result.recordset);
    console.log('Output Status:', request.parameters.Status.value);
    
    // Obtenemos los valores del recordset o del parámetro de salida
    const record = result.recordset[0] || {};
    const proposalID = record.proposalID !== undefined ? record.proposalID : (proposalData.proposalID || null);
    const status = record.status || request.parameters.Status.value;

    return {
      proposalID: proposalID,
      status: status,
      integrityHash: null
    };
  } catch (err) {
    console.error('Error details:', err);
    throw new Error(`Error al llamar a sp_CreateUpdateProposal: ${err.message}`);
  }
}

module.exports = { createUpdateProposal };