const { Kafka } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'publisher-app',
  brokers: [process.env.KAFKA_BROKERS || 'localhost:29092']
});

const consumer = kafka.consumer({ groupId: 'processor-group' });
const producer = kafka.producer({ idempotent: true });

const run = async () => {
  await consumer.connect();
  await producer.connect();

  await consumer.subscribe({ topic: 'raw-data', fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const rawValue = message.value.toString();
      const event = JSON.parse(rawValue);

      try {
        if (!event.payload || !event.payload.order_id) {
          throw new Error('Missing required business data');
        }

        const processedEvent = {
          ...event,
          status: 'PROCESSED',
          processed_at: new Date().toISOString(),
          source_event_id: event.event_id
        };

        await producer.send({
          topic: 'processed-data',
          messages: [{ key: event.event_id, value: JSON.stringify(processedEvent) }]
        });

      } catch (err) {
        console.error(`Error processing event ${event.event_id}: ${err.message}`);
        await producer.send({
          topic: 'dlq-data',
          messages: [{
            key: event.event_id,
            value: JSON.stringify({ error: err.message, original_event: event })
          }]
        });
      }
    },
  });
};

run().catch(console.error);