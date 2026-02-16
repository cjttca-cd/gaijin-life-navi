import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/core/providers/router_provider.dart';

void main() {
  group('AppRoutes', () {
    test('has all required route paths', () {
      expect(AppRoutes.root, '/');
      expect(AppRoutes.language, '/language');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
      expect(AppRoutes.resetPassword, '/reset-password');
      expect(AppRoutes.onboarding, '/onboarding');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.chat, '/chat');
      expect(AppRoutes.chatConversation, '/chat/:id');
      expect(AppRoutes.tracker, '/tracker');
      expect(AppRoutes.navigate, '/navigate');
      expect(AppRoutes.profile, '/profile');
    });

    test('protected routes include all main tabs', () {
      final protectedRoutes = [
        AppRoutes.home,
        AppRoutes.chat,
        AppRoutes.tracker,
        AppRoutes.navigate,
        AppRoutes.profile,
      ];
      expect(protectedRoutes.length, 5);
    });

    test('public routes include auth-related paths', () {
      final publicRoutes = [
        AppRoutes.root,
        AppRoutes.language,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.resetPassword,
      ];
      expect(publicRoutes.length, 5);
      expect(publicRoutes.contains(AppRoutes.home), isFalse);
    });

    test('onboarding route is defined', () {
      expect(AppRoutes.onboarding, '/onboarding');
    });

    test('chat conversation route has :id parameter', () {
      expect(AppRoutes.chatConversation, contains(':id'));
    });
  });
}
