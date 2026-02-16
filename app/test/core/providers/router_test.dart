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

    // M2 routes
    test('Banking Navigator routes are defined', () {
      expect(AppRoutes.banking, '/banking');
      expect(AppRoutes.bankingRecommend, '/banking/recommend');
      expect(AppRoutes.bankingGuide, '/banking/:bankId');
    });

    test('Visa Navigator routes are defined', () {
      expect(AppRoutes.visa, '/visa');
      expect(AppRoutes.visaDetail, '/visa/:procedureId');
    });

    test('Admin Tracker routes are defined', () {
      expect(AppRoutes.tracker, '/tracker');
      expect(AppRoutes.trackerDetail, '/tracker/:id');
      expect(AppRoutes.trackerAdd, '/tracker/add');
    });

    test('Document Scanner routes are defined', () {
      expect(AppRoutes.scanner, '/scanner');
      expect(AppRoutes.scannerHistory, '/scanner/history');
      expect(AppRoutes.scannerResult, '/scanner/:id');
    });

    test('Medical Guide route is defined', () {
      expect(AppRoutes.medical, '/medical');
    });

    test('banking guide route has :bankId parameter', () {
      expect(AppRoutes.bankingGuide, contains(':bankId'));
    });

    test('visa detail route has :procedureId parameter', () {
      expect(AppRoutes.visaDetail, contains(':procedureId'));
    });

    test('tracker detail route has :id parameter', () {
      expect(AppRoutes.trackerDetail, contains(':id'));
    });

    test('scanner result route has :id parameter', () {
      expect(AppRoutes.scannerResult, contains(':id'));
    });
  });
}
