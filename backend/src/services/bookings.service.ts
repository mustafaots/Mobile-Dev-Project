import { BaseService } from './base.service';
import { Booking } from '../types';

class BookingsService extends BaseService<Booking> {
  constructor() {
    super('bookings', 'id');
  }
}

export const bookingsService = new BookingsService();
export default bookingsService;
