import { CrudController } from './base.controller';
import { Booking } from '../types';
import { bookingsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { BookingCreateInput, BookingUpdateInput, bookingSchemas } from '../models';

class BookingsController extends CrudController<Booking, BookingCreateInput, BookingUpdateInput> {
  constructor() {
    super(bookingsService, (value) => parseNumericId(value, 'id'), bookingSchemas);
  }
}

export const bookingsController = new BookingsController();
export default bookingsController;
