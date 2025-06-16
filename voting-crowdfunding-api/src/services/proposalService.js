// src/services/proposalService.js
const crypto = require('crypto');
const { createUpdateProposal } = require('../data-access/proposalData');

async function createUpdateProposalService({ proposalID, title, userID, proposalTypeID, targetGroups, documents, token }) {
  // No verificar el token aquí, asumimos que el handler lo hizo
  const integrityHash = crypto.createHash('sha256').update(`${title}${Date.now()}`).digest('hex');
  const aiPayload = { title };

  const result = await createUpdateProposal({
    proposalID,
    title,
    userID,
    proposalTypeID,
    integrityHash,
    targetGroups,
    documents,
  });

  return {
    proposalID: result.proposalID,
    status: result.status,
    integrityHash: result.integrityHash,
    aiPayload,
  };
}

module.exports = { createUpdateProposalService };