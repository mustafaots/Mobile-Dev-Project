import 'package:easy_vacation/models/details.model.dart';
// extends stay details

class Stay {
  final int postId;
  final String stayType; // "apartment", "villa", "room", etc.
  final double area;
  final int bedrooms;

  Stay({
    required this.postId,
    required this.stayType,
    required this.area,
    required this.bedrooms,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'stay_type': stayType,
      'area': area,
      'bedrooms': bedrooms
    };
  }

  factory Stay.fromMap(Map<String, dynamic> map) {
    return Stay(
      postId: map['post_id'] ?? 0,
      stayType: map['stay_type'] ?? 'apartment',
      area: (map['area'] ?? 0).toDouble(),
      bedrooms: map['bedrooms'] ?? 1,
    );
  }

  factory Stay.fromStayDetails(int postId, StayDetails details) {
    return Stay(
      postId: postId,
      stayType: details.stayType,
      area: details.area,
      bedrooms: details.bedrooms,
    );
  }
}