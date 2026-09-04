import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:t_store/core/api/ecommerce_api_client.dart';
import 'package:t_store/core/utils/helpers/dio_exception_helper.dart';
import 'package:t_store/core/utils/helpers/platform_exception_helper.dart';
import 'package:t_store/features/auth/data/models/change_password_req_body.dart';
import 'package:t_store/features/auth/data/models/change_password_response.dart';
import 'package:t_store/features/auth/data/models/login_req_body.dart';
import 'package:t_store/features/auth/data/models/login_response.dart';
import 'package:t_store/features/auth/data/models/register_req_body.dart';
import 'package:t_store/features/auth/data/models/send_otp_req_body.dart';
import 'package:t_store/features/auth/data/models/send_otp_response.dart';

abstract class AuthRemoteDataSource {
  Future<Either<String, void>> register(
      {required RegisterReqBody registerReqBody});
  Future<Either<String, LoginResponse>> login(
      {required LoginReqBody loginReqBody});
  Future<Either<String, SendOtpResponseData>> sendOtp(
      {required SendOtpReqBody forgetPasswordReqBody});
  Future<Either<String, ChangePasswordResponseData>> setNewPassword(
      {required ChangePasswordReqBody changePasswordReqBody});
  Future<Either<String, void>> verifyEmail(
      {required String email, required String otp});
  Future<Either<String, void>> resendOtp({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final EcommerceApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<String, void>> register(
      {required RegisterReqBody registerReqBody}) async {
    try {
      debugPrint('Registering user with payload: ${registerReqBody.toJson()}');
      await apiClient.dio.post(
        '/api/auth/register',
        data: registerReqBody.toJson(),
      );

      return const Right(null);
    } on DioException catch (e) {
      debugPrint('DioException during register: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<Either<String, LoginResponse>> login(
      {required LoginReqBody loginReqBody}) async {
    try {
      debugPrint('Logging in user with payload: ${loginReqBody.toJson()}');
      var response = await apiClient.dio.post(
        '/api/auth/login',
        data: loginReqBody.toJson(),
      );

      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      return Right(loginResponse);
    } on DioException catch (e) {
      debugPrint('DioException during login: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<Either<String, SendOtpResponseData>> sendOtp(
      {required SendOtpReqBody forgetPasswordReqBody}) async {
    try {
      var response = await apiClient.dio.post(
        '/api/auth/forgot-password',
        data: forgetPasswordReqBody.toJson(),
      );
      SendOtpResponse forgetPassResponse =
          SendOtpResponse.fromJson(response.data);
      if (forgetPassResponse.status) {
        return Right(forgetPassResponse.data!);
      } else {
        return Left(forgetPassResponse.message);
      }
    } on DioException catch (e) {
      debugPrint('DioException during sendOtp: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<Either<String, ChangePasswordResponseData>> setNewPassword(
      {required ChangePasswordReqBody changePasswordReqBody}) async {
    try {
      String token = changePasswordReqBody.token;
      var response = await apiClient.dio.post(
        '/api/auth/reset-password',
        data: changePasswordReqBody.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      ChangePasswordResponse changePasswordResponse =
          ChangePasswordResponse.fromJson(response.data);
      if (changePasswordResponse.status) {
        return Right(changePasswordResponse.data!);
      } else {
        return Left(changePasswordResponse.message);
      }
    } on DioException catch (e) {
      debugPrint('DioException during setNewPassword: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<Either<String, void>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      debugPrint('Verifying email: $email with OTP: $otp');
      await apiClient.dio.post(
        '/api/auth/verify-email',
        data: {'email': email, 'otp': otp},
      );
      return const Right(null);
    } on DioException catch (e) {
      debugPrint('DioException during verifyEmail: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<Either<String, void>> resendOtp({required String email}) async {
    try {
      debugPrint('Resending OTP to email: $email');
      await apiClient.dio.post(
        '/api/auth/resend-otp',
        data: {'email': email},
      );
      return const Right(null);
    } on DioException catch (e) {
      debugPrint('DioException during resendOtp: status=${e.response?.statusCode}, data=${e.response?.data}');
      return Left(e.error?.toString() ?? DioExceptionHelper.handleDioError(e));
    } on PlatformException catch (e) {
      return Left(PlatformExceptionHelper.handlePlatformError(e));
    } catch (e) {
      return Left('حدث خطأ غير متوقع: $e');
    }
  }
}
