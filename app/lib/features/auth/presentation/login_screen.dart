import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';

/// Login screen (S03) — handoff-auth.md spec.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Router redirect handles navigation.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final msg = switch (e.code) {
        'invalid-email' => l10n.loginErrorInvalidEmail,
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' => l10n.loginErrorInvalidCredentials,
        'too-many-requests' => l10n.loginErrorTooManyAttempts,
        _ => l10n.loginErrorNetwork,
      };
      _showSnackBar(msg);
    } catch (_) {
      if (mounted) {
        _showSnackBar(AppLocalizations.of(context).loginErrorNetwork);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo.
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.explore,
                          size: 28,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    // App name.
                    Text(
                      'Gaijin Life Navi',
                      style: tt.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.space3xl),
                    // Welcome text.
                    Text(
                      l10n.loginWelcome,
                      style: tt.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    Text(
                      l10n.loginSubtitle,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.space3xl),
                    // Email field.
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: l10n.loginEmailLabel,
                        hintText: l10n.loginEmailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.loginErrorInvalidEmail;
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return l10n.loginErrorInvalidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    // Password field.
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: l10n.loginPasswordLabel,
                        hintText: l10n.loginPasswordHint,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.loginErrorInvalidEmail; // reuse for empty
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    // Forgot password.
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.resetPassword),
                        child: Text(l10n.loginForgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceLg),
                    // Sign in button.
                    FilledButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(l10n.loginButton),
                    ),
                    const SizedBox(height: AppSpacing.space2xl),
                    // Sign up link.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.loginNoAccount, style: tt.bodyMedium),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.register),
                          child: Text(l10n.loginSignUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
