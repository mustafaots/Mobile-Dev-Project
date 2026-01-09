import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/models/reports.model.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/repositories/db_repositories/report_repository.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class ReportUserScreen extends StatefulWidget {
  final int? reporterId;
  final int? reportedPostId;
  final int? reportedUserId;
  const ReportUserScreen({
    super.key,
    this.reporterId,
    this.reportedUserId,
    this.reportedPostId
  });

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  String? selectedOption;
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitting = false;

  void _showSuccessModal() {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  loc.reportUser_reportSubmitted,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  loc.reportUser_thankYouReport,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close modal
                          ///////////////////////////////////////////////////////
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const ProfileScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                            ),
                          );
                          ///////////////////////////////////////////////////////
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          loc.reportUser_done,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitReport() {
    if (selectedOption == null) {
      // Show error if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.failureColor,
          content: Text(AppLocalizations.of(context)!.reportUser_selectReason),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () async {
      setState(() {
        _isSubmitting = false;
      });

      final reportRepo = appRepos['reportRepo'] as ReportRepository;
      final rp = Report(
        reportedUserId: widget.reportedUserId,
        reporterId: widget.reporterId ?? 1,
        reason: selectedOption!,
        createdAt: DateTime.now()
      );
      int report_id = await reportRepo.insertReport(rp);
      print(report_id);
      _showSuccessModal();
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    final loc = AppLocalizations.of(context)!;

    List problems = [
      {"key": "inappropriate_content", "label": loc.reportUser_inappropriateContent},
      {"key": "scam_spam", "label": loc.reportUser_spamOrScam},
      {"key": "misleading_info", "label": loc.reportUser_misleadingInfo},
      {"key": "safety_concerns", "label": loc.reportUser_safetyConcern},
      {"key": "other", "label": loc.reportUser_other},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.reportUser_title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.reportUser_tellUsWrong,
                style: AppTheme.header1.copyWith(
                  fontSize: 25,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var problem in problems)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: secondaryTextColor.withOpacity(0.3),
                        ),
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
                          value: problem['key'],
                          title: Text(
                            problem['label'],
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    loc.reportUser_additionalDetails,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _detailsController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 5,
                    decoration: AppTheme.inputDecoration(
                      loc.reportUser_provideMoreInfo,
                      Icons.description,
                      context
                    ).copyWith(contentPadding: const EdgeInsets.all(15)),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isSubmitting ? null : _submitReport,
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: AppProgressIndicator(
                                strokeWidth: 2,
                                color: backgroundColor,
                              ),
                            )
                          : Text(
                              loc.reportUser_submitReport,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
