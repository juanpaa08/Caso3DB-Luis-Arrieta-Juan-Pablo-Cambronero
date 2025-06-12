const { Model, DataTypes } = require('sequelize');
// Subimos dos niveles: src/models → src → raíz (donde está db.js)
const { sequelize } = require('../../db');

class pv_proposals extends Model {}

pv_proposals.init({
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
  modelName: 'pv_proposals',
  tableName: 'pv_proposals',
  timestamps: true,
  createdAt: 'createdAt',
  updatedAt: 'lastUpdate'
});

module.exports = pv_proposals;
