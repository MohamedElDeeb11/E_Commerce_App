import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];

    if (url == null || url.isEmpty) {
      debugPrint('SupabaseConfig: SUPABASE_URL is missing from .env');
      throw Exception('SUPABASE_URL is missing from .env');
    }

    debugPrint('SupabaseConfig: SUPABASE_URL loaded successfully: $url');
    return url;
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];

    if (key == null || key.isEmpty) {
      debugPrint('SupabaseConfig: SUPABASE_ANON_KEY is missing from .env');
      throw Exception('SUPABASE_ANON_KEY is missing from .env');
    }

    debugPrint('SupabaseConfig: SUPABASE_ANON_KEY loaded successfully');
    return key;
  }

  static const String productImagesBucket = 'product-images';
  static const String categoryImagesBucket = 'category-images';
  static const String brandLogosBucket = 'brand-logos';
  static const String bannerImagesBucket = 'banner-images';
  static const String avatarsBucket = 'avatars';
  static const String reviewImagesBucket = 'review-images';
}