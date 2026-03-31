const { Kafka } = require('kafkajs');

const instanceName = process.env.INSTANCE_NAME || `Worker-${Math.floor(Math.random() * 1000)}`;

const kafka = new Kafka({
  clientId: 'processor-app',
  brokers: ['localhost:29092']
});

const consumer = kafka.consumer({ groupId: 'processor-group' });

const run = async () => {

  await consumer.connect();
  console.log('Consumer connected to Kafka');

  await consumer.subscribe({ topic: 'Payment-app-events', fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const eventData = JSON.parse(message.value.toString());
      console.log('New Event Received:');
      console.log(`Topic: ${topic}`);
      console.log(`Partition: ${partition}`);
      console.log(`Offset: ${message.offset}`);
      console.log('Data:', eventData);
    },
  });
};

run().catch(console.error);