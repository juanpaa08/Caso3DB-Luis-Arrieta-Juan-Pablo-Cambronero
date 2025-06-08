const jwt = require('jsonwebtoken');

const JWT_SECRET = 'tu_secreto_jwt';
const payload = { userID: 4, roles: ['ProposalReviewer'] };
const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });
console.log(token);