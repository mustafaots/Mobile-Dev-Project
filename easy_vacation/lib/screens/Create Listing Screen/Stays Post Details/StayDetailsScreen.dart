import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/Stay%20Widgets/StayDetailsCard.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/Stay%20Widgets/StayHeader.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/StayFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';

class StayDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;
  final int userId;

  const StayDetailsScreen({required this.userId, this.existingData, super.key});
  
  @override
  State<StayDetailsScreen> createState() => _StayDetailsScreenState();
}

class _StayDetailsScreenState extends State<StayDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final StayFormController _formController = StayFormController();
  
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
        const SnackBar(content: Text('Please fill all required fields correctly')),
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
    
    return Scaffold(
      appBar: App_Bar(context, 'Stay Details'),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget
            StayHeader(
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
                  // Stay Details Card
                  StayDetailsCard(
                    formController: _formController,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardColor: cardColor,
                    onRateChanged: (value) {
                      setState(() {
                        _formController.selectedPriceRate = value!;
                      });
                    },
                    onStayTypeChanged: (value) {
                      setState(() {
                        _formController.selectedStayType = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _formController.validateForm()
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _formController.validateForm() ? _submitForm : null,
                      child: const Text(
                        'Continue to Location',
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