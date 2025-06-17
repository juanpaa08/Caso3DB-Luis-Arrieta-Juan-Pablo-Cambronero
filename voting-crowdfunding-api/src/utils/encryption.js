// src/utils/encryption.js
const crypto = require('crypto');
const { ENCRYPTION_KEY } = process.env;

if (!ENCRYPTION_KEY) {
  throw new Error('La clave de cifrado (ENCRYPTION_KEY) no está configurada en las variables de entorno.');
}

const IV_LENGTH = 16; // Longitud del vector de inicialización para AES

function encrypt(text) {
  const iv = crypto.randomBytes(IV_LENGTH);
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return iv.toString('hex') + ':' + encrypted; // Concatenamos IV y texto cifrado
}

function decrypt(encryptedText) {
  const [ivHex, encrypted] = encryptedText.split(':');
  if (!ivHex || !encrypted) {
    throw new Error('Datos cifrados inválidos');
  }
  const iv = Buffer.from(ivHex, 'hex');
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(ENCRYPTION_KEY, 'hex'), iv);
  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

module.exports = { encrypt, decrypt };