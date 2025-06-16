// src/models/pv_biometricData.js
const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_biometricData extends Model {}

pv_biometricData.init({
  biometricDataID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'biometricDataID'
  },
  userID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'userID'
  },
  biometricType: {
    type: DataTypes.STRING(20),
    allowNull: false,
    field: 'biometricType'
  },
  captureDevice: {
    type: DataTypes.STRING(30),
    allowNull: false,
    field: 'captureDevice'
  },
  captureDate: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'captureDate'
  },
  sampleQuality: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'sampleQuality'
  },
  enabled: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    field: 'enabled'
  },
  modelVersion: {
    type: DataTypes.STRING(20),
    allowNull: false,
    field: 'modelVersion'
  },
  integrityHash: {
    type: DataTypes.BLOB,
    allowNull: false,
    field: 'integrityHash'
  }
}, {
  sequelize,
  modelName: 'pv_biometricData',
  tableName: 'pv_biometricData',
  timestamps: false
});

// Relación con pv_users
const pv_users = require('./pv_users');
pv_biometricData.belongsTo(pv_users, { foreignKey: 'userID', targetKey: 'userID' });

module.exports = pv_biometricData;