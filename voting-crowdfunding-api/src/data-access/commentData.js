const pv_proposals       = require('../models/pv_proposals.js');
const pv_proposalCore    = require('../models/pv_proposalCore.js');
const pv_proposalComment = require('../models/pv_proposalComment.js');

async function obtenerPropuestaPorID(proposalID) {
  return await pv_proposals.findByPk(proposalID);
}

async function obtenerCorePorProposalID(proposalID) {
  return await pv_proposalCore.findOne({
    where: { proposalID }
  });
}

async function insertarComentario({ proposalID, content, status, versionID }) {
  return await pv_proposalComment.create({
    proposalID,
    content,
    publishDate: new Date(),
    status,
    likes: 0,
    reports: 0,
    proposalVersionID: versionID
  });
}

module.exports = {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario
};
