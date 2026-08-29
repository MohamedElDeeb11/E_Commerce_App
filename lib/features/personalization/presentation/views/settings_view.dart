import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // لاستخدام Supabase للـ Logout
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:t_store/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:t_store/core/utils/localizations/app_localizations.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/personalization/presentation/views/profile_view.dart'; // شاشة البروفايل
import 'package:t_store/features/personalization/presentation/views/user_addresses_view.dart'; // شاشة العناوين
import 'package:t_store/features/auth/presentation/views/login/login_view.dart'; // شاشة تسجيل الدخول

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('account'.tr(context), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: TSizes.spaceBtwItems),
            
            // كارد البروفايل
            Material(
              color: isDark ? TColors.darkContainer : TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                side: BorderSide(color: isDark ? TColors.darkerGrey : TColors.borderPrimary),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  THelperFunctions.navigateToScreen(context, const ProfileView());
                },
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mohamed Mahmoud', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                            const SizedBox(height: 2),
                            Text('mohamed@gmail.com', style: TextStyle(fontSize: 12, color: isDark ? TColors.darkGrey : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: TColors.darkGrey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            
            Text('setting_section'.tr(context), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: TSizes.spaceBtwItems),
            
            // زرار شاشة العناوين
            _buildSettingTile(
              icon: Iconsax.safe_home,
              title: 'Addresses',
              dark: isDark,
              onTap: () {
                THelperFunctions.navigateToScreen(context, const UserAddressesView());
              },
            ),

            _buildSettingTile(icon: Iconsax.notification, title: 'notification'.tr(context), dark: isDark, onTap: () {}),
            
            // زرار تغيير اللغة
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
            
            // سويتش الدارك مود
            _buildSwitchTile(
              icon: Iconsax.moon,
              title: 'dark_mode'.tr(context),
              value: isDark,
              dark: isDark,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme(value);
              },
            ),

            _buildSettingTile(icon: Iconsax.security_card, title: 'privacy'.tr(context), dark: isDark, onTap: () {}),
            _buildSettingTile(icon: Iconsax.headphone, title: 'help_center'.tr(context), dark: isDark, onTap: () {}),
            _buildSettingTile(icon: Iconsax.info_circle, title: 'about_us'.tr(context), dark: isDark, onTap: () {}),
            
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
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
          activeColor: TColors.primary,
        ),
      ),
    );
  }
}