module.exports.comentar = async (event) => {
  try {
    const userID = event.requestContext?.authorizer?.principalId;
    if (!userID || isNaN(parseInt(userID))) {
      return { statusCode: 400, body: JSON.stringify({ error: 'userID inválido o requerido' }) };
    }

    const proposalID = parseInt(event.pathParameters.id, 10);
    if (isNaN(proposalID)) {
      return { statusCode: 400, body: JSON.stringify({ error: 'proposalID inválido' }) };
    }

    const { content, hasSensitiveContent } = JSON.parse(event.body || '{}');
    if (!content || typeof hasSensitiveContent !== 'boolean') {
      return { statusCode: 400, body: JSON.stringify({ error: 'content y hasSensitiveContent son requeridos' }) };
    }

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
    const userID = event.requestContext?.authorizer?.principalId;
    if (!userID || isNaN(parseInt(userID))) {
      return { statusCode: 400, body: JSON.stringify({ error: 'userID inválido o requerido' }) };
    }

    const { votingID, proposalID, decision } = JSON.parse(event.body || '{}');
    if (!votingID || !proposalID || !decision) {
      return { statusCode: 400, body: JSON.stringify({ error: 'votingID, proposalID y decision son requeridos' }) };
    }

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