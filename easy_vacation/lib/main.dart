import 'package:easy_vacation/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all repositories
  await RepoFactory.createAllRepos();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        buildWhen: (previous, current) => true,
        builder: (context, themeData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Easy Vacation',
            theme: themeData,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}

//const ProfileScreen(      postsCount: 24,
 //     followersCount: 128,
 //     followingCount: 56,
 //     isFollowing: false,), // Or your desired home screen


 