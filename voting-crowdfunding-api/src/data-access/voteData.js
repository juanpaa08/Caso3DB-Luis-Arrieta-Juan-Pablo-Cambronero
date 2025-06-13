const { pv_users, pv_votings, pv_votes, pv_votingCore, pv_cryptographicKeys, pv_workflowLogs, pv_votingStatuses } = require('../models/associations');

async function getVotingById(votingID) {
  return await pv_votings.findOne({
    where: { votingID },
    include: [
      { model: pv_votingCore, as: 'votingCore' },
      { model: pv_votingStatuses, as: 'votingStatus' }
    ]
  });
}

async function getUserById(userID) {
  return await pv_users.findOne({ where: { userID, accountStatusID: 1 } });
}

async function hasVoted(voterHash, votingID, proposalID) {
  return await pv_votes.findOne({ 
    where: { 
      voterHash, 
      votingID,  // Añadir esta condición
      proposalID 
    }
  });
}

async function recordVote(voteData) {
  const vote = await pv_votes.create(voteData);
  return await pv_votes.create(voteData);
}

async function logWorkflow(workflowInstanceID, userID, message, description, detailsAI) {
  const log = await pv_workflowLogs.create({
    workflowInstanceID,
    userID,
    workflowLogTypeID: 1, // Ajusta según tu lógica
    message,
    description,
    detailsAI: detailsAI || 'Información no proporcionada'
  });
  return log;
}

module.exports = { getUserById, getVotingById, hasVoted, recordVote, logWorkflow };