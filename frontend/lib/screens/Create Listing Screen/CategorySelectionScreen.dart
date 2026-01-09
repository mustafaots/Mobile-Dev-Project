import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/StayDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/VehicleDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class CategorySelectionScreen extends StatefulWidget {
  final dynamic userId;

  const CategorySelectionScreen({super.key, required this.userId});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final cardColor = context.cardColor;

    final List<Map<String, dynamic>> listingTypes = [
      {
        'type': 'stay',
        'display': t.listingType_stay,
        'icon': Icons.house_outlined,
        'color': AppTheme.primaryColor,
        'description': t.stayCategory_description,
      },
      {
        'type': 'activity',
        'display': t.listingType_activity,
        'icon': Icons.hiking_outlined,
        'color': AppTheme.successColor,
        'description': t.activityCategory_description,
      },
      {
        'type': 'vehicle',
        'display': t.listingType_vehicle,
        'icon': Icons.directions_car_outlined,
        'color': AppTheme.neutralColor,
        'description': t.vehicleCategory_description,
      },
    ];

    return Scaffold(
      appBar: App_Bar(context, t.appBar_createListing),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.choose_listing_category,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.select_type_of_listing,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Category Cards
            Column(
              children: listingTypes.map((type) {
                final isSelected = _selectedCategory == type['type'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = type['type']);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (type['color'] as Color).withOpacity(0.1)
                          : cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? type['color'] as Color
                            : textColor.withOpacity(0.1),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: (type['color'] as Color).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            type['icon'] as IconData,
                            color: type['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type['display'] as String,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type['description'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: type['color'] as Color,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedCategory != null
                      ? AppTheme.primaryColor
                      : AppTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _selectedCategory != null ? () {
                  switch (_selectedCategory) {
                    case 'stay':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StayDetailsScreen(userId: widget.userId),
                        ),
                      );
                      break;
                    case 'activity':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityDetailsScreen(userId: widget.userId),
                        ),
                      );
                      break;
                    case 'vehicle':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleDetailsScreen(userId: widget.userId),
                        ),
                      );
                      break;
                  }
                } : null,
                child: Text(
                  t.categorySelection_continue,
                  style: const TextStyle(
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