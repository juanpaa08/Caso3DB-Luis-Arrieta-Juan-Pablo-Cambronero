// src/models/pv_commentRejectionLogs.js
const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_commentRejectionLogs extends Model {}

pv_commentRejectionLogs.init({
  rejectionLogID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'rejectionLogID'
  },
  proposalID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proposalID'
  },
  userID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'userID'
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
    field: 'content'
  },
  rejectionReason: {
    type: DataTypes.STRING(255),
    allowNull: false,
    field: 'rejectionReason'
  },
  timestamp: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: sequelize.fn('GETDATE'),
    field: 'timestamp' // Quitamos defaultValue para delegarlo a SQL Server
  }
}, {
  sequelize,
  modelName: 'pv_commentRejectionLogs',
  tableName: 'pv_commentRejectionLogs',
  timestamps: false
});

module.exports = pv_commentRejectionLogs;