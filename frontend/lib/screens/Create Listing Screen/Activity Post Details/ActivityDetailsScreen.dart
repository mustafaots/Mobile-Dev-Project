import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityFormLogic.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/Activity%20Widgets/ActivityHeader.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/Activity%20Widgets/BasicDetailsCard.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/Activity%20Widgets/RequirementSection.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;
  final int userId;

  const ActivityDetailsScreen({required this.userId, this.existingData, super.key});
  
  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final ActivityFormController _formController = ActivityFormController();
  
  @override
  void initState() {
    super.initState();
    _formController.loadExistingData(widget.existingData);
  }
  
  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.form_error_fill_all)),
      );
      return;
    }
    
    final postData = _formController.createPostData(widget.existingData);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonDetailsScreen(userId: widget.userId, postData: postData),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: App_Bar(context, loc.activity_details_title),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget
            ActivityHeader(
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            
            const SizedBox(height: 32),
            
            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Details Card
                  BasicDetailsCard(
                    formController: _formController,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardColor: cardColor,
                    onRateChanged: (value) {
                      setState(() {
                        _formController.selectedPriceRate = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Requirements Section Widget
                  RequirementSection(
                    formController: _formController,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardColor: cardColor,
                    onUpdate: () => setState(() {}),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _formController.validateForm()
                            ? AppTheme.successColor
                            : AppTheme.successColor.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _formController.validateForm() ? _submitForm : null,
                      child: Text(
                        loc.continue_button,
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
          ],
        ),
      ),
    );
  }
}