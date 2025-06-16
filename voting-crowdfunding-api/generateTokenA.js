// generateProposalToken.js
const jwt = require('jsonwebtoken');
const fs = require('fs');

const JWT_SECRET = 'tu_secreto_jwt'; // Debe coincidir con proposalService.js y el handler
const payload = {
  userID: 2, // Coincide con el userID del body
  roles: ['ProposalCreator'], // Añade el rol requerido
};
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '2h' });

console.log('Token generado:', token);
fs.writeFileSync('proposalToken.txt', token, 'utf8'); // Guarda el token en un archivo