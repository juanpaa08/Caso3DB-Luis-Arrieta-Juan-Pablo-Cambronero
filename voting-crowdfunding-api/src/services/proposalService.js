// src/services/proposalService.js
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { createUpdateProposal } = require('../data-access/proposalData');

const JWT_SECRET = 'tu_secreto_jwt';

async function createUpdateProposalService(proposalObj, token) {
  const decoded = jwt.verify(token, JWT_SECRET);
  if (!decoded.roles.includes('ProposalCreator') || decoded.userID !== proposalObj.userID) {
    throw new Error('Usuario no autorizado');
  }

  const integrityHash = proposalObj.integrityHash || crypto.createHash('sha256').update(`${proposalObj.title}${Date.now()}`).digest('hex');
  const aiPayload = { title: proposalObj.title };

  const result = await createUpdateProposal({
    proposalID: proposalObj.proposalID,
    title: proposalObj.title,
    userID: proposalObj.userID,
    proposalTypeID: proposalObj.proposalTypeID,
    integrityHash: integrityHash,
    targetGroups: proposalObj.targetGroups,
    documents: proposalObj.documents
  });

  return {
    proposalID: result.proposalID,
    status: result.status,
    integrityHash: result.integrityHash,
    aiPayload: aiPayload
  };
}

module.exports = { createUpdateProposalService };