import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class StaysScreen extends StatelessWidget {
  const StaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cardCacheW = (260 * dpr).toInt();
    final cardCacheH = (200 * dpr).toInt();
    final fullWidthCache = (MediaQuery.of(context).size.width * dpr).toInt();
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            loc.stays_featured_title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const PostDetailsScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/apar2.jpg',
                          width: 260,
                          height: 170,
                          fit: BoxFit.cover,
                          cacheWidth: cardCacheW,
                          cacheHeight: cardCacheH,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'BeachFront villa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          '\$300/${loc.night}',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_border_outlined,
                              color: AppTheme.neutralColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.recommended_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              const PostDetailsScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/apar2.jpg',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            cacheWidth: fullWidthCache,
                            cacheHeight: cardCacheH,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'BeachFront villa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            '\$400/${loc.night}',
                            style: TextStyle(color: secondaryTextColor),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_border_outlined,
                                color: AppTheme.neutralColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.7',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
