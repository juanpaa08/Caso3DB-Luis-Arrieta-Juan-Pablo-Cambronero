const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');
const pv_users = require('./pv_users'); // Relación con usuarios

class pv_workflowLogs extends Model {}

pv_workflowLogs.init({
  workflowLogID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'workflowLogID'
  },
  workflowInstanceID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'workflowInstanceID'
  },
  userID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'userID'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: sequelize.fn('GETDATE'),
    field: 'createdAt'
  },
  workflowLogTypeID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'workflowLogTypeID'
  },
  message: {
    type: DataTypes.STRING(255),
    allowNull: false,
    field: 'message'
  },
  description: {
    type: DataTypes.STRING(255),
    allowNull: true,
    field: 'description'
  },
  detailsAI: {
    type: DataTypes.STRING(255),
    allowNull: false,
    field: 'detailsAI'
  }
}, {
  sequelize,
  modelName: 'pv_workflowLogs',
  tableName: 'pv_workflowLogs',
  timestamps: false
});

// Relación con pv_users
pv_workflowLogs.belongsTo(pv_users, { foreignKey: 'userID', targetKey: 'userID' });

module.exports = pv_workflowLogs;