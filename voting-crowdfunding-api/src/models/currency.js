const { DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

const Currency = sequelize.define('pv_currencies', {
  currencyID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: DataTypes.STRING(100),
  acronym: DataTypes.STRING(10),
  symbol: DataTypes.STRING(10),
  country: DataTypes.STRING(100)
}, {
  tableName: 'pv_currencies',
  timestamps: false
});

module.exports = Currency;