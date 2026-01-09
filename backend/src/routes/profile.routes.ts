import { Router } from 'express';
import { profileController } from '../controllers/profile.controller';
import { authenticate } from '../middleware/authenticate';

const router = Router();

// All profile routes require authentication
router.use(authenticate);

router.get('/', profileController.getMyProfile);
router.patch('/', profileController.updateMyProfile);
router.post('/verify', profileController.requestVerification);
router.delete('/', profileController.deleteAccount);

export default router;
