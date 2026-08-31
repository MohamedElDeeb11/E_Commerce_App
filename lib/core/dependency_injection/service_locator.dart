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
import '../../features/cart/data/data_sources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items_usecase.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

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

  sl.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetCartItemsUsecase(sl()));
  sl.registerLazySingleton(() => AddToCartUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUsecase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUsecase(sl()));
  sl.registerLazySingleton(() => ClearCartUsecase(sl()));
  sl.registerFactory(() => CartCubit(
        getCartItemsUsecase: sl(),
        addToCartUsecase: sl(),
        updateCartItemUsecase: sl(),
        removeFromCartUsecase: sl(),
        clearCartUsecase: sl(),
      ));
}
