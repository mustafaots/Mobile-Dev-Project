import 'package:easy_vacation/models/reviews.model.dart';

abstract class AddReviewState {
  const AddReviewState();
}

class AddReviewInitial extends AddReviewState {
  const AddReviewInitial();
}

class AddReviewLoading extends AddReviewState {
  const AddReviewLoading();
}

class AddReviewSuccess extends AddReviewState {
  final Review review;

  const AddReviewSuccess(this.review);

  AddReviewSuccess copyWith({
    Review? review,
  }) {
    return AddReviewSuccess(
      review ?? this.review,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddReviewSuccess && other.review == review;
  }

  @override
  int get hashCode => review.hashCode;
}

class AddReviewFailure extends AddReviewState {
  final String message;

  const AddReviewFailure(this.message);

  AddReviewFailure copyWith({
    String? message,
  }) {
    return AddReviewFailure(
      message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddReviewFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class AddReviewValidationError extends AddReviewState {
  final String error;

  const AddReviewValidationError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddReviewValidationError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class DeleteReviewSuccess extends AddReviewState {
  const DeleteReviewSuccess();
}