import 'package:flutter/material.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class TitleSection extends StatelessWidget {
  final Post? post;

  const TitleSection({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    final title = post?.title ?? 'Serene Oceanfront Villa';
    final description =
        post?.description ??
        'Escape to our charming beachfront villa, where you can relax and enjoy the sound of the waves. Perfect for a romantic getaway or a small family vacation.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
