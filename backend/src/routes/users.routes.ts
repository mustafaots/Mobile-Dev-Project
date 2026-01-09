import { Router } from 'express';
import { usersController } from '../controllers';
import { buildCrudRouter } from './crud.factory';

const usersRouter = Router();
usersRouter.use('/', buildCrudRouter(usersController));

// New route to fetch any user's info by ID
usersRouter.get('/:id', usersController.getById);

export default usersRouter;