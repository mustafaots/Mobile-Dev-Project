import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/posts.model.dart';

abstract class HostInfoState {
  const HostInfoState();
}

class HostInfoInitial extends HostInfoState {
  const HostInfoInitial();
}

class HostInfoLoading extends HostInfoState {
  const HostInfoLoading();
}

class HostInfoLoaded extends HostInfoState {
  final User host;
  final Post post;
  final int reviewCount;
  final double rating;

  const HostInfoLoaded({
    required this.host,
    required this.post,
    required this.reviewCount,
    required this.rating,
  });

  HostInfoLoaded copyWith({
    User? host,
    Post? post,
    int? reviewCount,
    double? rating,
  }) {
    return HostInfoLoaded(
      host: host ?? this.host,
      post: post ?? this.post,
      reviewCount: reviewCount ?? this.reviewCount,
      rating: rating ?? this.rating,
    );
  }
}

class HostInfoError extends HostInfoState {
  final String message;

  const HostInfoError(this.message);
}
