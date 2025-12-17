import express from 'express';
import routes from './routes';
import { errorHandler, notFoundHandler, requestLogger } from './middleware';

const app = express();

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger);

app.get('/healthz', (_req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api', routes);
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
