import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/api/search_service.dart';
import 'package:flutter/foundation.dart';

/// State class to track pagination
class PaginationState {
  final List<Listing> listings;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final int currentPage;

  const PaginationState({
    this.listings = const [],
    this.hasMore = true,
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
  });

  PaginationState copyWith({
    List<Listing>? listings,
    bool? hasMore,
    bool? isLoading,
    String? error,
    int? currentPage,
  }) {
    return PaginationState(
      listings: listings ?? this.listings,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Algorithm for paginated listing fetching
/// Loads listings in batches of 5, fetching more when user scrolls to the end
class PaginatedListingsAlgorithm extends ChangeNotifier {
  final String category;
  final int pageSize;
  
  PaginationState _state = const PaginationState();
  PaginationState get state => _state;
  
  // Convenience getters
  List<Listing> get listings => _state.listings;
  bool get hasMore => _state.hasMore;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  int get currentPage => _state.currentPage;
  bool get isEmpty => _state.listings.isEmpty && !_state.isLoading;

  SearchService get _searchService => SearchService.instance;

  PaginatedListingsAlgorithm({
    required this.category,
    this.pageSize = 5,
  });

  /// Loads the initial batch of listings
  /// Call this when the screen first loads
  Future<void> loadInitial() async {
    if (_state.isLoading) return;

    print('📄 loadInitial starting...');
    _state = const PaginationState(isLoading: true);
    notifyListeners();

    try {
      final response = await _searchService.search(
        category: category,
        limit: pageSize,
        offset: 0,
      );

      print('📄 loadInitial response: success=${response.isSuccess}, items=${response.data?.items.length}, total=${response.data?.total}');

      if (response.isSuccess && response.data != null) {
        final items = response.data!.items;
        final total = response.data!.total;
        
        print('📄 loadInitial: got ${items.length} items, total=$total, hasMore=${items.length < total}');
        
        _state = PaginationState(
          listings: items,
          hasMore: items.length < total,
          isLoading: false,
          currentPage: 1,
        );
      } else {
        _state = PaginationState(
          isLoading: false,
          error: response.message ?? 'Failed to load listings',
        );
      }
    } catch (e) {
      _state = PaginationState(
        isLoading: false,
        error: e.toString(),
      );
    }

    notifyListeners();
  }

  /// Loads the next batch of listings
  /// Call this when user scrolls near the end of the list
  Future<void> loadMore() async {
    // Don't load if already loading or no more items
    if (_state.isLoading || !_state.hasMore) {
      print('📄 loadMore skipped: isLoading=${_state.isLoading}, hasMore=${_state.hasMore}');
      return;
    }

    print('📄 loadMore starting... offset=${_state.listings.length}');
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final offset = _state.listings.length;
      
      final response = await _searchService.search(
        category: category,
        limit: pageSize,
        offset: offset,
      );

      print('📄 loadMore response: success=${response.isSuccess}, items=${response.data?.items.length}, total=${response.data?.total}');

      if (response.isSuccess && response.data != null) {
        final newItems = response.data!.items;
        final total = response.data!.total;
        
        // Filter out duplicates by ID
        final existingIds = _state.listings.map((l) => l.id).toSet();
        final uniqueNewItems = newItems.where((l) => !existingIds.contains(l.id)).toList();
        
        final allItems = [..._state.listings, ...uniqueNewItems];
        
        print('📄 loadMore: added ${uniqueNewItems.length} unique items, total now ${allItems.length}/$total, hasMore=${allItems.length < total}');
        
        _state = _state.copyWith(
          listings: allItems,
          hasMore: allItems.length < total,
          isLoading: false,
          currentPage: _state.currentPage + 1,
        );
      } else {
        _state = _state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to load more listings',
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }

    notifyListeners();
  }

  /// Refreshes the listings from the beginning
  /// Call this for pull-to-refresh functionality
  Future<void> refresh() async {
    _state = const PaginationState();
    notifyListeners();
    await loadInitial();
  }

  /// Resets the algorithm state
  void reset() {
    _state = const PaginationState();
    notifyListeners();
  }

  /// Check if we should load more (call this in scroll listener)
  /// Returns true if we're near the end and should load more
  bool shouldLoadMore(int currentIndex) {
    // Load more when we're 2 items away from the end
    return currentIndex >= _state.listings.length - 2 && 
           _state.hasMore && 
           !_state.isLoading;
  }
}

/// Factory to create PaginatedListingsAlgorithm instances
class PaginatedListingsFactory {
  static final Map<String, PaginatedListingsAlgorithm> _instances = {};

  /// Gets or creates a PaginatedListingsAlgorithm for the given category
  static PaginatedListingsAlgorithm getForCategory(String category, {int pageSize = 5}) {
    if (!_instances.containsKey(category)) {
      _instances[category] = PaginatedListingsAlgorithm(
        category: category,
        pageSize: pageSize,
      );
    }
    return _instances[category]!;
  }

  /// Clears all instances (useful for logout/cleanup)
  static void clearAll() {
    for (final instance in _instances.values) {
      instance.dispose();
    }
    _instances.clear();
  }

  /// Clears instance for a specific category
  static void clear(String category) {
    _instances[category]?.dispose();
    _instances.remove(category);
  }
}
