const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { createUpdateProposal } = require('../data-access/proposalData');

const JWT_SECRET = 'tu_secreto_jwt'; // Configura en variables de entorno

async function createUpdateProposalService(proposalObj, token) {
  // Validar token y permisos
  const decoded = jwt.verify(token, JWT_SECRET);
  if (!decoded.roles.includes('ProposalCreator') || decoded.userID !== proposalObj.userID) {
    throw new Error('Usuario no autorizado');
  }

  // Generar hash de integridad (opcional, el Stored Procedure lo maneja si es NULL)
  const integrityHash = proposalObj.integrityHash || crypto.createHash('sha256').update(`${proposalObj.title}${Date.now()}`).digest();

  // Preparar datos para IA (simplificado)
  const aiPayload = {
    title: proposalObj.title
  };

  // Llamar a la capa de datos con solo los campos necesarios
  const result = await createUpdateProposal({
    proposalID: proposalObj.proposalID,
    title: proposalObj.title,
    userID: proposalObj.userID,
    proposalTypeID: proposalObj.proposalTypeID,
    integrityHash: integrityHash
  });

  return {
    proposalID: result.proposalID,
    status: result.status,
    integrityHash: integrityHash.toString('hex'),
    aiPayload
  };
}

module.exports = { createUpdateProposalService };