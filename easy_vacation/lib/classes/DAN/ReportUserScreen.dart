import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class ReportUserScreen extends StatefulWidget {
  const ReportUserScreen({super.key});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  List problems = [
    'Inappropriate content',
    'Spam or scam',
    'Misleading information',
    'Safety concern',
    'Other'
  ];

  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tell us what's wrong",
                style: AppTheme.header1.copyWith(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(var problem in problems)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: AppTheme.grey.withOpacity(0.3)
                        )
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        child: RadioListTile(
                          activeColor: AppTheme.primaryColor,
                          dense: true,
                          value: problem,
                          title: Text(problem, style: const TextStyle(fontSize: 16)),
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        ),
                      )
                    ),
                  const SizedBox(height: 20),
                  Text('Additional Details (Optional)', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    decoration: AppTheme.inputDecoration('Provide more information', Icons.description)
                      .copyWith(
                        contentPadding: const EdgeInsets.all(16),
                      ),
                  ),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () {
                        // Handle report submission
                      },
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}