abstract class BookedPostEvent {}

class LoadBookingInfo extends BookedPostEvent {
  final int postId;
  LoadBookingInfo(this.postId);
}

class CancelBooking extends BookedPostEvent {
  final int postId;
  CancelBooking(this.postId);
}
