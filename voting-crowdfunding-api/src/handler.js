const { comentarPropuesta } = require('./services/commentService');
const { vote } = require('./services/voteService');


module.exports.comentar = async (event) => {
  try {
    const userID = event.requestContext?.authorizer?.principalId || 123;
    const proposalID = parseInt(event.pathParameters.id, 10);
    const { content, hasSensitiveContent } = JSON.parse(event.body);

    const result = await comentarPropuesta({
      userID,
      proposalID,
      content,
      hasSensitiveContent
    });

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: 'Comentario enviado para revisión',
        commentID: result.proposalCommentID
      })
    };
  } catch (err) {
    console.error('ERROR EN COMENTAR:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error inesperado' })
    };
  }
};

module.exports.votar = async (event) => {
  try {
    // Obtener userID y convertir a número, usar 123 como fallback
    const userID = parseInt(event.requestContext?.authorizer?.principalId) || 1;
    if (isNaN(userID)) {
      throw new Error('ID de usuario no válido').status = 400;
    }

    const { votingID, proposalID, decision } = JSON.parse(event.body);

    const result = await vote({ userID, votingID, proposalID, decision });

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: 'Voto registrado exitosamente',
        voteID: result.voteID
      }),
      headers: { 'Access-Control-Allow-Origin': '*' }
    };
  } catch (err) {
    console.error('ERROR EN VOTAR:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error inesperado' }),
      headers: { 'Access-Control-Allow-Origin': '*' }
    };
  }
};