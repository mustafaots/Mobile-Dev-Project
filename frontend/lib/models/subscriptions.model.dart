class Subscription {
  final int? id;
  final String subscriberId;
  final String plan; // 'free', 'monthly', 'yearly'
  final DateTime createdAt;

  Subscription({
    this.id,
    required this.subscriberId,
    required this.plan,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'subscriber_id': subscriberId,
      'plan': plan,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      subscriberId: (map['subscriber_id'] ?? '').toString(),
      plan: map['plan'] ?? 'free',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }
}