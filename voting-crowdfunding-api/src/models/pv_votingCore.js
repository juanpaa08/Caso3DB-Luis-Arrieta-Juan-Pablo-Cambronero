const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');
const pv_votingCoreResultTypes = require('./pv_votingCoreResultTypes'); // Relación con tipos de resultados

class pv_votingCore extends Model {}

pv_votingCore.init({
  votingID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    field: 'votingID'
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'title'
  },
  description: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'description'
  },
  startDate: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'startDate'
  },
  endDate: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'endDate'
  },
  approvalThreshold: {
    type: DataTypes.DECIMAL(5, 2),
    allowNull: false,
    field: 'approvalThreshold'
  },
  isPublic: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    field: 'isPublic'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    field: 'isActive'
  },
  isPrivate: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    field: 'isPrivate'
  },
  votingCoreResultTypeID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'votingCoreResultTypeID'
  }
}, {
  sequelize,
  modelName: 'pv_votingCore',
  tableName: 'pv_votingCore',
  timestamps: false
});

// Relación con pv_votingCoreResultTypes
pv_votingCore.belongsTo(pv_votingCoreResultTypes, { foreignKey: 'votingCoreResultTypeID', targetKey: 'votingCoreResultTypeID' });

module.exports = pv_votingCore;