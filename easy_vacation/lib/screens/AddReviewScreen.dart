// addReviewPage.dart
import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _quickReactions = [
    '😠 Terrible',
    '😕 Poor', 
    '😐 Average',
    '😊 Good',
    '🤩 Excellent',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating > 0 && _reviewController.text.trim().isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Review Submitted!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
          content: Text(
            'Thank you for your feedback!',
            style: TextStyle(color: context.secondaryTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
              child: Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, 'Add Review'),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _rating > 0 && _reviewController.text.isNotEmpty 
                  ? 1.0 
                  : (_rating > 0 || _reviewController.text.isNotEmpty ? 0.5 : 0.0),
              backgroundColor: secondaryTextColor.withOpacity(0.2),
              color: AppTheme.primaryColor,
              minHeight: 3,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'How was your stay?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your experience to help others',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Star Rating
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Overall Rating',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              bool isSelected = index < _rating;
                              return GestureDetector(
                                onTap: () => setState(() => _rating = index + 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    isSelected ? Icons.star : Icons.star_border,
                                    color: isSelected ? AppTheme.neutralColor : secondaryTextColor,
                                    size: 36,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _rating == 0 ? 'Tap to rate' : '$_rating/5 Stars',
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Quick Reactions
                    Text(
                      'Quick Reaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _quickReactions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final reaction = entry.value;
                        final isSelected = _rating == index + 1;
                        
                        return ChoiceChip(
                          label: Text(reaction),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _rating = selected ? index + 1 : 0);
                          },
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                          backgroundColor: cardColor,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryColor : secondaryTextColor.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // Review Text
                    Text(
                      'Your Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: secondaryTextColor.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Tell us about your experience...',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: TextStyle(color: textColor),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_reviewController.text.length}/300 characters',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                      textAlign: TextAlign.right,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  top: BorderSide(
                    color: secondaryTextColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: _rating > 0 && _reviewController.text.trim().isNotEmpty 
                    ? _submitReview 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rating > 0 && _reviewController.text.trim().isNotEmpty
                      ? AppTheme.primaryColor
                      : secondaryTextColor.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}