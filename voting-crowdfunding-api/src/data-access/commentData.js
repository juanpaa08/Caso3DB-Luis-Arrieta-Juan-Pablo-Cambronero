// src/data-access/commentData.js
const pv_propposals = require('../models/pv_propposals.js');
const pv_proposalCore = require('../models/pv_proposalCore.js');
const pv_proposalComment = require('../models/pv_proposalComment.js');
const pv_commentRejectionLogs = require('../models/pv_commentRejectionLogs.js');
const { encrypt } = require('../utils/encryption');

async function obtenerPropuestaPorID(proposalID) {
  return await pv_propposals.findByPk(proposalID);
}

async function obtenerCorePorProposalID(proposalID) {
  return await pv_proposalCore.findOne({
    where: { proposalID }
  });
}

async function insertarComentario({ proposalID, content, status }) {
  const encryptedContent = status === 'pending_review' ? encrypt(content) : content; // Cifrar si está pendiente de revisión
  return await pv_proposalComment.create({
    proposalID,
    content: encryptedContent,
    status,
    likes: 0,
    reports: 0,
    proposalVersion: 1
  });
}

async function registrarRechazo({ proposalID, userID, content, rejectionReason }) {
  const encryptedContent = rejectionReason.includes('Usuario') || rejectionReason.includes('Propuesta') ? content : encrypt(content); // Cifrar si es sensible
  return await pv_commentRejectionLogs.create({
    proposalID,
    userID,
    content: encryptedContent,
    rejectionReason
  });
}

module.exports = {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario,
  registrarRechazo
};