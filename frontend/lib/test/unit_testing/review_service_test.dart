import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:easy_vacation/services/api/review_service.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';


class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ReviewService reviewService;

  setUp(() {
    mockApiClient = MockApiClient();
    reviewService = ReviewService.test(mockApiClient);
  });


  // getReviewsForListing
  test('getReviewsForListing returns list of reviews on success', () async {
    when(() => mockApiClient.get(any()))
        .thenAnswer((_) async => {
              'data': [
                {
                  'id': 1,
                  'rating': 5,
                  'comment': 'Great place',
                  'reviewer_name': 'Eren Yeager',
                  'listing_title': 'Hotel ABC',
                }
              ]
            });

    final result = await reviewService.getReviewsForListing(10);

    expect(result.isSuccess, true);
    expect(result.data, isNotNull);
    expect(result.data!.length, 1);
    expect(result.data!.first.review.rating, 5);
    expect(result.data!.first.reviewerName, 'Eren Yeager');
  });

  test('getReviewsForListing returns error on exception', () async {
    when(() => mockApiClient.get(any()))
        .thenThrow(Exception('Network error'));

    final result = await reviewService.getReviewsForListing(10);

    expect(result.isError, true);
    expect(result.message, isNotNull);
  });


  // getRatingSummary
  test('getRatingSummary parses rating summary correctly', () async {
    when(() => mockApiClient.get(any()))
        .thenAnswer((_) async => {
              'data': {
                'average': 4.5,
                'total': 20,
                'distribution': {
                  '5': 10,
                  '4': 6,
                  '3': 4,
                }
              }
            });

    final result = await reviewService.getRatingSummary(3);

    expect(result.isSuccess, true);
    expect(result.data!.averageRating, 4.5);
    expect(result.data!.totalReviews, 20);
    expect(result.data!.ratingDistribution[5], 10);
  });


  // getMyReviews
  test('getMyReviews calls authenticated endpoint', () async {
    when(() => mockApiClient.get(
          any(),
          requiresAuth: true,
        )).thenAnswer((_) async => {
              'data': [
                {
                  'id': 2,
                  'rating': 4,
                  'comment': 'Nice',
                }
              ]
            });

    final result = await reviewService.getMyReviews();

    expect(result.isSuccess, true);
    expect(result.data!.first.review.rating, 4);
  });


  // createReview
  test('createReview sends correct body and returns Review', () async {
    final request = CreateReviewRequest(
      listingId: 5,
      rating: 4,
      comment: 'Good',
    );

    when(() => mockApiClient.post(
          ApiConfig.reviews,
          body: request.toJson(),
          requiresAuth: true,
        )).thenAnswer((_) async => {
              'data': {
                'id': 1,
                'rating': 4,
                'comment': 'Good',
              }
            });

    final result = await reviewService.createReview(request);

    expect(result.isSuccess, true);
    expect(result.data!.rating, 4);
  });


  // updateReview
  test('updateReview updates rating and comment', () async {
    when(() => mockApiClient.patch(
          any(),
          body: any(named: 'body'),
          requiresAuth: true,
        )).thenAnswer((_) async => {
              'data': {
                'id': 1,
                'rating': 3,
                'comment': 'Updated',
              }
            });

    final result = await reviewService.updateReview(
      1,
      rating: 3,
      comment: 'Updated',
    );

    expect(result.isSuccess, true);
    expect(result.data!.rating, 3);
  });


  // deleteReview
  test('deleteReview returns success when API succeeds', () async {
    when(() => mockApiClient.delete(
          any(),
          requiresAuth: true,
        )).thenAnswer((_) async => {});

    final result = await reviewService.deleteReview(1);

    expect(result.isSuccess, true);
  });


  // canReviewPost
  test('canReviewPost returns true when backend allows review', () async {
    when(() => mockApiClient.get(
          any(),
          requiresAuth: true,
        )).thenAnswer((_) async => {
              'data': {'canReview': true}
            });

    final result = await reviewService.canReviewPost(5);

    expect(result.isSuccess, true);
    expect(result.data, true);
  });
}