import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/dependency_injection/service_locator.dart';
import 'package:t_store/core/utils/local_preferences_helper.dart';
import 'package:t_store/features/auth/presentation/views/on_boarding/on_boarding_view.dart';
import 'package:t_store/features/auth/presentation/views/login/login_view.dart';
import 'package:t_store/core/common/widgets/navigation_menu.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    if (mounted) {
      final prefs = sl<LocalPreferencesHelper>();
      final hasSeenOnboarding = prefs.hasSeenOnboarding;
      final authToken = prefs.authToken;

      Widget nextScreen;
      if (!hasSeenOnboarding) {
        nextScreen = const OnBoardingView();
      } else if (authToken != null && authToken.isNotEmpty) {
        nextScreen = const NavigationMenu();
      } else {
        nextScreen = const LoginView();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.light,
      body: Center(
        child: Image.asset(
          isDark
              ? 'assets/logos/t-store-splash-logo-white.png'
              : 'assets/logos/t-store-splash-logo-black.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}