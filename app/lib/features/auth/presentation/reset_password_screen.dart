import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Password reset screen (S05) — handoff-auth.md spec.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) setState(() => _emailSent = true);
    } on FirebaseAuthException {
      // Always show success to prevent email enumeration.
      if (mounted) setState(() => _emailSent = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).genericError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              child:
                  _emailSent
                      ? _buildSuccessState(l10n, cs, tt)
                      : _buildFormState(l10n, cs, tt),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormState(AppLocalizations l10n, ColorScheme cs, TextTheme tt) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.resetTitle,
            style: tt.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.resetSubtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.space3xl),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: l10n.resetEmailLabel,
              hintText: l10n.resetEmailHint,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l10n.resetErrorEmailInvalid;
              }
              if (!v.contains('@') || !v.contains('.')) {
                return l10n.resetErrorEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.space2xl),
          FilledButton(
            onPressed: _isLoading ? null : _handleResetPassword,
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
                    : Text(l10n.resetButton),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text(l10n.resetBackToLogin),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(
    AppLocalizations l10n,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 64,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        Text(
          l10n.resetSuccessTitle,
          style: tt.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Text(
          l10n.resetSuccessSubtitle(_emailController.text.trim()),
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.space3xl),
        FilledButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(l10n.resetBackToLogin),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() => _emailSent = false);
              _handleResetPassword();
            },
            child: Text(l10n.resetResend),
          ),
        ),
      ],
    );
  }
}
