import { Router } from 'express';
import { authController } from '../controllers';
import { authenticate } from '../middleware';

const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/forgot-password', authController.forgotPassword);
router.get('/me', authenticate, authController.profile);

export default router;
