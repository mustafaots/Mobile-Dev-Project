import 'package:easy_vacation/screens/WelcomeScreen.dart';
import 'package:easy_vacation/screens/SignUpScreen.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/utils/deep_link_handler.dart';


late Map<String, dynamic> appRepos;

final GlobalKey<NavigatorState> navigator_key = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all repositories
  appRepos = await RepoFactory.getRepositories();
  
  // Initialize SharedPreferences service
  await SharedPrefsService.init();
  
  // Initialize API services for backend connection
  await ApiServiceLocator.init();
  
  // Initialize sync manager for remote/local data synchronization
  await SyncManager.instance.init();
  
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
  bool _isCheckingSession = true;
  
  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
    // Defer session check to after first frame to avoid "Build scheduled during frame" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkHandler.init(context);
      _checkStoredSession();
    });
  }

  @override
  void dispose() {
    DeepLinkHandler.dispose();
    super.dispose();
  }


  void _loadSavedSettings() {
    // Load saved language from SharedPreferences (no setState here, just update directly)
    final savedLanguage = SharedPrefsService.getLanguage();
    if (savedLanguage.isNotEmpty && savedLanguage != 'en') {
      _locale = Locale(savedLanguage);
    }
  }

  Future<void> _checkStoredSession() async {
    // Check if user has a stored session
    final user = await SyncManager.instance.auth.tryRestoreSession();
    
    if (user != null) {
      // User is logged in, go to home screen
      setState(() {
        _initialScreen = HomeScreen(userId: user.id);
        _isCheckingSession = false;
      });
    } else {
      // No valid session, show welcome/signup screen
      final isFirstLaunch = SharedPrefsService.isFirstLaunch();
      SharedPrefsService.setFirstLaunchCompleted();
      setState(() {
        _initialScreen = isFirstLaunch ? const WelcomeScreen() : const SignUpScreen();
        _isCheckingSession = false;
      });
    }
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
    // Show loading while checking session
    if (_isCheckingSession) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, themeData) {
          return MaterialApp(
            navigatorKey: navigator_key,
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
            home: _initialScreen ?? const WelcomeScreen(),
          );
        },
      ),
    );
  }
}