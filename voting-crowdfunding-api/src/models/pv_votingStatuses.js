const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_votingStatuses extends Model {}

pv_votingStatuses.init({
  votingStatusID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'votingStatusID'
  },
  name: {
    type: DataTypes.STRING(100), // nvarchar(100)
    allowNull: false,
    field: 'name'
  },
  isActive: {
    type: DataTypes.BOOLEAN, // bit
    allowNull: false,
    field: 'isActive'
  },
  updatedAt: {
    type: DataTypes.DATE, // datetime
    allowNull: false,
    field: 'updatedAt'
  }
}, {
  sequelize,
  modelName: 'pv_votingStatuses',
  tableName: 'pv_votingStatuses',
  timestamps: false
});

module.exports = pv_votingStatuses;