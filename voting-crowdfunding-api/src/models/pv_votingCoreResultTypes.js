const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_votingCoreResultTypes extends Model {}

pv_votingCoreResultTypes.init({
  votingCoreResultTypeID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'votingCoreResultTypeID'
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'name'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    field: 'isActive'
  },
  updatedAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'updatedAt'
  }
}, {
  sequelize,
  modelName: 'pv_votingCoreResultTypes',
  tableName: 'pv_votingCoreResultTypes',
  timestamps: false
});

module.exports = pv_votingCoreResultTypes;