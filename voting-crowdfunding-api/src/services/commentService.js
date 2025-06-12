const {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario
} = require('../data-access/commentData');

async function comentarPropuesta({ userID, proposalID, content, hasSensitiveContent }) {
  const propuesta = await obtenerPropuestaPorID(proposalID);
  if (!propuesta) {
    const err = new Error('Propuesta no encontrada');
    err.status = 404;
    throw err;
  }

  const core = await obtenerCorePorProposalID(proposalID);
  if (!core || core.status !== '1') {
    const err = new Error('No se permiten comentarios en esta propuesta');
    err.status = 400;
    throw err;
  }

  const nuevoComentario = await insertarComentario({
    proposalID,
    content,
    status: hasSensitiveContent ? 'pending_review' : 'published'
  });

  return { proposalCommentID: nuevoComentario.proposalCommentID };
}

module.exports = { comentarPropuesta };