import { CrudController } from './base.controller';
import { User } from '../types';
import { usersService } from '../services';
import { parseUUID } from '../utils/parsers';
import { UserProfileCreateInput, UserProfileUpdateInput, userProfileSchemas } from '../models';

class UsersController extends CrudController<User, UserProfileCreateInput, UserProfileUpdateInput> {
  constructor() {
    super(usersService, (value) => parseUUID(value, 'user_id'), userProfileSchemas);
  }
}

export const usersController = new UsersController();
export default usersController;
