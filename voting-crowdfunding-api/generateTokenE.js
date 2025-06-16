// generateVoteToken.js
const jwt = require('jsonwebtoken');
const fs = require('fs');

const JWT_SECRET = process.env.JWT_SECRET || 'tu_secreta'; // Usa la misma clave que el handler
const payload = { principalId: 5 }; // Compatible con el payload original
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '2h' });

console.log('Token generado:', token);
fs.writeFileSync('voteToken.txt', token, 'utf8'); // Guarda el token en un archivo