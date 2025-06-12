const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_propposals extends Model {}

pv_propposals.init({
  proposalID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'proposalID'
  },
  proposalTypeID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proposalTypeID'
  },
  name: {
    type: DataTypes.STRING(150),
    allowNull: false,
    field: 'name'
  },
  userID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'userID'
  },
  integrityHash: {
    type: DataTypes.BLOB,
    allowNull: false,
    field: 'integrityHash'
  },
  description: {
    type: DataTypes.STRING(500),
    allowNull: true,
    field: 'description'
  }
}, {
  sequelize,
  modelName: 'pv_propposals', // Cambiar a pv_propposals
  tableName: 'pv_propposals', // Cambiar a pv_propposals
  timestamps: true,
  createdAt: 'createdAt',
  updatedAt: 'lastUpdate'
});

module.exports = pv_propposals;
