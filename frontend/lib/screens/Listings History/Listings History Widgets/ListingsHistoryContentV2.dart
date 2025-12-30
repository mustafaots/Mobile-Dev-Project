import 'package:easy_vacation/services/api/listing_service.dart';

import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/LoadingState.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/ListingCard.dart';
import 'package:flutter/material.dart';

class ListingsHistoryContentV2 extends StatelessWidget {
  final List<Listing> listings;
  final bool isLoading;
  final String currentFilter;
  final Function(Listing) onListingRemoved;
  final Function(Listing) onListingUpdated;

  const ListingsHistoryContentV2({
    super.key,
    required this.listings,
    required this.isLoading,
    required this.currentFilter,
    required this.onListingRemoved,
    required this.onListingUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingState();
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final filteredListings = currentFilter == 'all'
        ? listings
        : listings.where((l) => l.status == currentFilter).toList();

    if (filteredListings.isEmpty) {
      return EmptyStateV2(
        listings: listings,
        currentFilter: currentFilter,
      );
    }
    
    return _buildListingsList(filteredListings, context);
  }

  Widget _buildListingsList(List<Listing> listings, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: listings.length,
      itemBuilder: (context, index) => ListingCard(
        listing: listings[index],
        onListingRemoved: onListingRemoved,
        onListingUpdated: onListingUpdated,
      ),
    );
  }
}

class EmptyStateV2 extends StatelessWidget {
  final List<Listing> listings;
  final String currentFilter;

  const EmptyStateV2({
    super.key,
    required this.listings,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    final message = listings.isEmpty
        ? 'You have no listings yet'
        : 'No listings match the "$currentFilter" filter';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
