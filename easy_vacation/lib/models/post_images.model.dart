class PostImage {
  final int postId;
  final String imageData; // Base64 encoded image or file path

  PostImage({
    required this.postId,
    required this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'image': imageData,
    };
  }

  factory PostImage.fromMap(Map<String, dynamic> map) {
    return PostImage(
      postId: map['post_id'] ?? 0,
      imageData: map['image'] ?? '',
    );
  }
}

// update: made the post images id the same as the post id ( for primary key conflicts, we will use serial in the database)
// serial meaning: auto increment