const { Model, DataTypes } = require('sequelize');
// Subimos dos niveles hasta db.js
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
    allowNull: false,
    defaultValue: DataTypes.NOW,
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
  proposalVersionID: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'proposalVersionID'
  }
}, {
  sequelize,
  modelName: 'pv_proposalComment',
  tableName: 'pv_proposalComment',
  timestamps: false
});

module.exports = pv_proposalComment;
