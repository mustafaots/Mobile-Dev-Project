import 'dart:convert';
import 'dart:typed_data';

class PostImage {
  final int postId;
  final String imageData; // Base64 encoded image or file path

  PostImage({required this.postId, required this.imageData});

  Map<String, dynamic> toMap() {
    return {'post_id': postId, 'image': imageData};
  }

  factory PostImage.fromMap(Map<String, dynamic> map) {
    // Handle both String (Base64) and Uint8List (raw bytes) from database
    dynamic imageValue = map['image'];
    String base64String = '';

    if (imageValue is String) {
      // Already a string (Base64 encoded)
      base64String = imageValue;
    } else if (imageValue is Uint8List) {
      // Raw bytes from database - convert to Base64
      base64String = base64Encode(imageValue);
    } else if (imageValue is List<int>) {
      // List of integers - convert to Base64
      base64String = base64Encode(Uint8List.fromList(imageValue));
    }

    return PostImage(postId: map['post_id'] ?? 0, imageData: base64String);
  }
}

// update: made the post images id the same as the post id ( for primary key conflicts, we will use serial in the database)
// serial meaning: auto increment
