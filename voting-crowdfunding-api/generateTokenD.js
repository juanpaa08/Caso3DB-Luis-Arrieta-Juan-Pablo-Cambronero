const jwt = require('jsonwebtoken');
const token = jwt.sign({ principalId: 1 }, 'tu_secreto', { expiresIn: '2h' });
console.log(token);