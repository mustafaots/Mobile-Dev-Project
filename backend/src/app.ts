import express from 'express';
import routes from './routes';
import { errorHandler, notFoundHandler, requestLogger } from './middleware';

const app = express();

// Increase body size limit for image uploads (base64 images can be large)
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(requestLogger);

app.get('/healthz', (_req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api', routes);
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
