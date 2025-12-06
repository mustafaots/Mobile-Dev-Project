

import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final List<Post> posts;
  final String currentFilter;

  const EmptyState({
    super.key,
    required this.posts,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 80, color: secondaryTextColor.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              posts.isEmpty ? 'You have no listings' : _getFilteredEmptyText(currentFilter),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryTextColor),
            ),
            const SizedBox(height: 12),
            Text(
              posts.isEmpty
                  ? 'Create your first listing'
                  : _getFilteredEmptyDescription(currentFilter),
              style: TextStyle(fontSize: 16, color: secondaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getFilteredEmptyText(String filter) {
    switch (filter) {
      case 'active': return 'No active listings';
      case 'draft': return 'No draft listings';
      default: return 'No listings';
    }
  }

  String _getFilteredEmptyDescription(String filter) {
    switch (filter) {
      case 'active': return 'You have no active listings';
      case 'draft': return 'You have no draft listings';
      default: return 'No listings found';
    }
  }
}