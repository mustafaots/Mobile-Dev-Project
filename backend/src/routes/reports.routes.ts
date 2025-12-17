import { Router } from 'express';
import { reportController } from '../controllers/report.controller';
import { authenticate } from '../middleware/authenticate';
import { buildCrudRouter } from './crud.factory';
import { reportsController } from '../controllers';

const router = Router();

// Protected routes (must come before CRUD)
router.get('/my', authenticate, reportController.getMyReports);
router.post('/', authenticate, reportController.create);

// Attach CRUD router for admin operations
const crudRouter = buildCrudRouter(reportsController);
router.use(crudRouter);

export default router;
