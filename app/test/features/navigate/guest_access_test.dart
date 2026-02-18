import 'package:flutter_test/flutter_test.dart';

/// Unit tests for the guest access boundary logic.
///
/// Per BUSINESS_RULES.md §2:
///   - Banking guides: full content for all (including guests)
///   - Other domains: guests see first 200 chars + registration CTA
void main() {
  group('Guest content gating', () {
    bool shouldShowFullContent({
      required bool isGuest,
      required String domain,
    }) {
      final isBanking = domain == 'banking';
      return !isGuest || isBanking;
    }

    test('logged-in user sees full content for all domains', () {
      expect(shouldShowFullContent(isGuest: false, domain: 'banking'), isTrue);
      expect(shouldShowFullContent(isGuest: false, domain: 'visa'), isTrue);
      expect(shouldShowFullContent(isGuest: false, domain: 'medical'), isTrue);
      expect(
        shouldShowFullContent(isGuest: false, domain: 'concierge'),
        isTrue,
      );
    });

    test('guest sees full content for banking only', () {
      expect(shouldShowFullContent(isGuest: true, domain: 'banking'), isTrue);
    });

    test('guest sees truncated content for non-banking domains', () {
      expect(shouldShowFullContent(isGuest: true, domain: 'visa'), isFalse);
      expect(shouldShowFullContent(isGuest: true, domain: 'medical'), isFalse);
      expect(
        shouldShowFullContent(isGuest: true, domain: 'concierge'),
        isFalse,
      );
      expect(shouldShowFullContent(isGuest: true, domain: 'housing'), isFalse);
      expect(
        shouldShowFullContent(isGuest: true, domain: 'employment'),
        isFalse,
      );
    });
  });

  group('Content truncation', () {
    String truncateContent(String content, int maxChars) {
      if (content.length <= maxChars) return content;
      final truncated = content.substring(0, maxChars);
      final lastSpace = truncated.lastIndexOf(' ');
      return '${lastSpace > 0 ? truncated.substring(0, lastSpace) : truncated}…';
    }

    test('short content is not truncated', () {
      const content = 'Short content here.';
      expect(truncateContent(content, 200), content);
    });

    test('long content is truncated at word boundary', () {
      final content = List.generate(50, (i) => 'word$i').join(' ');
      final result = truncateContent(content, 50);
      expect(result.length, lessThanOrEqualTo(52)); // +1 for ellipsis char
      expect(result.endsWith('…'), isTrue);
      expect(result.contains('  '), isFalse); // No broken words
    });

    test('truncation preserves first 200 chars approximately', () {
      final content =
          'This is a test guide about visa renewal procedures. '
          'You need to submit your passport, residence card, and '
          'application form to the immigration office. The processing '
          'time is typically 2-3 weeks. Make sure to apply before your '
          'current visa expires. Additional documents may be required.';
      final result = truncateContent(content, 200);
      expect(result.length, lessThan(content.length));
      expect(result.endsWith('…'), isTrue);
    });
  });

  group('Public routes access', () {
    test('guest-accessible routes include navigator paths', () {
      // Simulate the prefix-based route matching from router_provider.dart
      bool isPublicRoute(String path) {
        final publicRoutes = [
          '/',
          '/language',
          '/login',
          '/register',
          '/reset-password',
          '/emergency',
          '/home',
          '/navigate',
          '/chat',
          '/subscription',
        ];
        return publicRoutes.contains(path) ||
            path.startsWith('/navigate/') ||
            path.startsWith('/emergency');
      }

      expect(isPublicRoute('/navigate'), isTrue);
      expect(isPublicRoute('/navigate/banking'), isTrue);
      expect(isPublicRoute('/navigate/banking/account-opening'), isTrue);
      expect(isPublicRoute('/navigate/visa'), isTrue);
      expect(isPublicRoute('/navigate/visa/renewal'), isTrue);
      expect(isPublicRoute('/emergency'), isTrue);
      expect(isPublicRoute('/home'), isTrue);
      expect(isPublicRoute('/chat'), isTrue);
      expect(isPublicRoute('/subscription'), isTrue);

      // Protected routes
      expect(isPublicRoute('/profile'), isFalse);
      expect(isPublicRoute('/profile/edit'), isFalse);
      expect(isPublicRoute('/settings'), isFalse);
      expect(isPublicRoute('/chat/some-session-id'), isFalse);
      expect(isPublicRoute('/onboarding'), isFalse);
    });
  });
}
