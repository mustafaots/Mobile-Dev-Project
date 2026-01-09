import { CrudController } from './base.controller';
import { User } from '../types';
import { usersService, UserWithAuth } from '../services/users.service';
import { parseUUID } from '../utils/parsers';
import { UserProfileCreateInput, UserProfileUpdateInput, userProfileSchemas } from '../models';
import { Request, Response, NextFunction } from 'express';
import { asyncHandler } from '../middleware';

class UsersController extends CrudController<User, UserProfileCreateInput, UserProfileUpdateInput> {
  constructor() {
    super(usersService, (value) => parseUUID(value, 'user_id'), userProfileSchemas);
  }

  /**
   * Override getById to include email and phone from auth
   */
  getById = asyncHandler(async (req: Request, res: Response, _next: NextFunction) => {
    const id = parseUUID(req.params.id, 'user_id');
    const user: UserWithAuth = await usersService.getByIdWithAuth(id);
    res.json({ data: user });
  });
}

export const usersController = new UsersController();
export default usersController;
