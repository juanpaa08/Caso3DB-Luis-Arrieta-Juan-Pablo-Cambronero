const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_users extends Model {}

pv_users.init({
  userID: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true, field: 'userID' },
  name: { type: DataTypes.STRING, allowNull: false, field: 'name' },
  lastName: { type: DataTypes.STRING, allowNull: false, field: 'lastName' },
  birthDate: { type: DataTypes.DATE, allowNull: false, field: 'birthDate' },
  registerDate: { type: DataTypes.DATE, allowNull: false, field: 'registerDate' },
  lastUpdate: { type: DataTypes.DATE, allowNull: true, field: 'lastUpdate' },
  accountStatusID: { type: DataTypes.INTEGER, allowNull: false, field: 'accountStatusID' },
  identityHash: { type: DataTypes.BLOB, allowNull: false, field: 'identityHash' },
  password: { type: DataTypes.BLOB, allowNull: false, field: 'password' },
  failedAttempts: { type: DataTypes.INTEGER, allowNull: false, field: 'failedAttempts' },
  publicKey: { type: DataTypes.BLOB, allowNull: true, field: 'publicKey' },
  privateKeyEncrypted: { type: DataTypes.BLOB, allowNull: true, field: 'privateKeyEncrypted' }
}, {
  sequelize,
  modelName: 'pv_users',
  tableName: 'pv_users',
  timestamps: false
});

module.exports = pv_users;