const { Model, DataTypes } = require('sequelize');
// Subimos dos niveles hacia db.js
const { sequelize } = require('../../db');

class pv_proposalCore extends Model {}

pv_proposalCore.init({
  proposalCoreID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'proposalCoreID'
  },
  description: {
    type: DataTypes.STRING(200),
    allowNull: false,
    field: 'description'
  },
  benefits: {
    type: DataTypes.STRING(350),
    allowNull: false,
    field: 'benefits'
  },
  estimatedBudget: {
    type: DataTypes.DECIMAL(16, 2),
    allowNull: false,
    field: 'estimatedBudget'
  },
  status: {
    type: DataTypes.STRING(20),
    allowNull: false,
    field: 'status'
  },
  lastUpdate: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'lastUpdate'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'createdAt'
  },
  proposalID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proposalID'
  }
}, {
  sequelize,
  modelName: 'pv_proposalCore',
  tableName: 'pv_proposalCore',
  timestamps: false
});

module.exports = pv_proposalCore;
