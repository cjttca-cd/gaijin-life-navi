import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_spacing.dart';

/// Register screen (S04) — handoff-auth.md spec.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showSnackBar(AppLocalizations.of(context).registerErrorTermsRequired);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Router redirect handles navigation to onboarding/home.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final msg = switch (e.code) {
        'email-already-in-use' => l10n.registerErrorEmailInUse,
        'invalid-email' => l10n.registerErrorEmailInvalid,
        'weak-password' => l10n.registerErrorPasswordShort,
        _ => l10n.genericError,
      };
      _showSnackBar(msg);
    } catch (_) {
      if (mounted) _showSnackBar(AppLocalizations.of(context).genericError);
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                    const SizedBox(height: AppSpacing.spaceLg),
                    Text(
                      l10n.registerTitle,
                      style: tt.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    Text(
                      l10n.registerSubtitle,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.space3xl),
                    // Email.
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: l10n.registerEmailLabel,
                        hintText: l10n.registerEmailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.registerErrorEmailInvalid;
                        }
                        if (!v.contains('@') || !v.contains('.')) {
                          return l10n.registerErrorEmailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),
                    // Password.
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: l10n.registerPasswordLabel,
                        hintText: l10n.registerPasswordHint,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        helperText: l10n.registerPasswordHelper,
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
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.registerErrorPasswordShort;
                        }
                        if (v.length < 8) {
                          return l10n.registerErrorPasswordShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),
                    // Confirm password.
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: l10n.registerConfirmLabel,
                        hintText: l10n.registerConfirmHint,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                              ),
                        ),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return l10n.registerErrorPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceLg),
                    // Terms checkbox.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreedToTerms,
                            onChanged:
                                (v) =>
                                    setState(() => _agreedToTerms = v ?? false),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spaceSm),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                l10n.registerTermsAgree,
                                style: tt.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Open Terms of Service
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(l10n.registerTermsLink),
                              ),
                              Text(
                                ' ${l10n.registerPrivacyAnd} ',
                                style: tt.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Open Privacy Policy
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(l10n.registerPrivacyLink),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space2xl),
                    // Create account button.
                    FilledButton(
                      onPressed: _isLoading ? null : _handleRegister,
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
                              : Text(l10n.registerButton),
                    ),
                    const SizedBox(height: AppSpacing.space2xl),
                    // Sign in link.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.registerHasAccount, style: tt.bodyMedium),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(l10n.registerSignIn),
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
