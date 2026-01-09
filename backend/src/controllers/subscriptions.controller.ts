import { CrudController } from './base.controller';
import { Subscription } from '../types';
import { subscriptionsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { SubscriptionCreateInput, SubscriptionUpdateInput, subscriptionSchemas } from '../models';

class SubscriptionsController extends CrudController<
  Subscription,
  SubscriptionCreateInput,
  SubscriptionUpdateInput
> {
  constructor() {
    super(subscriptionsService, (value) => parseNumericId(value, 'id'), subscriptionSchemas);
  }
}

export const subscriptionsController = new SubscriptionsController();
export default subscriptionsController;
