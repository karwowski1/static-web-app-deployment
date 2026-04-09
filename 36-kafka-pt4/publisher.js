const { Kafka } = require('kafkajs');
const { v4: uuidv4 } = require('uuid');

const kafka = new Kafka({
  clientId: 'publisher-app',
  brokers: [process.env.KAFKA_BROKERS || 'localhost:29092']
});

const producer = kafka.producer();

const run = async () => {
  await producer.connect();

  setInterval(async () => {
    const isError = Math.random() < 0.3;

    const event = {
      event_id: uuidv4(),
      event_type: 'order_created',
      timestamp: new Date().toISOString(),
      payload: isError ? null : {
        order_id: `A-${Math.floor(Math.random() * 10000)}`,
        amount: 199.90
      }
    };

    await producer.send({
      topic: 'raw-data',
      messages: [{
        key: event.event_id,
        value: JSON.stringify(event)
      }],
    });
    console.log(`Sent ${isError ? 'INVALID' : 'VALID'} event: ${event.event_id}`);
  }, 2000);
};

run().catch(console.error);