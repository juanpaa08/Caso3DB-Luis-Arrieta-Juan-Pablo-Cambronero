const {
  obtenerPropuestaPorID,
  obtenerCorePorProposalID,
  insertarComentario
} = require('../data-access/commentData');

async function comentarPropuesta({ userID, proposalID, content, hasSensitiveContent }) {
  // 1) Verificar existencia de la propuesta
  const propuesta = await obtenerPropuestaPorID(proposalID);
  if (!propuesta) {
    const err = new Error('Propuesta no encontrada');
    err.status = 404;
    throw err;
  }

  // 2) Verificar que permita comentarios (status === '1')
  const core = await obtenerCorePorProposalID(proposalID);
  if (!core || core.status !== '1') {
    const err = new Error('No se permiten comentarios en esta propuesta');
    err.status = 400;
    throw err;
  }

  // 3) Insertar comentario
  const nuevoComentario = await insertarComentario({
    proposalID,
    content,
    status: hasSensitiveContent ? 'pending_review' : 'published',
    versionID: core.versionID
  });

  return { proposalCommentID: nuevoComentario.id };
}

module.exports = { comentarPropuesta };
