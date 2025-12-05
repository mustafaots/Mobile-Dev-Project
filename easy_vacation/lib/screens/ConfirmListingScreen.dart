// ConfirmListingScreen.dart
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/locations.model.dart' as loc_model;
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ConfirmAndPostScreen extends StatefulWidget {
  final CreatePostData postData;

  const ConfirmAndPostScreen({required this.postData, super.key});

  @override
  State<ConfirmAndPostScreen> createState() => _ConfirmAndPostScreenState();
}

class _ConfirmAndPostScreenState extends State<ConfirmAndPostScreen> {
  bool agreedCheck = false;
  bool _isCreating = false;

  // FIXED: Complete implementation of post creation
  Future<bool> _createPostInDatabase() async {
    if (_isCreating) return false;
    
    setState(() => _isCreating = true);
    
    try {
      print('🚀 Starting post creation...');
      
      // Get repository
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      
      // TODO: Replace with actual logged-in user ID from your auth system
      int userId = 1; // PLACEHOLDER - implement proper auth
      
      print('📝 Creating post for user: $userId');
      print('📝 Category: ${widget.postData.category}');
      
      // Create Post object
      final post = Post(
        ownerId: userId,
        category: widget.postData.category,
        title: widget.postData.title,
        description: widget.postData.description,
        price: widget.postData.price,
        locationId: 0, // Will be set by repository
        status: 'active',
        isPaid: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        availability: widget.postData.availability
            .map((interval) => interval.toMap())
            .toList(),
      );
      
      print('📍 Creating location...');
      // Convert from details.Location to loc_model.Location
      final location = loc_model.Location.fromDetailsLocation(widget.postData.location);
      
      print('🖼️ Processing images: ${widget.postData.imagePaths.length}');
      
      // Create category-specific object
      Stay? stay;
      Activity? activity;
      Vehicle? vehicle;
      
      switch (widget.postData.category.toLowerCase()) {
        case 'stay':
          if (widget.postData.stayDetails != null) {
            print('🏠 Creating stay details...');
            stay = Stay(
              postId: 0, // Will be set by repository
              stayType: widget.postData.stayDetails!.stayType,
              area: widget.postData.stayDetails!.area,
              bedrooms: widget.postData.stayDetails!.bedrooms,
            );
          }
          break;
        case 'activity':
          if (widget.postData.activityDetails != null) {
            print('🎯 Creating activity details...');
            activity = Activity(
              postId: 0, // Will be set by repository
              activityType: widget.postData.activityDetails!.activityType,
              requirements: widget.postData.activityDetails!.requirements,
            );
          }
          break;
        case 'vehicle':
          if (widget.postData.vehicleDetails != null) {
            print('🚗 Creating vehicle details...');
            vehicle = Vehicle(
              postId: 0, // Will be set by repository
              vehicleType: widget.postData.vehicleDetails!.vehicleType,
              model: widget.postData.vehicleDetails!.model,
              year: widget.postData.vehicleDetails!.year,
              fuelType: widget.postData.vehicleDetails!.fuelType,
              transmission: widget.postData.vehicleDetails!.transmission,
              seats: widget.postData.vehicleDetails!.seats,
              features: widget.postData.vehicleDetails!.features,
            );
          }
          break;
      }
      
      print('💾 Inserting into database...');
      // Insert into database
      final postId = await postRepo.createCompletePost(
        post: post,
        location: location,
        imagePaths: widget.postData.imagePaths,
        stay: stay,
        activity: activity,
        vehicle: vehicle,
      );
      
      print('✅ Post created successfully with ID: $postId');
      return true;
      
    } catch (e, stackTrace) {
      print('❌ Error creating post: $e');
      print('❌ Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating listing: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  void _postListing() async {
    if (!agreedCheck || _isCreating) return;

    // Create the post in database
    bool success = await _createPostInDatabase();
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmListing_listingPosted),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      
      // Clear ALL routes and go to HomeScreen
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false, // Clear entire stack
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.confirmListing_title),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: agreedCheck ? 1.0 : 0.5,
            backgroundColor: secondaryTextColor.withOpacity(0.2),
            color: AppTheme.primaryColor,
            minHeight: 3,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    loc.confirmListing_readyToPost,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.confirmListing_reviewDetails,
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Pricing Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: secondaryTextColor.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                loc.confirmListing_pricingSummary,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          _buildPricingRow(loc.confirmListing_basePrice, "${widget.postData.price} DA", context),
                          _buildPricingRow(loc.confirmListing_serviceFee, "0 DA", context),
                          
                          const SizedBox(height: 12),
                          Divider(color: secondaryTextColor.withOpacity(0.3)),
                          const SizedBox(height: 12),
                          
                          _buildPricingRow(
                            loc.confirmListing_totalAmount,
                            "${widget.postData.price} DA",
                            context,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Agreement Checkbox
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: secondaryTextColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => agreedCheck = !agreedCheck),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: agreedCheck ? AppTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: agreedCheck ? AppTheme.primaryColor : secondaryTextColor.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: agreedCheck
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => agreedCheck = !agreedCheck);
                            },
                            child: Text(
                              loc.confirmListing_agreement,
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  color: secondaryTextColor.withOpacity(0.1),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: (agreedCheck && !_isCreating) ? _postListing : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (agreedCheck && !_isCreating) 
                    ? AppTheme.primaryColor 
                    : secondaryTextColor.withOpacity(0.3),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: AppTheme.primaryColor.withOpacity(0.3),
              ),
              child: _isCreating
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.confirmListing_postListing,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(String label, String value, BuildContext context, {bool isTotal = false}) {
    final textColor = context.textColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : textColor,
            ),
          ),
        ],
      ),
    );
  }
}