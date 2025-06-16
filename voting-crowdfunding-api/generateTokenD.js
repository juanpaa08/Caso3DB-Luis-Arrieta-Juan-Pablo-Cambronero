const jwt = require('jsonwebtoken');
const fs = require('fs');

const payload = { id: 1 }; // Ajusta el ID según necesites
const secret = 'tu_secreto'; // Idealmente usa process.env.SECRET
const token = jwt.sign(payload, secret, { expiresIn: '2h' });

console.log('Token generado:', token);
fs.writeFileSync('token.txt', token, 'utf8'); // Guarda el token en un archivo