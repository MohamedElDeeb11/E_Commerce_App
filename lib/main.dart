import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // تأكد من استيراد حزمة سوبابيس
import 'package:t_store/core/common/widgets/navigation_menu.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_state.dart';
import 'package:t_store/core/utils/theme/theme.dart';
import 'package:t_store/features/auth/presentation/views/login/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // بنجيب الجلسة الحالية من Supabase
    final session = Supabase.instance.client.auth.currentSession;

    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: themeState.themeMode,
            // لو في جلسة (مسجل دخول) يفتح الـ NavigationMenu، لو مفيش يفتح LoginView غصب عنه
            home: session != null ? const NavigationMenu() : const LoginView(),
          );
        },
      ),
    );
  }
}