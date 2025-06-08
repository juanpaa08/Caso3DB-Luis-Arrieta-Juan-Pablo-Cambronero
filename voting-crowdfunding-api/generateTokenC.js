const jwt = require('jsonwebtoken');

const JWT_SECRET = 'tu_secreto_jwt';
const payload = { userID: 1, roles: ['Investor'] };
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
console.log(token);