const { sequelize } = require('./db');
const ProposalType = require('./src/models/proposalType');
const Currency = require('./src/models/currency');

async function test() {
  await sequelize.sync({ force: false });
  console.log('Modelos sincronizados');
  const proposalTypes = await ProposalType.findAll();
  console.log('Tipos de propuestas:', proposalTypes.map(pt => pt.toJSON()));
  const currencies = await Currency.findAll();
  console.log('Monedas:', currencies.map(c => c.toJSON()));
}

test().catch(err => console.error('Error:', err));