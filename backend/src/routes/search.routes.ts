import { Router } from 'express';
import { searchController } from '../controllers/search.controller';

const router = Router();

// All search routes are public
router.get('/', searchController.search);
router.get('/suggestions', searchController.getSuggestions);
router.get('/locations', searchController.getLocations);
router.get('/featured', searchController.getFeatured);

export default router;
