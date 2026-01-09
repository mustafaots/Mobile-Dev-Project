import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late BookingService bookingService;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    bookingService = BookingService.test(mockApiClient);
  });

  test('create and cancel booking flow', () async {
    //Create booking
    final request = CreateBookingRequest(
      postId: 1,
      clientId: 'user-123',
      startTime: DateTime(2026, 1, 15),
      endTime: DateTime(2026, 1, 20),
    );

    when(
      () => mockApiClient.post(
        ApiConfig.bookings,
        body: any(named: 'body'),
        requiresAuth: true,
      ),
    ).thenAnswer(
      (_) async => {
        'data': {
          'id': 1,
          'post_id': 1,
          'client_id': 'user-123',
          'status': 'pending',
          'booked_at': DateTime.now().toIso8601String(),
          'reservation':
              '[{"startDate":"2026-01-15T12:00:00.000Z","endDate":"2026-01-20T12:00:00.000Z"}]',
        },
      },
    );

    final createResult = await bookingService.createBooking(request);

    expect(createResult.isSuccess, true);
    expect(createResult.data, isNotNull);
    expect(createResult.data!.id, 1);
    expect(createResult.data!.status, 'pending');

    //Cancel the same booking
    when(
      () => mockApiClient.post(
        '${ApiConfig.bookings}/${createResult.data!.id}/cancel',
        requiresAuth: true,
      ),
    ).thenAnswer(
      (_) async => {
        'data': {
          'id': 1,
          'post_id': 1,
          'client_id': 'user-123',
          'status': 'cancelled',
          'booked_at': DateTime.now().toIso8601String(),
          'reservation':
              '[{"startDate":"2026-01-15T12:00:00.000Z","endDate":"2026-01-20T12:00:00.000Z"}]',
        },
      },
    );

    final cancelResult = await bookingService.cancelBooking(
      createResult.data!.id!,
    );

    expect(cancelResult.isSuccess, true);
    expect(cancelResult.data, isNotNull);
    expect(cancelResult.data!.id, createResult.data!.id);
    expect(cancelResult.data!.status, 'cancelled');
  });
}
