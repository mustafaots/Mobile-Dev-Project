import { Router } from 'express';
import { authController } from '../controllers';
import { authenticate } from '../middleware';

const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/forgot-password', authController.forgotPassword);
router.get('/me', authenticate, authController.profile);
router.post('/reset-password', authController.resetPassword);
router.post('/change-password', authenticate, authController.changePassword);

// Email verification routes
router.post('/email/verify', authenticate, authController.sendEmailVerification);
router.get('/email/status', authenticate, authController.getEmailVerificationStatus);

export default router;
