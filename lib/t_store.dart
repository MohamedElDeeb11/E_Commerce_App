import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_store/core/common/widgets/navigation_menu.dart';
import 'package:t_store/core/cubits/banner_carousel_slider_cubit_cubit/banner_carousel_slider_cubit.dart';
import 'package:t_store/core/cubits/navigation_menu_cubit/navigation_menu_cubit.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_state.dart';
import 'package:t_store/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:t_store/core/dependency_injection/service_locator.dart';
import 'package:t_store/core/utils/theme/theme.dart';
import 'package:t_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:t_store/features/auth/presentation/logic/on_boarding/on_boarding_cubit.dart';
import 'package:t_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/banners_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/brands_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/categories_cubit.dart';
import 'package:t_store/features/shop/presentation/cubit/products_cubit.dart';
import 'package:t_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:t_store/core/utils/localizations/app_localizations.dart';

class TStore extends StatelessWidget {
  const TStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        BlocProvider<NavigationMenuCubit>(create: (_) => sl<NavigationMenuCubit>()),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ProductsCubit>(create: (_) => sl<ProductsCubit>()),
        BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
        BlocProvider<BrandsCubit>(create: (_) => sl<BrandsCubit>()),
        BlocProvider<BannersCubit>(create: (_) => sl<BannersCubit>()),
        BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()),
        BlocProvider<WishlistCubit>(create: (_) => sl<WishlistCubit>()),
        BlocProvider<OnBoardingCubit>(create: (_) => OnBoardingCubit()),
        BlocProvider<BannerCarouselSliderCubit>(create: (_) => BannerCarouselSliderCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          // هنا بنسمع للغة ونخلي الـ MaterialApp يتبنى من أول وديد لما اللغة تتغير
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, currentLocale) {
              return MaterialApp(
                title: 'T Store',
                debugShowCheckedModeBanner: false,
                
                // إعدادات اللغة الأساسية
                locale: currentLocale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                
                theme: TAppTheme.lightTheme.copyWith(
                  appBarTheme: TAppTheme.lightTheme.appBarTheme.copyWith(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Colors.white,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
                  ),
                ),
                
                darkTheme: TAppTheme.darkTheme.copyWith(
                  appBarTheme: TAppTheme.darkTheme.appBarTheme.copyWith(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarColor: Colors.black,
                      systemNavigationBarIconBrightness: Brightness.light,
                    ),
                  ),
                ),
                
                themeMode: themeState.themeMode,
                
                builder: (context, child) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                      systemNavigationBarColor: isDark ? Colors.black : Colors.white,
                      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                    ),
                    child: child!,
                  );
                },
                
                home: const NavigationMenu(),
              );
            },
          );
        },
      ),
    );
  }
}