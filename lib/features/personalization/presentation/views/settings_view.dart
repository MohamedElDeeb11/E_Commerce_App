import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:t_store/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:t_store/core/utils/localizations/app_localizations.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/personalization/presentation/views/profile_view.dart';
import 'package:t_store/features/personalization/presentation/views/user_addresses_view.dart';
import 'package:t_store/features/personalization/presentation/cubit/profile_cubit.dart';
import 'package:t_store/features/personalization/presentation/cubit/profile_state.dart';
import 'package:t_store/core/dependency_injection/service_locator.dart';

// استدعاء كارت الضيف (تأكد إن المسار ده متطابق مع مكان الملف اللي عملناه)
import 'package:t_store/features/personalization/presentation/widgets/guest_profile_card.dart'; 

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..getProfile(),
      child: const SettingsViewBody(),
    );
  }
}

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'settings'.tr(context),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: TColors.primary,
        backgroundColor: isDark ? TColors.darkContainer : Colors.white,
        onRefresh: () async {
          context.read<ProfileCubit>().getProfile();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'account'.tr(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              // التعديل تم هنا يا هندسة 👇
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  // لو في خطأ (زي إن التوكن منتهي) نعرض كارت الضيف مباشرة
                  if (state is ProfileError) {
                    return const GuestProfileCard();
                  }

                  final user = (state is ProfileLoaded)
                      ? state.user
                      : (state is ProfileUpdated)
                          ? state.user
                          : null;

                  // لو المستخدم مش مسجل دخول (بـ null)، نعرض كارت الضيف
                  if (user == null) {
                    return const GuestProfileCard();
                  }

                  // لو مسجل دخول، نعرض بياناته الحقيقية
                  final String realName = user.fullName ?? "User";
                  final String realEmail = user.email;
                  final String avatarUrl = user.avatarUrl ?? '';

                  return Material(
                    color: isDark ? TColors.darkContainer : TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      side: BorderSide(color: isDark ? TColors.darkerGrey : TColors.borderPrimary),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () async {
                        THelperFunctions.navigateToScreen(context, const ProfileView());
                        if (context.mounted) {
                          context.read<ProfileCubit>().getProfile();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl)
                                  : const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(realName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                                  const SizedBox(height: 2),
                                  Text(realEmail, style: TextStyle(fontSize: 12, color: isDark ? TColors.darkGrey : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: TColors.darkGrey),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // التعديل خلص هنا 👆

              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                'setting_section'.tr(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildSettingTile(
                icon: Iconsax.safe_home,
                title: 'Addresses',
                dark: isDark,
                onTap: () => THelperFunctions.navigateToScreen(context, const UserAddressesView()),
              ),
              _buildSettingTile(icon: Iconsax.notification, title: 'notification'.tr(context), dark: isDark, onTap: () {}),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  final isArabic = locale.languageCode == 'ar';
                  return _buildSettingTile(
                    icon: Iconsax.global,
                    title: 'language'.tr(context),
                    trailingText: isArabic ? 'العربية' : 'English',
                    dark: isDark,
                    onTap: () {
                      final newLang = isArabic ? 'en' : 'ar';
                      context.read<LocaleCubit>().changeLanguage(newLang);
                    },
                  );
                },
              ),
              _buildSwitchTile(
                icon: Iconsax.moon,
                title: 'dark_mode'.tr(context),
                value: isDark,
                dark: isDark,
                onChanged: (value) => context.read<ThemeCubit>().toggleTheme(value),
              ),
              _buildSettingTile(icon: Iconsax.security_card, title: 'privacy'.tr(context), dark: isDark, onTap: () {}),
              _buildSettingTile(icon: Iconsax.headphone, title: 'help_center'.tr(context), dark: isDark, onTap: () {}),
              _buildSettingTile(icon: Iconsax.info_circle, title: 'about_us'.tr(context), dark: isDark, onTap: () {}),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, String? trailingText, required bool dark, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Material(
        color: dark ? TColors.darkContainer : TColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          side: BorderSide(color: dark ? TColors.darkerGrey : TColors.borderPrimary),
        ),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: Icon(icon, color: dark ? Colors.white : Colors.black, size: 22),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: dark ? Colors.white : Colors.black)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null) Text(trailingText, style: TextStyle(color: dark ? TColors.darkGrey : Colors.grey, fontSize: 12)),
              if (trailingText != null) const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: TColors.darkGrey),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required bool dark, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Material(
        color: dark ? TColors.darkContainer : TColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          side: BorderSide(color: dark ? TColors.darkerGrey : TColors.borderPrimary),
        ),
        clipBehavior: Clip.hardEdge,
        child: SwitchListTile(
          secondary: Icon(icon, color: dark ? Colors.white : Colors.black, size: 22),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: dark ? Colors.white : Colors.black)),
          value: value,
          onChanged: onChanged,
          activeThumbColor: TColors.primary,
        ),
      ),
    );
  }
}