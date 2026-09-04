import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/create_order_usecase.dart';
import '../../features/checkout/presentation/cubit/checkout_cubit.dart';

import '../../features/personalization/data/repositories/profile_repository_impl.dart';
import '../../features/personalization/domain/repositories/profile_repository.dart';
import '../../features/personalization/domain/usecases/get_profile_usecase.dart';
import '../../features/personalization/domain/usecases/update_profile_usecase.dart';
import '../../features/personalization/domain/usecases/upload_avatar_usecase.dart';
import '../../features/personalization/presentation/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/ecommerce_api_client.dart';
import '../utils/local_preferences_helper.dart';
import '../supabase/supabase_service.dart';
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
import '../../features/shop/data/repositories/product_repository_impl.dart';
import '../../features/shop/data/repositories/category_repository_impl.dart';
import '../../features/shop/data/repositories/brand_repository_impl.dart';
import '../../features/shop/data/repositories/banner_repository_impl.dart';
import '../../features/shop/domain/repositories/product_repository.dart';
import '../../features/shop/domain/repositories/category_repository.dart';
import '../../features/shop/domain/repositories/brand_repository.dart';
import '../../features/shop/domain/repositories/banner_repository.dart';
import '../../features/shop/domain/usecases/get_products_usecase.dart';
import '../../features/shop/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/shop/domain/usecases/search_products_usecase.dart';
import '../../features/shop/domain/usecases/get_categories_usecase.dart';
import '../../features/shop/domain/usecases/get_brands_usecase.dart';
import '../../features/shop/domain/usecases/get_banners_usecase.dart';
import '../../features/shop/presentation/cubit/products_cubit.dart';
import '../../features/shop/presentation/cubit/categories_cubit.dart';
import '../../features/shop/presentation/cubit/brands_cubit.dart';
import '../../features/shop/presentation/cubit/banners_cubit.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import '../../features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import '../../features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/cart/data/data_sources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_items_usecase.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../core/cubits/navigation_menu_cubit/navigation_menu_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<LocalPreferencesHelper>(LocalPreferencesHelper(sharedPreferences));
  sl.registerSingleton<EcommerceApiClient>(EcommerceApiClient());
  sl.registerSingleton<SupabaseService>(SupabaseService.instance);

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

  // --- Products ---
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUsecase(sl()));
  sl.registerLazySingleton(() => SearchProductsUsecase(sl()));
  sl.registerFactory(() => ProductsCubit(
        getProductsUsecase: sl(),
        getProductByIdUsecase: sl(),
        searchProductsUsecase: sl(),
      ));

  // --- Categories ---
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));
  sl.registerFactory(() => CategoriesCubit(getCategoriesUsecase: sl()));

  // --- Brands ---
  sl.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetBrandsUsecase(sl()));
  sl.registerFactory(() => BrandsCubit(getBrandsUsecase: sl()));

  // --- Banners ---
  sl.registerLazySingleton<BannerRepository>(() => BannerRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetBannersUsecase(sl()));
  sl.registerFactory(() => BannersCubit(getBannersUsecase: sl()));

  // --- Wishlist ---
  sl.registerLazySingleton<WishlistRepository>(() => WishlistRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetWishlistUsecase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUsecase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUsecase(sl()));
  sl.registerFactory(() => WishlistCubit(
        getWishlistUsecase: sl(),
        addToWishlistUsecase: sl(),
        removeFromWishlistUsecase: sl(),
      ));

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

  // --- Checkout ---
  sl.registerLazySingleton<CheckoutRepository>(() => CheckoutRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => CreateOrderUsecase(sl()));
  sl.registerFactory(() => CheckoutCubit(createOrderUsecase: sl()));


    // --- Profile / Personalization ---
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(supabaseService: sl()));
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));
  sl.registerLazySingleton(() => UploadAvatarUsecase(sl()));
  sl.registerFactory(() => ProfileCubit(
        getProfileUsecase: sl(),
        updateProfileUsecase: sl(),
        uploadAvatarUsecase: sl(),
      ));

  // --- Navigation Menu ---
  sl.registerFactory(() => NavigationMenuCubit());
}
