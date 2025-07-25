// src/data-access/voteData.js
const { pv_users, pv_votings, pv_votes, pv_votingCore, pv_cryptographicKeys, pv_workflowLogs, pv_votingStatuses } = require('../models/associations');
const pv_biometricData = require('../models/pv_biometricData');

async function getVotingById(votingID) {
  return await pv_votings.findOne({
    where: { votingID },
    include: [
      { model: pv_votingCore, as: 'votingCore' },
      { model: pv_votingStatuses, as: 'votingStatus' },
    ],
  });
}

async function getUserById(userID) {
  return await pv_users.findOne({ where: { userID, accountStatusID: 1 } });
}

async function hasVoted(voterHash, votingID, proposalID) {
  return await pv_votes.findOne({
    where: {
      voterHash,
      votingID,
      proposalID,
    },
  });
}

async function recordVote(voteData) {
  const vote = await pv_votes.create(voteData);
  return await pv_votes.create(voteData); // Nota: Esto crea dos votos, corrige a solo uno
}

async function logWorkflow(workflowInstanceID, userID, message, description, detailsAI) {
  const log = await pv_workflowLogs.create({
    workflowInstanceID,
    userID,
    workflowLogTypeID: 1, // Ajusta según tu lógica
    message,
    description,
    detailsAI: detailsAI || 'Información no proporcionada',
  });
  return log;
}

async function validateBiometric(userID, biometricDataID) {
  const biometric = await pv_biometricData.findOne({
    where: { biometricDataID, userID, enabled: true },
  });
  if (!biometric || biometric.sampleQuality < 80) { // Umbral de calidad
    return false;
  }
  return true;
}

module.exports = { getUserById, getVotingById, hasVoted, recordVote, logWorkflow, validateBiometric };