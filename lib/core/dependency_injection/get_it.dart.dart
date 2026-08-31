import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/ecommerce_api_client.dart';
import '../utils/local_preferences_helper.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<LocalPreferencesHelper>(LocalPreferencesHelper(sharedPreferences));
  getIt.registerSingleton<EcommerceApiClient>(EcommerceApiClient());
}
