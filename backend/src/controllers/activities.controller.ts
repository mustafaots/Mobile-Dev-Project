import { CrudController } from './base.controller';
import { Activity } from '../types';
import { activitiesService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { ActivityCreateInput, ActivityUpdateInput, activitySchemas } from '../models';

class ActivitiesController extends CrudController<Activity, ActivityCreateInput, ActivityUpdateInput> {
  constructor() {
    super(activitiesService, (value) => parseNumericId(value, 'post_id'), activitySchemas);
  }
}

export const activitiesController = new ActivitiesController();
export default activitiesController;
