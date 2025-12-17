import { Router } from 'express';
import { imageController } from '../controllers/image.controller';
import { authenticate } from '../middleware/authenticate';

const router = Router();

// Delete image (protected)
router.delete('/:id', authenticate, imageController.deleteImage);

export default router;
