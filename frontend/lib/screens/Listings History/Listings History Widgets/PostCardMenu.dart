import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/screens/Listings%20History/PostActionsService.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class PostCardMenu extends StatelessWidget {
  final Post post;
  final Function(Post) onPostRemoved;
  final Function(Post) onPostUpdated;

  const PostCardMenu({
    super.key,
    required this.post,
    required this.onPostRemoved,
    required this.onPostUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;
    final postActionsService = PostActionsService(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: secondaryTextColor),
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            postActionsService.editPost(post);
            break;
          case 'delete':
            final result = await postActionsService.deletePost(post);
            if (result == true) onPostRemoved(post);
            break;
          case 'publish':
            final updatedPost = await postActionsService.publishPost(post);
            if (updatedPost != null) onPostUpdated(updatedPost);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'edit', child: Text(loc.listingHistory_editPost)),
        PopupMenuItem(value: 'delete', child: Text(loc.listingHistory_deletePost)),
        if (post.status == 'draft')
          PopupMenuItem(value: 'publish', child: Text(loc.listingHistory_publish)),
      ],
    );
  }
}