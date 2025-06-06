const { DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

const ProposalType = sequelize.define('pv_proposalType', {
  propposalTypeID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: DataTypes.STRING(255),
  description: DataTypes.TEXT,
  applicationLevel: DataTypes.STRING(50),
  category: DataTypes.STRING(50),
  status: DataTypes.STRING(50),
  minimumRequirements: DataTypes.TEXT,
  contentTemplate: DataTypes.TEXT,
  version: DataTypes.FLOAT,
  lastUpdate: DataTypes.DATE
}, {
  tableName: 'pv_proposalType',
  timestamps: false
});

module.exports = ProposalType;