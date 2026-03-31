const { Kafka } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'admin-app',
  brokers: ['localhost:29092']
});

const admin = kafka.admin();

const run = async () => {
  await admin.connect();
  console.log('Admin connected!');

  await admin.createTopics({
    topics: [{
      topic: 'Payment-app-events',
      numPartitions: 3,
    }],
  });

  console.log('Topic created!');
  await admin.disconnect();
};

run().catch(console.error);