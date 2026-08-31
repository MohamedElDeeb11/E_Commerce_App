import 'package:flutter/material.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/features/auth/presentation/views/on_boarding/on_boarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // دالة عشان تستنى ثانيتين وبعدين تنقل لصفحة البداية
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.light, // خلفية بيضاء صريحة
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة (مؤقتاً لحد ما تحط صورة اللوجو بتاعك)
            const Icon(
              Icons.all_inclusive_rounded, // أيقونة قريبة من شكل التداخل
              color: TColors.primary, // أحمر نكسورا
              size: 55,
            ),
            const SizedBox(width: 10),
            // كلمة NEXORA
            Text(
              "NEXORA",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900, // خط عريض جداً
                    color: TColors.primary, // أحمر
                    letterSpacing: 2,
                    fontSize: 40,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}