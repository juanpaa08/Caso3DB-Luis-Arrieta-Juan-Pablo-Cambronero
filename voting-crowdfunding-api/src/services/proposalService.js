// src/services/proposalService.js
const { createUpdateProposal } = require('../data-access/proposalData');

async function createUpdateProposalService({ proposalID, title, userID, proposalTypeID, targetGroups, documents, token }) {
  const result = await createUpdateProposal({
    proposalID,
    title,
    userID,
    proposalTypeID,
    targetGroups: targetGroups || [],
    documents: documents || [], // Asegúrate de que documents sea un array de objetos
  });

  return result; // Devolver el resultado tal cual, sin sobrescribir
}

module.exports = { createUpdateProposalService };