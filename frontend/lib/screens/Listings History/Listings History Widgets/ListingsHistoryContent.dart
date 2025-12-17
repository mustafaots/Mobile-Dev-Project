
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/EmptyState.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/LoadingState.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostCard.dart';
import 'package:flutter/material.dart';

class ListingsHistoryContent extends StatelessWidget {
  final List<Post> posts;
  final bool isLoading;
  final String currentFilter;
  final Function(Post) onPostRemoved;
  final Function(Post) onPostUpdated;

  const ListingsHistoryContent({
    super.key,
    required this.posts,
    required this.isLoading,
    required this.currentFilter,
    required this.onPostRemoved,
    required this.onPostUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingState();
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final filteredPosts = currentFilter == 'all'
        ? posts
        : posts.where((post) => post.status == currentFilter).toList();

    if (filteredPosts.isEmpty) {
      return EmptyState(
        posts: posts,
        currentFilter: currentFilter,
      );
    }
    
    return _buildPostsList(filteredPosts, context);
  }

  Widget _buildPostsList(List<Post> posts, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) => PostCard(
        post: posts[index],
        onPostRemoved: onPostRemoved,
        onPostUpdated: onPostUpdated,
      ),
    );
  }
}