import { BaseService } from './base.service';
import { Subscription } from '../types';

class SubscriptionsService extends BaseService<Subscription> {
  constructor() {
    super('subscriptions', 'id');
  }
}

export const subscriptionsService = new SubscriptionsService();
export default subscriptionsService;
