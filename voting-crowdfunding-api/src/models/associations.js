const pv_users = require('./pv_users');
const pv_votings = require('./pv_votings');
const pv_votes = require('./pv_votes');
const pv_votingCore = require('./pv_votingCore');
const pv_cryptographicKeys = require('./pv_cryptographicKeys');
const pv_workflowLogs = require('./pv_workflowLogs');
const pv_votingStatuses = require('./pv_votingStatuses');
const pv_votingCoreResultTypes = require('./pv_votingCoreResultTypes');
const pv_biometricData = require('./pv_biometricData');

// Relaciones
pv_votings.belongsTo(pv_votingCore, { foreignKey: 'votingID', targetKey: 'votingID', as: 'votingCore' });
pv_votingCore.hasMany(pv_votings, { foreignKey: 'votingID', sourceKey: 'votingID', as: 'votings' });

pv_votings.belongsTo(pv_votingStatuses, { foreignKey: 'votingStatusID', targetKey: 'votingStatusID', as: 'votingStatus' });

pv_votingCore.belongsTo(pv_votingCoreResultTypes, { foreignKey: 'votingCoreResultTypeID', targetKey: 'votingCoreResultTypeID' });

module.exports = {
  pv_users,
  pv_votings,
  pv_votes,
  pv_votingCore,
  pv_cryptographicKeys,
  pv_workflowLogs,
  pv_votingStatuses,
  pv_votingCoreResultTypes,
  pv_biometricData
};