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
  final int userId;

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
      helpText: 'Select availability period',
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
      final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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

      final TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 17, minute: 0),
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

      if (startTime != null && endTime != null) {
        final startDateTime = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
          startTime.hour,
          startTime.minute,
        );
        
        final endDateTime = DateTime(
          range.end.year,
          range.end.month,
          range.end.day,
          endTime.hour,
          endTime.minute,
        );

        if (endDateTime.isAfter(startDateTime)) {
          setState(() {
            _formController.availabilityIntervals.add(AvailabilityInterval(
              start: startDateTime,
              end: endDateTime,
            ));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End time must be after start time')),
          );
        }
      }
    }
  }
  
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields correctly')),
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
    
    return Scaffold(
      appBar: App_Bar(context, 'Complete Listing'),
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
                child: const Text(
                  'Review and Submit',
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