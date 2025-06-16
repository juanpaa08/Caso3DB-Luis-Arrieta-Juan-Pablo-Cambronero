// generateVoteToken.js
const jwt = require('jsonwebtoken');
const fs = require('fs');

const JWT_SECRET = process.env.JWT_SECRET || 'tu_secreta';
const payload = { userID: 1 }; // Cambiar a userID
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '2h' });

console.log('Token generado:', token);
fs.writeFileSync('voteToken.txt', token, 'utf8');