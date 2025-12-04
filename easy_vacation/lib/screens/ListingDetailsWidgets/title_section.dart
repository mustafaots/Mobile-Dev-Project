import 'package:flutter/material.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class TitleSection extends StatelessWidget {
  final Post? post;

  const TitleSection({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
  

    final title = post?.title ?? 'Serene Oceanfront Villa';
    

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
         
        ],
      ),
    );
  }
}
