import { BaseService } from './base.service';
import { User } from '../types';

class UsersService extends BaseService<User> {
  constructor() {
    super('users', 'user_id');
  }
}

export const usersService = new UsersService();
export default usersService;
