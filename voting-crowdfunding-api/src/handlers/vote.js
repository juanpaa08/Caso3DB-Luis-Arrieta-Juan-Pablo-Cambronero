const { vote } = require('../services/voteService');

module.exports.voteHandler = async (event) => {
  try {
    const userID = event.requestContext?.authorizer?.principalId || 1;
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
    console.error('ERROR EN VOTE:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error inesperado' }),
      headers: { 'Access-Control-Allow-Origin': '*' }
    };
  }
};