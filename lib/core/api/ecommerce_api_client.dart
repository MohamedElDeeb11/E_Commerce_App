import 'package:dio/dio.dart';

class EcommerceApiClient {
  final Dio dio;

  EcommerceApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://accessories-eshop.runasp.net/scalar/',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          String errorMessage = 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';

          if (error.response != null) {
            switch (error.response?.statusCode) {
              case 400:
                errorMessage = 'طلب غير صحيح، يرجى التأكد من البيانات الإدخالية';
                break;
              case 401:
                errorMessage = 'جلسة غير مصرح بها، يرجى تسجيل الدخول مجدداً';
                break;
              case 403:
                errorMessage = 'ليس لديك صلاحيات الوصول لهذا المورد';
                break;
              case 404:
                errorMessage = 'المورد المطلوب غير موجود';
                break;
              case 500:
                errorMessage = 'خطأ في السيرفر الداخلي، يرجى المحاولة لاحقاً';
                break;
            }
          } else if (error.type == DioExceptionType.connectionTimeout ||
                     error.type == DioExceptionType.receiveTimeout) {
            errorMessage = 'اتصال الشبكة ضعيف، يرجى التأكد من الاتصال بالإنترنت';
          }

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: errorMessage,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );
  }
}
