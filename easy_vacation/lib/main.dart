import 'package:easy_vacation/screens/WelcomeScreen.dart';
import 'package:easy_vacation/screens/SignUpScreen.dart'; // Add your SignUpScreen import
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences service
  await SharedPrefsService.init();
  
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
  Widget? _initialScreen; // Store the initial screen
  
  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  void _loadSavedSettings() {
    // Load saved language from SharedPreferences
    final savedLanguage = SharedPrefsService.getLanguage();
    if (savedLanguage.isNotEmpty && savedLanguage != 'en') {
      setState(() {
        _locale = Locale(savedLanguage);
      });
    }
    
    // Determine initial screen based on first launch
    final isFirstLaunch = SharedPrefsService.isFirstLaunch();
    SharedPrefsService.setFirstLaunchCompleted();
    _initialScreen = isFirstLaunch ? const WelcomeScreen() : const SignUpScreen();
  }

  void setLocale(Locale locale) {
    // Save to SharedPreferences
    SharedPrefsService.setLanguage(locale.languageCode);
    
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
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
            locale: _locale,
            debugShowCheckedModeBanner: false,
            title: 'Easy Vacation',
            theme: themeData,
            home: _initialScreen ?? const WelcomeScreen(), // Use determined screen
          );
        },
      ),
    );
  }
}