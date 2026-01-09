import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/sync/listing_sync_service.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/repositories/db_repositories/sharedprefs_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/ListingsHistoryContentV2.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class ListingsHistory extends StatefulWidget {
  const ListingsHistory({super.key});

  @override
  State<ListingsHistory> createState() => _ListingsHistoryState();
}

class _ListingsHistoryState extends State<ListingsHistory> {
  List<Listing> _userListings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserListings();
  }

  Future<void> _loadUserListings() async {
    try {
      final currentUserId = await _getCurrentUserId();
      
      if (currentUserId == null || currentUserId.isEmpty) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
        return;
      }
      
      // Try to fetch from remote API first (includes Cloudinary images)
      if (await ConnectivityService.instance.checkConnectivity()) {
        try {
          final syncService = await ListingSyncService.getInstance();
          final listings = await syncService.getMyListings(forceRefresh: true);
          
          setState(() {
            _userListings = listings;
            _isLoading = false;
          });
          return;
        } catch (e) {
          print('⚠️ Error fetching from API: $e');
        }
      }
      
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      final posts = await postRepo.getPostsByOwner(currentUserId);
      
      // Convert Posts to Listings (simplified - local posts won't have full details)
      final listings = posts.map((post) => Listing(
        id: post.id,
        ownerId: post.ownerId,
        category: post.category,
        title: post.title,
        description: post.description,
        price: post.price,
        status: post.status,
        location: Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
        images: [], // Local posts don't have Cloudinary URLs
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      )).toList();
      
      setState(() {
        _userListings = listings;
        _isLoading = false;
      });
      
    } catch (e) {
      print('❌ Error loading listings: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading your listings: $e')),
        );
      }
    }
  }

  Future<String?> _getCurrentUserId() async {
    final sharedPrefsRepo = SharedPrefsRepository.getInstance();
    return sharedPrefsRepo.getUserId();
  }

  void _handleListingRemoved(Listing listing) {
    setState(() => _userListings.removeWhere((l) => l.id == listing.id));
  }

  void _handleListingUpdated(Listing updatedListing) {
    setState(() {
      final index = _userListings.indexWhere((l) => l.id == updatedListing.id);
      if (index != -1) _userListings[index] = updatedListing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.listingHistory_title),
      body: ListingsHistoryContentV2(
        listings: _userListings,
        isLoading: _isLoading,
        currentFilter: 'all',
        onListingRemoved: _handleListingRemoved,
        onListingUpdated: _handleListingUpdated,
      ),
    );
  }
}