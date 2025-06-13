const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');
const pv_users = require('./pv_users'); // Relación con usuarios

class pv_cryptographicKeys extends Model {}

pv_cryptographicKeys.init({
  cryptographicKeyID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'cryptographicKeyID'
  },
  keyType: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'keyType'
  },
  algorithm: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'algorithm'
  },
  keyValue: {
    type: DataTypes.BLOB,
    allowNull: false,
    field: 'keyValue'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'createdAt'
  },
  expirationDate: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'expirationDate'
  },
  status: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'status'
  },
  mainUse: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'mainUse'
  },
  hashKey: {
    type: DataTypes.BLOB,
    allowNull: false,
    field: 'hashKey'
  },
  enclaveID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'enclaveID'
  },
  digitalSignatureID: {
    type: DataTypes.INTEGER,
    allowNull: true,
    field: 'digitalSignatureID'
  },
  userID: {
    type: DataTypes.INTEGER,
    allowNull: true,
    field: 'userID'
  },
  institutionID: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'institutionID'
  }
}, {
  sequelize,
  modelName: 'pv_cryptographicKeys',
  tableName: 'pv_cryptographicKeys',
  timestamps: false
});

// Relación con pv_users
pv_cryptographicKeys.belongsTo(pv_users, { foreignKey: 'userID', targetKey: 'userID' });

module.exports = pv_cryptographicKeys;