const { Kafka } = require('kafkajs');
const { v4: uuidv4 } = require('uuid');

const kafka = new Kafka({
  clientId: 'publisher-app',
  brokers: ['localhost:29092']
});

const producer = kafka.producer();

const run = async () => {
  await producer.connect();
  console.log('Publisher connected to Kafka');


  const event = {
    event_id: uuidv4(),
    event_type: 'order_created',
    source_service: 'publisher-service',
    timestamp: new Date().toISOString(),
    payload: {
      order_id: 'A-10006',
      customer_id: 'C-42',
      amount: 199.90,
      currency: 'PLN'
    }
  };

  const topicName = 'Payment-app-events';
  await producer.send({
    topic: topicName,
    messages: [
      {
        key: event.payload.order_id,
        value: JSON.stringify(event)
      },
    ],
  });

  console.log('Event sent successfully:', event.event_id);

  await producer.disconnect();
};

run().catch(console.error);