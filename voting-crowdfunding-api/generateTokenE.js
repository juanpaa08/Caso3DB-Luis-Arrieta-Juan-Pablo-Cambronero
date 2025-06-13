const jwt = require('jsonwebtoken');
const token = jwt.sign({ principalId: 1 }, process.env.JWT_SECRET || 'tu_secreta', { expiresIn: '2h' });
console.log(token);