import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cardCacheW = (260 * dpr).toInt();
    final cardCacheH = (200 * dpr).toInt();
    final fullWidthCache = (MediaQuery.of(context).size.width * dpr).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured Activities',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
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
                  Navigator.pushReplacement(
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
                          'assets/images/skiing.jpg',
                          width: 260,
                          height: 170,
                          fit: BoxFit.cover,
                          cacheWidth: cardCacheW,
                          cacheHeight: cardCacheH,
                        ),
                      ),
                      const ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Skiing',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Chrea'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_border_outlined,
                              color: AppTheme.neutralColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
              const Text(
                'Recommended for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
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
                            'assets/images/bike_riding.jpg',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            cacheWidth: fullWidthCache,
                            cacheHeight: cardCacheH,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Quad riding',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Sahara'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_border_outlined,
                                color: AppTheme.neutralColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '4.7',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
