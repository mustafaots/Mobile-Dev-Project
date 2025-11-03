// addReviewPage.dart
import 'package:easy_vacation/classes/DAN/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math';
import 'package:easy_vacation/classes/AYM/ProfilePage.dart';
import 'package:easy_vacation/classes/AYM/notification_tourist.dart';
import 'package:easy_vacation/classes/MAS/my_bookings.dart';
import 'package:easy_vacation/classes/MUS/CreateListingScreen.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int _rating = 0;
  int _cleanlinessRating = 0;
  int _serviceRating = 0;
  int _locationRating = 0;
  int _valueRating = 0;
  String _selectedEmoji = '';
  final TextEditingController _reviewController = TextEditingController();
  final ConfettiController _confettiController = ConfettiController(duration: Duration(seconds: 2));
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  bool _showPreview = false;
  bool _showCategories = false;
  int _navIdx = 0;

  List staticNavigation = [
    const HomeScreen(),
    const MyBookingsScreen(),
    '',
    const NotificationsPage(),
    const ProfilePage()
  ];

  // Emoji reactions data
  final List<Map<String, dynamic>> _emojiReactions = [
    {'emoji': '😠', 'label': 'Terrible', 'value': 1},
    {'emoji': '😕', 'label': 'Poor', 'value': 2},
    {'emoji': '😐', 'label': 'Average', 'value': 3},
    {'emoji': '😊', 'label': 'Good', 'value': 4},
    {'emoji': '🤩', 'label': 'Excellent', 'value': 5},
  ];

  // Review suggestions
  final List<String> _suggestions = [
    'Great service!',
    'Very clean and tidy',
    'Amazing location',
    'Good value for money',
    'Comfortable stay',
    'Would recommend',
  ];

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _logReviewSubmission(int rating, String review) {
    assert(() {
      print('Review Submission - Rating: $rating stars, Review: $review');
      return true;
    }());
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

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _reviewController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  void _submitReview() {
    if (_canSubmit()) {
      _confettiController.play();
      _logReviewSubmission(_rating, _reviewController.text);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Review Submitted!', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
          content: Text('Thank you for your feedback!', style: GoogleFonts.plusJakartaSans()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK', style: GoogleFonts.plusJakartaSans()),
            ),
          ],
        ),
      );
    }
  }

  List<Color> _getBackgroundColors() {
    if (_rating == 0) return [Color(0xFFF2F2F7), Color(0xFFF2F2F7)];
    switch (_rating) {
      case 1: return [Color(0xFFFFE5E5), Color(0xFFFFF5F5)];
      case 2: return [Color(0xFFFFF0E5), Color(0xFFFFF9F5)];
      case 3: return [Color(0xFFFFFFE5), Color(0xFFFFFFF5)];
      case 4: return [Color(0xFFF0FFE5), Color(0xFFF9FFF5)];
      case 5: return [Color(0xFFE5FFEE), Color(0xFFF5FFFA)];
      default: return [Color(0xFFF2F2F7), Color(0xFFF2F2F7)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
      appBar: AppBar(
        title: Text(
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
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Animated background gradient
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getBackgroundColors(),
                ),
              ),
            ),

            // Confetti
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),

            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Rating Title
                        Text(
                          'Rate Your Experience',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),

                        // Animated Stars
                        Row(
                          key: const Key('star_rating_row'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            bool isSelected = index < _rating;
                            return AnimatedContainer(
                              key: Key('star_$index'),
                              duration: Duration(milliseconds: 200),
                              transform: isSelected ? 
                                (Matrix4.identity()..scale(1.2)) : Matrix4.identity(),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = index + 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    isSelected ? Icons.star : Icons.star_border,
                                    color: isSelected ? Color(0xFFF5A623) : Color(0xFF8E8E93),
                                    size: 42,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_rating/5 Stars',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Color(0xFF8E8E93),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Emoji Reactions
                        Column(
                          key: const Key('emoji_reactions'),
                          children: [
                            Text(
                              'How was your experience?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D1D1F).withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _emojiReactions.map((reaction) {
                                return GestureDetector(
                                  key: Key('emoji_${reaction['value']}'),
                                  onTap: () {
                                    setState(() {
                                      _selectedEmoji = reaction['emoji'];
                                      _rating = reaction['value'];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _selectedEmoji == reaction['emoji'] ? 
                                            Color(0xFF4A90E2).withOpacity(0.1) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          reaction['emoji'],
                                          style: TextStyle(fontSize: 28),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        reaction['label'],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Color(0xFF1D1D1F),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Category Ratings Toggle
                        Row(
                          key: const Key('category_toggle_row'),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detailed Ratings',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            Switch(
                              key: const Key('category_toggle_switch'),
                              value: _showCategories,
                              onChanged: (value) => setState(() => _showCategories = value),
                              activeColor: Color(0xFF4A90E2),
                            ),
                          ],
                        ),

                        if (_showCategories) ...[
                          SizedBox(height: 16),
                          _buildCategoryRating('Cleanliness', _cleanlinessRating, (value) => _cleanlinessRating = value),
                          _buildCategoryRating('Service', _serviceRating, (value) => _serviceRating = value),
                          _buildCategoryRating('Location', _locationRating, (value) => _locationRating = value),
                          _buildCategoryRating('Value', _valueRating, (value) => _valueRating = value),
                          SizedBox(height: 16),
                        ],

                        // Share Your Thoughts Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Share Your Thoughts',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),

                        // Smart Suggestions
                        Wrap(
                          key: const Key('suggestions_wrap'),
                          spacing: 8,
                          runSpacing: 8,
                          children: _suggestions.map((suggestion) => InputChip(
                            key: Key('suggestion_${suggestion.hashCode}'),
                            label: Text(
                              suggestion,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            ),
                            onSelected: (_) {
                              setState(() {
                                if (_reviewController.text.isNotEmpty) {
                                  _reviewController.text += ' $suggestion';
                                } else {
                                  _reviewController.text = suggestion;
                                }
                              });
                            },
                            backgroundColor: Color(0xFF4A90E2).withOpacity(0.1),
                            labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                          )).toList(),
                        ),
                        SizedBox(height: 12),

                        // Text Field with Voice
                        Container(
                          key: const Key('review_text_field_container'),
                          constraints: BoxConstraints(maxWidth: 480),
                          child: TextField(
                            key: const Key('review_text_field'),
                            controller: _reviewController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: 'Tell us about your stay, what you liked, and what could be improved...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF8E8E93),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(0xFFCFE3E7),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(0xFF4A90E2),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(16),
                              suffixIcon: IconButton(
                                key: const Key('voice_button'),
                                icon: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none,
                                  color: _isListening ? Colors.red : Color(0xFF4A90E2),
                                ),
                                onPressed: _toggleListening,
                              ),
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                        ),

                        // Character Counter
                        Container(
                          key: const Key('character_counter'),
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            '${_reviewController.text.length}/300 characters',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.plusJakartaSans(
                              color: _reviewController.text.length > 300 ? 
                                Colors.red : Color(0xFF8E8E93),
                              fontSize: 12,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Review Preview Toggle
                        Row(
                          key: const Key('preview_toggle_row'),
                          children: [
                            Switch(
                              key: const Key('preview_toggle_switch'),
                              value: _showPreview,
                              onChanged: (value) => setState(() => _showPreview = value),
                              activeColor: Color(0xFF4A90E2),
                            ),
                            Text(
                              'Preview Review',
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF1D1D1F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        if (_showPreview) ...[
                          SizedBox(height: 16),
                          Card(
                            key: const Key('preview_card'),
                            margin: EdgeInsets.zero,
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Star rating preview
                                      Row(
                                        children: List.generate(5, (index) => Icon(
                                          index < _rating ? Icons.star : Icons.star_border,
                                          size: 16,
                                          color: Color(0xFFF5A623),
                                        )),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Now',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Color(0xFF8E8E93),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _reviewController.text.isEmpty ? 
                                      'Your review will appear here...' : _reviewController.text,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: Color(0xFF1D1D1F),
                                    ),
                                  ),
                                  if (_selectedEmoji.isNotEmpty) ...[
                                    SizedBox(height: 8),
                                    Text(
                                      'Mood: $_selectedEmoji',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: Color(0xFF8E8E93),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),

                // Smart Submit Button with Progress
                AnimatedContainer(
                  key: const Key('submit_section'),
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress indicator
                      LinearProgressIndicator(
                        key: const Key('progress_indicator'),
                        value: _getProgressValue(),
                        backgroundColor: Color(0xFFE5E5EA),
                        color: Color(0xFF4A90E2),
                        minHeight: 4,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        key: const Key('submit_button'),
                        onPressed: _canSubmit() ? _submitReview : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit() ? Color(0xFF4A90E2) : Color(0xFF8E8E93),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Submit Review',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
      key: Key('${category.toLowerCase()}_rating'),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: GoogleFonts.plusJakartaSans(
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
                  key: Key('${category.toLowerCase()}_star_$index'),
                  onTap: () => setState(() => onRatingChanged(index + 1)),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    transform: isSelected ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
                    child: Icon(
                      isSelected ? Icons.star : Icons.star_border,
                      size: 20,
                      color: isSelected ? Color(0xFFF5A623) : Color(0xFF8E8E93),
                    ),
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
      unselectedItemColor: Color(0xFF6B7280),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online_outlined),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: SizedBox.shrink(),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}