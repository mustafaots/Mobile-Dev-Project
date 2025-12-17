class Report {
  final int? id;
  final int reporterId;
  final int? reportedPostId;
  final int? reportedUserId;
  final String reason; // 'inappropriate_content', 'scam_spam', 'misleading_info', 'safety_concerns', 'other'
  final DateTime createdAt;

  Report({
    this.id,
    required this.reporterId,
    this.reportedPostId,
    this.reportedUserId,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'reporter_id': reporterId,
      'reported_post_id': reportedPostId,
      'reported_user_id': reportedUserId,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      reporterId: map['reporter_id'] ?? 0,
      reportedPostId: map['reported_post_id'],
      reportedUserId: map['reported_user_id'],
      reason: map['reason'] ?? 'other',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }
}