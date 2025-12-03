class PostImage {
  final int? id;
  final int postId;
  final String imageData; // Base64 encoded image or file path

  PostImage({
    this.id,
    required this.postId,
    required this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'image': imageData,
    };
  }

  factory PostImage.fromMap(Map<String, dynamic> map) {
    return PostImage(
      id: map['id'],
      postId: map['post_id'] ?? 0,
      imageData: map['image'] ?? '',
    );
  }
}