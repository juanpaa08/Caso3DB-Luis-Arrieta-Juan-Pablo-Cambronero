const { comentarPropuesta } = require('../services/commentService');

async function comentarPropuestaHandler(req, res) {
  try {
    const userID = req.user?.id;
    const proposalID = parseInt(req.params.id, 10);
    const { content, hasSensitiveContent } = req.body;

    const result = await comentarPropuesta({
      userID,
      proposalID,
      content,
      hasSensitiveContent
    });

    res.status(201).json({
      message: 'Comentario enviado para revisión',
      commentID: result.proposalCommentID
    });
  } catch (err) {
    res.status(err.status || 500).json({ error: err.message || 'Error del servidor' });
  }
}

module.exports = { comentarPropuestaHandler };
