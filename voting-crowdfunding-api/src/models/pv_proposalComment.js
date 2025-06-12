const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../../db');

class pv_proposalComment extends Model {}

pv_proposalComment.init({
  proposalCommentID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'proposalCommentID'
  },
  proposalID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proposalID'
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
    field: 'content'
  },
  publishDate: {
    type: DataTypes.DATE,
    allowNull: true, // Cambiamos a true temporalmente para evitar validación
    defaultValue: sequelize.fn('GETDATE'), // Usa la función GETDATE de SQL Server
    field: 'publishDate'
  },
  status: {
    type: DataTypes.STRING(20),
    allowNull: false,
    field: 'status'
  },
  likes: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
    field: 'likes'
  },
  reports: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0,
    field: 'reports'
  },
  proposalVersion: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
    field: 'proposalVersion'
  }
}, {
  sequelize,
  modelName: 'pv_proposalComment',
  tableName: 'pv_proposalComment',
  timestamps: false
});

module.exports = pv_proposalComment;