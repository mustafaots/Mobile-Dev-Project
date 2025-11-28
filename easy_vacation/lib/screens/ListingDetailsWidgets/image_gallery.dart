import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final images = const [
            {
              'path': 'assets/images/beachfront_cottage.jpg',
              'alt': 'A beautiful beachfront cottage with a porch',
            },
            {
              'path': 'assets/images/living_room.jpg',
              'alt': 'The cozy living room of the cottage with a fireplace',
            },
            {
              'path': 'assets/images/bedroom_ocean_view.jpg',
              'alt': 'A bedroom with a view of the ocean',
            },
          ];
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(images[index]['path']!),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
