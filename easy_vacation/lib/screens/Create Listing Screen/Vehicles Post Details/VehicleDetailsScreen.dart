import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonDetailsScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/Vehicle%20Widgets/VehicleDetailsCard.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/Vehicle%20Widgets/VehicleHeader.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/VehicleFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;
  const VehicleDetailsScreen({this.existingData, super.key});
  
  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final VehicleFormController _formController = VehicleFormController();
  
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
        builder: (context) => CommonDetailsScreen(postData: postData),
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
      appBar: App_Bar(context, 'Vehicle Details'),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget
            VehicleHeader(
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
                  // Vehicle Details Card
                  VehicleDetailsCard(
                    formController: _formController,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardColor: cardColor,
                    onRateChanged: (value) {
                      setState(() {
                        _formController.selectedPriceRate = value!;
                      });
                    },
                    onVehicleTypeChanged: (value) {
                      setState(() {
                        _formController.selectedVehicleType = value;
                      });
                    },
                    onFuelTypeChanged: (value) {
                      setState(() {
                        _formController.selectedFuelType = value;
                      });
                    },
                    onTransmissionChanged: (value) {
                      setState(() {
                        _formController.isAutomaticTransmission = value;
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
                            ? AppTheme.neutralColor
                            : AppTheme.neutralColor.withOpacity(0.5),
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