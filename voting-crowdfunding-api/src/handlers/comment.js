// src/handlers/comment.js
const jwt = require('jsonwebtoken');
const { comentarPropuesta } = require('../services/commentService');

async function comentarPropuestaHandler(event) {
  try {
    const authHeader = event.headers?.authorization || event.headers?.Authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token requerido' }),
      };
    }
    const token = authHeader.split(' ')[1];
    let userID; // Definir userID fuera del try-catch interno
    try {
      const decoded = jwt.verify(token, 'tu_secreto');
      userID = decoded.id; // Asignar el valor aquí
    } catch (err) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: 'Token inválido' }),
      };
    }

    const proposalID = parseInt(event.pathParameters?.id, 10);
    if (isNaN(proposalID)) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'proposalID inválido' }),
      };
    }

    const body = JSON.parse(event.body || '{}');
    const { content, hasSensitiveContent } = body;
    if (!content || typeof hasSensitiveContent !== 'boolean') {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'content y hasSensitiveContent son requeridos' }),
      };
    }

    const result = await comentarPropuesta({
      userID,
      proposalID,
      content,
      hasSensitiveContent,
    });

    return {
      statusCode: 201,
      body: JSON.stringify({
        message: 'Comentario enviado para revisión',
        commentID: result.proposalCommentID,
      }),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  } catch (err) {
    console.error('Error en comentarPropuestaHandler:', err);
    return {
      statusCode: err.status || 500,
      body: JSON.stringify({ error: err.message || 'Error del servidor' }),
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    };
  }
}

module.exports = { comentarPropuestaHandler };