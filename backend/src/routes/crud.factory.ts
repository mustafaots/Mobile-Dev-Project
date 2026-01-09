import { Router } from 'express';
import { authenticate } from '../middleware';

interface CrudHandlers {
  list: (...args: any[]) => void;
  getById: (...args: any[]) => void;
  create: (...args: any[]) => void;
  update: (...args: any[]) => void;
  remove: (...args: any[]) => void;
}

export const buildCrudRouter = (controller: CrudHandlers) => {
  const router = Router();

  router.get('/', controller.list);
  router.post('/', authenticate, controller.create);
  router.get('/:id', controller.getById);
  router.put('/:id', authenticate, controller.update);
  router.patch('/:id', authenticate, controller.update);
  router.delete('/:id', authenticate, controller.remove);

  return router;
};
