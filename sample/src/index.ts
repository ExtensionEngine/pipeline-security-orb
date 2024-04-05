import Fastify from 'fastify';

const app = Fastify({
  logger: true,
});

app.get('/status', async (request, reply) => {
  return 'OK\n';
});

app.listen({ port: 8080 }, (err, address) => {
  if (err) {
    app.log.error(err);
    process.exit(1);
  }

  app.log.info(`Server listening at ${address}`);
});
