import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/ConfirmListingScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/AvailabilitySection.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/CommonHeader.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/LocationSection.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/PhotosSection.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonFormLogic.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/MapLocationPicker.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';



class CommonDetailsScreen extends StatefulWidget {
  final CreatePostData postData;
  final dynamic userId;

  const CommonDetailsScreen({required this.userId, required this.postData, super.key});

  @override
  State<CommonDetailsScreen> createState() => _CommonDetailsScreenState();
}

class _CommonDetailsScreenState extends State<CommonDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final CommonFormController _formController = CommonFormController();
  
  @override
  void initState() {
    super.initState();
    _formController.loadExistingData(widget.postData);
  }
  
  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }
  
  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          initialLatitude: _formController.selectedLatitude,
          initialLongitude: _formController.selectedLongitude,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _formController.selectedLatitude = result['latitude'];
        _formController.selectedLongitude = result['longitude'];
      });
    }
  }
  
  Future<void> _addAvailabilityInterval() async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: AppLocalizations.of(context)!.datepicker_help,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor,
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      // Normalize dates to midnight (remove time component)
      final startDate = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );
      
      final endDate = DateTime(
        range.end.year,
        range.end.month,
        range.end.day,
      );

      setState(() {
        _formController.availabilityIntervals.add(AvailabilityInterval(
          start: startDate,
          end: endDate,
        ));
      });
    }
  }
  
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.form_error_fill_all)),
      );
      return;
    }

    final updatedPostData = _formController.updatePostData(widget.postData);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmListingScreen(userId: widget.userId, postData: updatedPostData),
      ),
    );
  }
  
  Color get _categoryColor {
    switch (widget.postData.category) {
      case 'stay':
        return AppTheme.primaryColor;
      case 'activity':
        return AppTheme.successColor;
      case 'vehicle':
        return AppTheme.neutralColor;
      default:
        return AppTheme.primaryColor;
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
      appBar: App_Bar(context, loc.appbar_complete_listing),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget
            CommonHeader(
              postData: widget.postData,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            
            const SizedBox(height: 32),
            
            // Photos Section
            PhotosSection(
              formController: _formController,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              categoryColor: _categoryColor,
              onUpdate: () => setState(() {}),
            ),
            
            const SizedBox(height: 24),
            
            // Location Section
            LocationSection(
              formController: _formController,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              categoryColor: _categoryColor,
              onSelectLocation: _selectLocationOnMap,
              formKey: _formKey,
            ),
            
            const SizedBox(height: 24),
            
            // Availability Section
            AvailabilitySection(
              formController: _formController,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
              categoryColor: _categoryColor,
              onAddAvailability: _addAvailabilityInterval,
              onUpdate: () => setState(() {}),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _formController.validateForm()
                      ? _categoryColor
                      : _categoryColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _formController.validateForm() ? _submitForm : null,
                child: Text(
                  loc.submit_button,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}