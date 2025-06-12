const ProposalType        = require('./models/proposalType');
const Currency            = require('./models/currency');
const { comentarPropuesta } = require('./services/commentService');

module.exports.vote = async (event) => {
  try {
    const proposalTypes = await ProposalType.findAll();
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        data: proposalTypes.map(pt => pt.toJSON())
      })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

module.exports.comment = async (event) => {
  try {
    const currencies = await Currency.findAll();
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        data: currencies.map(c => c.toJSON())
      })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ success: false, error: err.message })
    };
  }
};

module.exports.comentar = async (event) => {
  try {
    const userID     = event.requestContext?.authorizer?.principalId || 123;
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
