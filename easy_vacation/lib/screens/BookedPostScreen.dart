import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';
import 'ListingDetailsWidgets/index.dart';

class BookedPostScreen extends StatelessWidget {
  const BookedPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    return Scaffold(
      appBar: App_Bar(
        context,
        AppLocalizations.of(context)!.listingDetails_title,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ImageGallery(),
                  const TitleSection(),
                  const HostInfo(),
                  const ReviewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
