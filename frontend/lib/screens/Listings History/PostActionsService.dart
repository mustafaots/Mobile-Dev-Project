import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class PostActionsService {
  final BuildContext context;

  PostActionsService(this.context);

  Future<void> editPost(Post post) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${post.title}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<bool?> deletePost(Post post) async {
    final loc = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.listingHistory_deletePost),
        content: Text(loc.listingHistory_deletePostConfirm(post.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.profile_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
        await postRepo.deletePost(post.id!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.listingHistory_postDeleted),
            backgroundColor: AppTheme.successColor,
          ),
        );
        return true;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting post: $e'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
    return false;
  }

  Future<Post?> publishPost(Post post) async {
    final loc = AppLocalizations.of(context)!;
    
    try {
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      final updatedPost = post.copyWith(
        status: 'active',
        updatedAt: DateTime.now(),
      );
      
      await postRepo.updatePost(post.id!, updatedPost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.listingHistory_postPublished),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      return updatedPost;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating post: $e'),
          backgroundColor: AppTheme.failureColor,
        ),
      );
      return null;
    }
  }
}