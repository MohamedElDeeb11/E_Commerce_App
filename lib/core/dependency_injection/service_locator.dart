import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/ecommerce_api_client.dart';
import '../utils/local_preferences_helper.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/shop/data/data_sources/shop_remote_data_source.dart';
import '../../features/shop/presentation/cubit/catalog_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<LocalPreferencesHelper>(LocalPreferencesHelper(sharedPreferences));
  sl.registerSingleton<EcommerceApiClient>(EcommerceApiClient());

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => SignInUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerFactory(() => AuthCubit(
        signInUsecase: sl(),
        signUpUsecase: sl(),
        signOutUsecase: sl(),
        resetPasswordUsecase: sl(),
        getCurrentUserUsecase: sl(),
      ));

  sl.registerLazySingleton<ShopRemoteDataSource>(() => ShopRemoteDataSourceImpl(apiClient: sl()));
  sl.registerFactory(() => CatalogCubit(remoteDataSource: sl()));
}
