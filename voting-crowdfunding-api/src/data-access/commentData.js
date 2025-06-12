const pv_propposals = require('../models/pv_propposals.js');
const pv_proposalCore = require('../models/pv_proposalCore.js');
const pv_proposalComment = require('../models/pv_proposalComment.js');

async function obtenerPropuestaPorID(proposalID) {
  return await pv_propposals.findByPk(proposalID);
}

async function obtenerCorePorProposalID(proposalID) {
  return await pv_proposalCore.findOne({
    where: { proposalID }
  });
}

async function insertarComentario({ proposalID, content, status }) {
  return await pv_proposalComment.create({
    proposalID,
    content,
    status,
    likes: 0,
    reports: 0,
    proposalVersion: 1
  });
}

module.exports = {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario
};