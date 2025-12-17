class Review {
  final int? id;
  final int postId;
  final int reviewerId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;

  Review({
    this.id,
    required this.postId,
    required this.reviewerId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'reviewer_id': reviewerId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      postId: map['post_id'] ?? 0,
      reviewerId: map['reviewer_id'] ?? 0,
      rating: map['rating'] ?? 5,
      comment: map['comment'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }
}