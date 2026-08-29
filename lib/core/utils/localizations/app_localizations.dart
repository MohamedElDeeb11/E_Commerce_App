import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // القاموس الشامل لكل كلمات التطبيق (تم إضافة Profile و Name و Delete Account)
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'account': 'Account',
      'setting_section': 'Setting',
      'notification': 'Notification',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'privacy': 'Privacy',
      'help_center': 'Help Center',
      'about_us': 'About us',
      'home': 'Home',
      'wishlist': 'Wishlist',
      'search': 'Search',
      'profile': 'Profile',
      'name': 'Name',
      'delete_account': 'Delete Account',
    },
    'ar': {
      'settings': 'الإعدادات',
      'account': 'الحساب',
      'setting_section': 'الإعدادات العامة',
      'notification': 'الإشعارات',
      'language': 'اللغة',
      'dark_mode': 'الوضع الداكن',
      'privacy': 'الخصوصية',
      'help_center': 'مركز المساعدة',
      'about_us': 'من نحن',
      'home': 'الرئيسية',
      'wishlist': 'المفضلة',
      'search': 'بحث',
      'profile': 'الملف الشخصي',
      'name': 'الاسم',
      'delete_account': 'حذف الحساب',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}

// دالة الامتداد للترجمة السريعة .tr(context)
extension LocalizationExtension on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}