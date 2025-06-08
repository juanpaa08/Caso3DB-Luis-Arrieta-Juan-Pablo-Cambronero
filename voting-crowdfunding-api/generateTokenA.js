const jwt = require('jsonwebtoken');

const JWT_SECRET = 'tu_secreto_jwt'; // Debe coincidir con proposalService.js
const payload = {
  userID: 1, // Coincide con el userID del body
  roles: ['ProposalCreator'] // Añade el rol requerido
};
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
console.log(token);