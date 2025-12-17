import app from './app';
import env from './config/env';

const start = async () => {
  try {
    app.listen(env.port, () => {
      console.info(`API server listening on port ${env.port}`);
    });
  } catch (error) {
    console.error('Unable to start server', error);
    process.exit(1);
  }
};

start();
