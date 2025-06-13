const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_votes extends Model {}

pv_votes.init({
  voteID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'voteID' },
  votingID: { type: DataTypes.INTEGER, allowNull: false, field: 'votingID' },
  proposalID: { type: DataTypes.INTEGER, allowNull: false, field: 'proposalID' },
  projectID: { type: DataTypes.INTEGER, allowNull: false, field: 'projectID' },
  questionID: { type: DataTypes.INTEGER, allowNull: false, field: 'questionID' },
  optionID: { type: DataTypes.INTEGER, allowNull: true, field: 'optionID' },
  customValue: { type: DataTypes.STRING, allowNull: true, field: 'customValue' },
  voterHash: { type: DataTypes.BLOB, allowNull: false, field: 'voterHash' },
  prevHash: { type: DataTypes.BLOB, allowNull: false, field: 'prevHash' },
  criptographicKey: { type: DataTypes.INTEGER, allowNull: false, field: 'criptographicKey' },
  voteDate: { type: DataTypes.DATE, allowNull: true, defaultValue: sequelize.fn('GETDATE'), field: 'voteDate' }, // Quitar defaultValue
  tokenUsedAt: { type: DataTypes.DATE, allowNull: true, field: 'tokenUsedAt' },
  tokenValue: { type: DataTypes.BLOB, allowNull: false, field: 'tokenValue' }
}, {
  sequelize,
  modelName: 'pv_votes',
  tableName: 'pv_votes',
  timestamps: false
});

module.exports = pv_votes;