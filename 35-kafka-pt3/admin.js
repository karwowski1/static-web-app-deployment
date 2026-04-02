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
    topics: [
      { topic: 'raw-data', numPartitions: 3 },
      { topic: 'processed-data', numPartitions: 3 },
      { topic: 'dlq-data', numPartitions: 3 }
    ],
  });

  console.log('Topics (Raw, Processed, DLQ) created successfully!');
  await admin.disconnect();
};

run().catch(console.error);