import 'dart:typed_data';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final postCategory;
  final postType;
  final price;
  final date;
  final wilaya;
  SearchScreen({
    super.key,
    required this.postCategory,
    this.postType,
    this.price,
    this.date,
    this.wilaya
  });

  final postRepo = appRepos['postRepo'] as PostRepository;
  
  Future<List<Post>> getPosts() async {
    print('price: $price');
    print('wilaya: $wilaya');
    return await postRepo.getPostsFiltered(
      wilaya: wilaya, category: postCategory, maxPrice: price,
      type: postType, dates: date
    );
  }

  Future<Widget> getPostImageWidget(
    int postId,
    int cache_w, int cache_h,
    {double width = double.infinity, double height = 200}
  ) async {
    final imageRepo = appRepos['imageRepo'] as PostImagesRepository;
    final imageRow = await imageRepo.getImageByPostId(postId);

    if (imageRow != null) {
      final bytes = imageRow['image'] as Uint8List;
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheWidth: cache_w,
        cacheHeight: cache_h,
      );
    } else {
      // Fallback image if no image in DB
      return Image.asset(
        'assets/images/no_image.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheHeight: cache_h,
        cacheWidth: cache_w,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cardCacheH = (200 * dpr).toInt();
    final fullWidthCache = (MediaQuery.of(context).size.width * dpr).toInt();
    final loc = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor,),
          );
        }
        else if(snapshot.hasData) {
          final posts = snapshot.data!;
          if(posts.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.no_matching_posts,
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 85, 85, 85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
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
                            AspectRatio(
                              aspectRatio: (MediaQuery.of(context).size.width - 40) / 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FutureBuilder<Widget>(
                                  future: getPostImageWidget(
                                    post.id!,
                                    fullWidthCache,
                                    cardCacheH,
                                  ),
                                  builder: (context, snapshot) {
                                    if(snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if(!snapshot.hasData) {
                                      return Image.asset(
                                        'assets/images/no_image.png',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      );
                                    }
                                    return snapshot.data!;
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                post.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              subtitle: Text(
                                '${post.price}${loc.dinars}/${loc.night}',
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
            )
          );
        }
        else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  "Error in getting data",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 85, 85, 85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}