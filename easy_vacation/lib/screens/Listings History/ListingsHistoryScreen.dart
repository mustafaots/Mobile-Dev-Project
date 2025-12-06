import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/ListingsHistoryContent.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/ListingsHistoryFilter.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class ListingsHistory extends StatefulWidget {
  const ListingsHistory({super.key});

  @override
  State<ListingsHistory> createState() => _ListingsHistoryState();
}

class _ListingsHistoryState extends State<ListingsHistory> {
  List<Post> _userPosts = [];
  bool _isLoading = true;
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    try {
      final currentUserId = await _getCurrentUserId();
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      final posts = await postRepo.getPostsByOwner(currentUserId);
      
      setState(() {
        _userPosts = posts;
        _isLoading = false;
      });
      
    } catch (e) {
      print('❌ Error loading posts: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading your listings: $e')),
        );
      }
    }
  }

  Future<int> _getCurrentUserId() async {
    // TODO: Implement actual user authentication
    return 1; // Placeholder
  }

  void _handleFilterChange(String filter) {
    setState(() => _currentFilter = filter);
  }

  void _handlePostRemoved(Post post) {
    setState(() => _userPosts.removeWhere((p) => p.id == post.id));
  }

  void _handlePostUpdated(Post updatedPost) {
    setState(() {
      final index = _userPosts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) _userPosts[index] = updatedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.listingHistory_title),
      body: SafeArea(
        child: Column(
          children: [
            if (_userPosts.isNotEmpty)
              ListingsHistoryFilter(
                currentFilter: _currentFilter,
                onFilterChanged: _handleFilterChange,
              ),
            Expanded(
              child: ListingsHistoryContent(
                posts: _userPosts,
                isLoading: _isLoading,
                currentFilter: _currentFilter,
                onPostRemoved: _handlePostRemoved,
                onPostUpdated: _handlePostUpdated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}