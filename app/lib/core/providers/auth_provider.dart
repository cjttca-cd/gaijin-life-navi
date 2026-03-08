import 'package:flutter/foundation.dart' show debugPrint;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the [FirebaseAuth] instance.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// StreamProvider that emits the current Firebase Auth state.
/// Returns the [User] if signed in, or null if signed out.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Whether the user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull != null;
});

/// Whether the current user is an anonymous (guest) user.
final isAnonymousProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.isAnonymous ?? false;
});

/// Sign in anonymously (for guest chat access).
/// Returns the [User] on success, or null on failure (with error logged).
Future<User?> signInAnonymously(FirebaseAuth auth) async {
  try {
    final credential = await auth.signInAnonymously();
    debugPrint('[Auth] Anonymous sign-in succeeded: uid=\${credential.user?.uid}');
    return credential.user;
  } catch (e) {
    debugPrint('[Auth] Anonymous sign-in failed: \$e\n\$st');
    return null;
  }
}
