// addReviewPage.dart
import 'package:easy_vacation/classes/DAN/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/classes/AYM/ProfileScreen.dart';
import 'package:easy_vacation/classes/AYM/NotificationsScreen.dart';
import 'package:easy_vacation/classes/MAS/BookingsScreen.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _rating = 0;
  int _cleanlinessRating = 0;
  int _serviceRating = 0;
  int _locationRating = 0;
  int _valueRating = 0;
  String _selectedEmoji = '';
  final TextEditingController _reviewController = TextEditingController();
  bool _showPreview = false;
  bool _showCategories = false;
  int _navIdx = 0;

  List staticNavigation = [
    const HomeScreen(),
    const BookingsScreen(),
    '',
    const NotificationsScreen(),
    const ProfileScreen()
  ];

  final List<Map<String, dynamic>> _emojiReactions = [
    {'emoji': '😠', 'label': 'Terrible', 'value': 1},
    {'emoji': '😕', 'label': 'Poor', 'value': 2},
    {'emoji': '😐', 'label': 'Average', 'value': 3},
    {'emoji': '😊', 'label': 'Good', 'value': 4},
    {'emoji': '🤩', 'label': 'Excellent', 'value': 5},
  ];

  final List<String> _suggestions = [
    'Great service!',
    'Very clean and tidy',
    'Amazing location',
    'Good value for money',
    'Comfortable stay',
    'Would recommend',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    return _rating > 0 && _reviewController.text.trim().isNotEmpty;
  }

  double _getProgressValue() {
    double ratingProgress = _rating / 5 * 0.4;
    double reviewProgress = (_reviewController.text.length / 300).clamp(0.0, 0.4);
    double categoryProgress = (_showCategories ? (_cleanlinessRating + _serviceRating + _locationRating + _valueRating) / 20 * 0.2 : 0.0);
    return ratingProgress + reviewProgress + categoryProgress;
  }

  void _submitReview() {
    if (_canSubmit()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Review Submitted!', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Thank you for your feedback!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<Color> _getBackgroundColors() {
    if (_rating == 0) return [const Color(0xFFF2F2F7), const Color(0xFFF2F2F7)];
    switch (_rating) {
      case 1:
        return [const Color(0xFFFFE5E5), const Color(0xFFFFF5F5)];
      case 2:
        return [const Color(0xFFFFF0E5), const Color(0xFFFFF9F5)];
      case 3:
        return [const Color(0xFFFFFFE5), const Color(0xFFFFFFF5)];
      case 4:
        return [const Color(0xFFF0FFE5), const Color(0xFFF9FFF5)];
      case 5:
        return [const Color(0xFFE5FFEE), const Color(0xFFF5FFFA)];
      default:
        return [const Color(0xFFF2F2F7), const Color(0xFFF2F2F7)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Add a Review',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getBackgroundColors(),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Rate Your Experience',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Star rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            bool isSelected = index < _rating;
                            return GestureDetector(
                              onTap: () => setState(() => _rating = index + 1),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  isSelected ? Icons.star : Icons.star_border,
                                  color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF8E8E93),
                                  size: 40,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_rating/5 Stars',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8E8E93),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Emoji reaction
                        const Text(
                          'How was your experience?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _emojiReactions.map((reaction) {
                            return GestureDetector(
                              onTap: () => setState(() {
                                _selectedEmoji = reaction['emoji'];
                                _rating = reaction['value'];
                              }),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _selectedEmoji == reaction['emoji']
                                          ? const Color(0xFF4A90E2).withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(reaction['emoji'], style: const TextStyle(fontSize: 28)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reaction['label'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1D1D1F),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Category ratings
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Detailed Ratings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            Switch(
                              value: _showCategories,
                              onChanged: (value) => setState(() => _showCategories = value),
                              activeColor: const Color(0xFF4A90E2),
                            ),
                          ],
                        ),

                        if (_showCategories) ...[
                          const SizedBox(height: 16),
                          _buildCategoryRating('Cleanliness', _cleanlinessRating, (v) => _cleanlinessRating = v),
                          _buildCategoryRating('Service', _serviceRating, (v) => _serviceRating = v),
                          _buildCategoryRating('Location', _locationRating, (v) => _locationRating = v),
                          _buildCategoryRating('Value', _valueRating, (v) => _valueRating = v),
                        ],

                        const SizedBox(height: 24),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Share Your Thoughts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Suggestions
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestions.map((suggestion) {
                            return InputChip(
                              label: Text(suggestion, style: const TextStyle(fontSize: 12, color: Color(0xFF4A90E2))),
                              onSelected: (_) {
                                setState(() {
                                  if (_reviewController.text.isNotEmpty) {
                                    _reviewController.text += ' $suggestion';
                                  } else {
                                    _reviewController.text = suggestion;
                                  }
                                });
                              },
                              backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),

                        // Review text
                        TextField(
                          controller: _reviewController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Tell us about your stay...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFCFE3E7)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Preview toggle
                        Row(
                          children: [
                            Switch(
                              value: _showPreview,
                              onChanged: (value) => setState(() => _showPreview = value),
                              activeThumbColor: const Color(0xFF4A90E2),
                            ),
                            const Text(
                              'Preview Review',
                              style: TextStyle(
                                color: Color(0xFF1D1D1F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        if (_showPreview)
                          Card(
                            margin: EdgeInsets.zero,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < _rating ? Icons.star : Icons.star_border,
                                        size: 16,
                                        color: const Color(0xFFF5A623),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _reviewController.text.isEmpty
                                        ? 'Your review will appear here...'
                                        : _reviewController.text,
                                  ),
                                  if (_selectedEmoji.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text('Mood: $_selectedEmoji', style: const TextStyle(fontSize: 12)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Submit button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        value: _getProgressValue(),
                        backgroundColor: const Color(0xFFE5E5EA),
                        color: const Color(0xFF4A90E2),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _canSubmit() ? _submitReview : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit() ? const Color(0xFF4A90E2) : const Color(0xFF8E8E93),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Submit Review',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoryRating(String category, int rating, Function(int) onRatingChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1F),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                bool isSelected = index < rating;
                return GestureDetector(
                  onTap: () => setState(() => onRatingChanged(index + 1)),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 20,
                    color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF8E8E93),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: const Color(0xFF6B7280),
      currentIndex: _navIdx,
      onTap: (index) {
        if (index != 2) {
          setState(() {
            _navIdx = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => staticNavigation[index]),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: 'Bookings'),
        BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notifications'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
