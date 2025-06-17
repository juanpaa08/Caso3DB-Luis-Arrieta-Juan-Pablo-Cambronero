// src/services/voteService.js
const CryptoJS = require('crypto-js');
const { getUserById, getVotingById, hasVoted, recordVote, logWorkflow, validateBiometric } = require('../data-access/voteData');
const { pv_cryptographicKeys } = require('../models/associations');

async function vote({ userID, votingID, proposalID, decision, biometricDataID }) {
  console.log('Voting data from getVotingById:', await getVotingById(votingID));
  const user = await getUserById(userID);
  if (!user) {
    const err = new Error('Usuario no autorizado o inactivo');
    err.status = 403;
    throw err;
  }

  // Validación de MFA y comprobación de vida
  if (!biometricDataID || !await validateBiometric(userID, biometricDataID)) {
    const err = new Error('Validación biométrica fallida o no habilitada');
    err.status = 401;
    throw err;
  }

  const voting = await getVotingById(votingID);
  console.log('Voting object:', voting);
  if (!voting || !voting.votingCore || voting.votingStatusID !== 1) {
    const err = new Error('Votación no disponible');
    err.status = 400;
    throw err;
  }

  if (user.accountStatusID !== 1) {
    const err = new Error('Usuario no activo');
    err.status = 403;
    throw err;
  }

  const now = new Date();
  if (now < voting.votingCore.startDate || now > voting.votingCore.endDate) {
    const err = new Error('Votación fuera de rango');
    err.status = 400;
    throw err;
  }

  // Generar voterHash único
  const voterHash = CryptoJS.SHA256(`${user.identityHash}-${votingID}`).toString();

  // Usar identityHash como voterHash
  if (await hasVoted(user.identityHash, votingID, proposalID)) {
    console.log('User has already voted');
    const err = new Error('Usuario ya votó');
    err.status = 400;
    throw err;
  }

  const key = await pv_cryptographicKeys.findOne({ where: { userID, keyType: 1 } });
  if (!key) {
    const err = new Error('Clave pública no encontrada. Registra una clave pública para este usuario.');
    err.status = 400;
    throw err;
  }

  const encryptedVote = CryptoJS.AES.encrypt(decision, key.keyValue.toString('utf8')).toString();

  const voteData = {
    votingID,
    proposalID,
    projectID: voting.projectID,
    questionID: 1,
    optionID: decision === 'Sí' ? 1 : 2,
    customValue: encryptedVote,
    voterHash: user.identityHash,
    prevHash: Buffer.from('PREV_HASH_' + userID),
    criptographicKey: key.cryptographicKeyID,
    tokenValue: Buffer.from('TOKEN_' + userID),
  };
  console.log('voteData:', voteData);
  const vote = await recordVote(voteData);

  // Usar votingID como workflowInstanceID (ajusta si es incorrecto para tu diseño)
  await logWorkflow(votingID, userID, 'Voto registrado', 'Voto procesado exitosamente');

  return { voteID: vote.voteID };
}

module.exports = { vote };