import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your listings...'),
        ],
      ),
    );
  }
}