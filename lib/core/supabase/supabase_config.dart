import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];

    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL is missing from .env');
    }

    return url;
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is missing from .env');
    }

    return key;
  }

  static const String productImagesBucket = 'product-images';
  static const String categoryImagesBucket = 'category-images';
  static const String brandLogosBucket = 'brand-logos';
  static const String bannerImagesBucket = 'banner-images';
  static const String avatarsBucket = 'avatars';
  static const String reviewImagesBucket = 'review-images';
}