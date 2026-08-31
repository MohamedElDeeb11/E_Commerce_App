import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:t_store/core/api/ecommerce_api_client.dart';
import 'package:t_store/core/utils/exceptions/exceptions.dart';
import 'package:t_store/features/cart/data/models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<TExceptions, List<CartItemModel>>> getCartItems();
  Future<Either<TExceptions, CartItemModel>> addToCart({required String productId, required int quantity, Map<String, dynamic>? selectedAttributes});
  Future<Either<TExceptions, CartItemModel>> updateCartItem({required String cartItemId, required int quantity});
  Future<Either<TExceptions, void>> removeFromCart(String cartItemId);
  Future<Either<TExceptions, void>> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final EcommerceApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<TExceptions, List<CartItemModel>>> getCartItems() async {
    try {
      final response = await apiClient.dio.get('api/cart');
      if (response.statusCode == 200) {
        final data = response.data;
        final list = (data is List ? data : data['data'] ?? [])
            .map((e) => CartItemModel.fromJson(e))
            .toList();
        return Right(list);
      }
      return Left(TExceptions.fromCode(response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(TExceptions(e.error?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, CartItemModel>> addToCart({
    required String productId,
    required int quantity,
    Map<String, dynamic>? selectedAttributes,
  }) async {
    try {
      final response = await apiClient.dio.post('api/cart/add', data: {
        'product_id': productId,
        'quantity': quantity,
        'selected_attributes': selectedAttributes,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return Right(CartItemModel.fromJson(data));
      }
      return Left(TExceptions.fromCode(response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(TExceptions(e.error?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, CartItemModel>> updateCartItem({required String cartItemId, required int quantity}) async {
    try {
      final response = await apiClient.dio.put('api/cart/update/$cartItemId', data: {
        'quantity': quantity,
      });
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return Right(CartItemModel.fromJson(data));
      }
      return Left(TExceptions.fromCode(response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(TExceptions(e.error?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, void>> removeFromCart(String cartItemId) async {
    try {
      final response = await apiClient.dio.delete('api/cart/remove/$cartItemId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      }
      return Left(TExceptions.fromCode(response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(TExceptions(e.error?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }

  @override
  Future<Either<TExceptions, void>> clearCart() async {
    try {
      final response = await apiClient.dio.delete('api/cart/clear');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      }
      return Left(TExceptions.fromCode(response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(TExceptions(e.error?.toString() ?? e.message ?? 'Network error'));
    } catch (e) {
      return Left(TExceptions(e.toString()));
    }
  }
}