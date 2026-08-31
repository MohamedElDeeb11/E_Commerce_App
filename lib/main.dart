import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:t_store/core/common/widgets/navigation_menu.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_state.dart';
import 'package:t_store/core/utils/theme/theme.dart';
import 'package:t_store/features/auth/presentation/views/login/login_view.dart';
import 'package:t_store/features/shop/presentation/cubit/wishlist_cubit.dart';

// --- دالة التشغيل الأساسية ---
Future<void> main() async {
  // 1. تهيئة الفلاتر
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تجميد الاسبلاش سكرين عشان التطبيق يفتح صح وما يعلقش
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. تحميل ملف الـ .env
  await dotenv.load(fileName: ".env");

  // 4. تهيئة السوبابيز وقراءة البيانات من الـ .env
  // (تأكد إن اسماء المتغيرات جوه ملف الـ .env هي SUPABASE_URL و SUPABASE_ANON_KEY 
  // أو غيرها هنا لو انت مسميها حاجة تانية)
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '', 
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // 5. إزالة الاسبلاش سكرين
  FlutterNativeSplash.remove();

  // 6. تشغيل التطبيق
  runApp(const App());
}

// --- كود واجهة التطبيق بتاعك ---
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<WishlistCubit>(
          create: (_) => WishlistCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: session != null ? const NavigationMenu() : const LoginView(),
          );
        },
      ),
    );
  }
}