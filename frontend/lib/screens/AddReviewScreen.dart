// addReviewPage.dart
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Home%20Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/logic/cubit/add_review_cubit.dart';
import 'package:easy_vacation/logic/cubit/add_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReviewScreen extends StatefulWidget {
  final int postId;
  final dynamic reviewerId;
  final AddReviewCubit addReviewCubit;
  final int? reviewID;
  final String? comment;
  final double? rating;

  const AddReviewScreen({
    Key? key,
    required this.postId,
    required this.reviewerId,
    required this.addReviewCubit,
    this.reviewID,
    this.comment,
    this.rating
  }) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  bool _isDeleting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    if (_rating > 0 && _reviewController.text.trim().isNotEmpty) {
      if(widget.reviewID == null) {
        // Submit review using Cubit
        context.read<AddReviewCubit>().submitReview(
          postId: widget.postId,
          reviewerId: widget.reviewerId.toString(),
          rating: _rating,
          comment: _reviewController.text.trim(),
        );
      } else {
        context.read<AddReviewCubit>().updateReview(
          reviewId: widget.reviewID!,
          comment: _reviewController.text.trim(),
          rating: _rating,
        );
      }
    }
  }

  void _deleteReview(BuildContext context) {
    setState(() {
      _isDeleting = true;
    });
    context.read<AddReviewCubit>().deleteReview(
      reviewId: widget.reviewID!,
    );
  }

  void _showSuccessDialog(BuildContext context, AppLocalizations loc) {
    final String title;
    final String message;

    if (_isDeleting) {
      title = loc.reviewDeletedTitle;
      message = loc.reviewDeletedMessage;
    } else if (widget.reviewID != null) {
      title = loc.addReview_updated;
      message = loc.addReview_thankYouFeedback;
    } else {
      title = loc.addReview_submitted;
      message = loc.addReview_thankYouFeedback;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: context.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isDeleting = false; // reset flag
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      HomeScreen(userId: widget.reviewerId),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            child: Text(
              loc.addReview_ok,
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(
    BuildContext context,
    String errorMessage,
    AppLocalizations loc,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Error',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          errorMessage,
          style: TextStyle(color: context.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              loc.addReview_ok,
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.reviewID != null) {
      _reviewController.text = widget.comment ?? '';
      _rating =  widget.rating!.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    final List<String> _quickReactions = [
      '😠 ${loc.addReview_terrible}',
      '😕 ${loc.addReview_poor}',
      '😐 ${loc.addReview_average}',
      '😊 ${loc.addReview_good}',
      '🤩 ${loc.addReview_excellent}',
    ];

    return BlocProvider.value(
      value: widget.addReviewCubit,
      child: BlocListener<AddReviewCubit, AddReviewState>(
        listener: (context, state) {
          if (state is AddReviewSuccess) {
            _isDeleting = false;
            _showSuccessDialog(context, loc);

          } else if (state is DeleteReviewSuccess) {
            _isDeleting = true;
            _showSuccessDialog(context, loc);

          } else if (state is AddReviewFailure) {
            _isDeleting = false;
            _showErrorDialog(context, state.message, loc);

          } else if (state is AddReviewValidationError) {
            _isDeleting = false;
            _showErrorDialog(context, state.error, loc);
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: App_Bar(context, (widget.reviewID != null) ? loc.updateReview_title: loc.addReview_title),
          body: SafeArea(
            child: Column(
              children: [
                // Progress indicator
                BlocBuilder<AddReviewCubit, AddReviewState>(
                  builder: (context, state) {
                    final isLoading = state is AddReviewLoading;
                    return LinearProgressIndicator(
                      value: _rating > 0 && _reviewController.text.isNotEmpty
                          ? 1.0
                          : (_rating > 0 || _reviewController.text.isNotEmpty
                                ? 0.5
                                : 0.0),
                      backgroundColor: secondaryTextColor.withOpacity(0.2),
                      color: isLoading ? Colors.grey : AppTheme.primaryColor,
                      minHeight: 3,
                    );
                  },
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          loc.addReview_howWasStay,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.addReview_shareExperience,
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
                                loc.addReview_overallRating,
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
                                    onTap: () =>
                                        setState(() => _rating = index + 1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        isSelected
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: isSelected
                                            ? AppTheme.neutralColor
                                            : secondaryTextColor,
                                        size: 36,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _rating == 0
                                    ? loc.addReview_tapToRate
                                    : loc.addReview_stars(_rating),
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
                          loc.addReview_quickReaction,
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
                          children: _quickReactions.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final reaction = entry.value;
                            final isSelected = _rating == index + 1;

                            return ChoiceChip(
                              label: Text(reaction),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(
                                  () => _rating = selected ? index + 1 : 0,
                                );
                              },
                              selectedColor: AppTheme.primaryColor.withOpacity(
                                0.2,
                              ),
                              backgroundColor: cardColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : textColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : secondaryTextColor.withOpacity(0.3),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        // Review Text
                        Text(
                          loc.addReview_yourReview,
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
                              hintText: loc.addReview_tellUsExperience,
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
                          loc.addReview_charactersCount(
                            _reviewController.text.length,
                          ),
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
                BlocBuilder<AddReviewCubit, AddReviewState>(
                  builder: (context, state) {
                    final isLoading = state is AddReviewLoading;

                    return Container(
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
                      child: Row(
                        children: [
                          // SUBMIT BUTTON
                          Expanded(
                            flex: 7,
                            child: ElevatedButton(
                              onPressed: isLoading ||
                                      (_rating == 0 ||
                                          _reviewController.text.trim().isEmpty)
                                  ? null
                                  : () => _submitReview(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLoading ||
                                        (_rating == 0 ||
                                            _reviewController.text.trim().isEmpty)
                                    ? secondaryTextColor.withOpacity(0.3)
                                    : AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: (isLoading && !_isDeleting)
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    loc.addReview_submitReview,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),

                        if (widget.reviewID != null) const SizedBox(width: 12),

                          // DELETE BUTTON
                          if (widget.reviewID != null)
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _deleteReview(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: (isLoading && _isDeleting)
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      loc.delete,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
