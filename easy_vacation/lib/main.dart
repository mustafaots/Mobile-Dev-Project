import 'package:easy_vacation/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';


late Map<String, dynamic> appRepos;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all repositories
  appRepos = await RepoFactory.createAllRepos();
  
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale _locale = const Locale('en'); // default

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        buildWhen: (previous, current) => true,
        builder: (context, themeData) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('ar'),
            ],
            locale: _locale, // dynamic locale
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
