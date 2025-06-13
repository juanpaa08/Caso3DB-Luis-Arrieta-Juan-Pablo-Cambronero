const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');
const pv_votingStatuses = require('./pv_votingStatuses');

class pv_votings extends Model {}

pv_votings.init({
  votingID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'votingID' },
  proposalID: { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  configurationHash: { type: DataTypes.BLOB, allowNull: false, field: 'configurationHash' },
  createdAt: { type: DataTypes.DATE, allowNull: false, field: 'createdAt' },
  quorum: { type: DataTypes.INTEGER, allowNull: false, field: 'quorum' },
  projectID: { type: DataTypes.INTEGER, allowNull: false, field: 'projectID' },
  votingStatusID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'votingStatusID',
    references: {
      model: pv_votingStatuses,
      key: 'votingStatusID'
    }
  }
}, {
  sequelize,
  modelName: 'pv_votings',
  tableName: 'pv_votings',
  timestamps: false
});

pv_votings.belongsTo(pv_votingStatuses, { foreignKey: 'votingStatusID', targetKey: 'votingStatusID' });

module.exports = pv_votings;