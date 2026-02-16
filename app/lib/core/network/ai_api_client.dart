import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/app_config.dart';
import 'api_client.dart';

/// Creates a [Dio] instance configured for the AI Service (port 8001).
Dio createAiApiClient({FirebaseAuth? firebaseAuth}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.aiServiceBaseUrl}${AppConfig.apiVersion}',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
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
