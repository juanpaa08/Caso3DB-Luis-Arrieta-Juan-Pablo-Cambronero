// src/services/commentService.js
const {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario,
  registrarRechazo
} = require('../data-access/commentData');
const pv_users = require('../models/pv_users');

async function comentarPropuesta({ userID, proposalID, content, hasSensitiveContent }) {
  const usuario = await pv_users.findByPk(userID);
  if (!usuario || usuario.accountStatusID !== 1) {
    await registrarRechazo({
      proposalID,
      userID,
      content,
      rejectionReason: 'Usuario no autorizado o inactivo'
    });
    const err = new Error('Usuario no autorizado o inactivo');
    err.status = 403;
    throw err;
  }

  const propuesta = await obtenerPropuestaPorID(proposalID);
  if (!propuesta) {
    await registrarRechazo({
      proposalID,
      userID,
      content,
      rejectionReason: 'Propuesta no encontrada'
    });
    const err = new Error('Propuesta no encontrada');
    err.status = 404;
    throw err;
  }

  const core = await obtenerCorePorProposalID(proposalID);
  if (!core || core.status !== '1') {
    await registrarRechazo({
      proposalID,
      userID,
      content,
      rejectionReason: 'No se permiten comentarios en esta propuesta'
    });
    const err = new Error('No se permiten comentarios en esta propuesta');
    err.status = 400;
    throw err;
  }

  const status = hasSensitiveContent ? 'pending_review' : 'published';
  const nuevoComentario = await insertarComentario({
    proposalID,
    content,
    status: hasSensitiveContent ? 'pending_review' : 'published'
  });

  return { proposalCommentID: nuevoComentario.proposalCommentID };
}

module.exports = { comentarPropuesta };