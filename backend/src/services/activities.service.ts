import { BaseService } from './base.service';
import { Activity } from '../types';

class ActivitiesService extends BaseService<Activity> {
  constructor() {
    super('activities', 'post_id');
  }
}

export const activitiesService = new ActivitiesService();
export default activitiesService;
