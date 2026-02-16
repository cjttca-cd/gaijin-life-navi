import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/app_config.dart';

/// Creates and configures a [Dio] instance with auth interceptor.
Dio createApiClient({FirebaseAuth? firebaseAuth}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.apiBaseUrl}${AppConfig.apiVersion}',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(firebaseAuth: firebaseAuth ?? FirebaseAuth.instance),
  );

  return dio;
}

/// Interceptor that attaches Firebase ID Token to every request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        options.headers['Authorization'] = 'Bearer $token';
      } catch (_) {
        // If token retrieval fails, proceed without auth header.
        // The server will return 401 and the app will handle it.
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Could add token refresh logic or global error handling here.
    handler.next(err);
  }
}
