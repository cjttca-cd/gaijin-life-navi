import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/nationalities.dart';
import '../../../data/regions.dart';
import '../../../data/residence_statuses.dart';

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

  // Profile fields.
  NationalityItem? _selectedNationality;
  ResidenceStatusItem? _selectedResidenceStatus;
  Prefecture? _selectedPrefecture;

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
      // Step 1: Firebase Auth — create user.
      final credential = await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Step 2: Backend register API — create profile.
      if (credential.user != null) {
        try {
          final apiClient = createApiClient();
          await apiClient.post<Map<String, dynamic>>(
            '/auth/register',
            data: {
              'display_name': _emailController.text.trim().split('@').first,
              'preferred_language': 'en',
              'nationality': _selectedNationality!.code,
              'residence_status': _selectedResidenceStatus!.id,
              'residence_region': _selectedPrefecture!.nameEn,
            },
          );
        } on DioException {
          // Backend register failed but Firebase user was created.
          // Profile can be completed later via onboarding/profile edit.
          // Don't block the registration flow.
        }
      }

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

  /// Show a searchable bottom sheet for selecting from a list of items.
  Future<T?> _showSearchableBottomSheet<T>({
    required String title,
    required String searchHint,
    required List<T> items,
    required String Function(T) labelBuilder,
    String Function(T)? subtitleBuilder,
    List<T>? priorityItems,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _SearchableList<T>(
          title: title,
          searchHint: searchHint,
          items: items,
          labelBuilder: labelBuilder,
          subtitleBuilder: subtitleBuilder,
          priorityItems: priorityItems,
        );
      },
    );
  }

  Future<void> _selectNationality() async {
    final l10n = AppLocalizations.of(context);
    final result = await _showSearchableBottomSheet<NationalityItem>(
      title: l10n.registerNationalityLabel,
      searchHint: l10n.registerSearchHint,
      items: nationalities,
      labelBuilder: (item) => '${item.name} (${item.code})',
    );
    if (result != null) {
      setState(() => _selectedNationality = result);
    }
  }

  Future<void> _selectResidenceStatus() async {
    final l10n = AppLocalizations.of(context);
    final commonStatuses =
        residenceStatuses.where((s) => s.common).toList();
    final result = await _showSearchableBottomSheet<ResidenceStatusItem>(
      title: l10n.registerResidenceStatusLabel,
      searchHint: l10n.registerSearchHint,
      items: residenceStatuses,
      labelBuilder: (item) => item.nameEn,
      subtitleBuilder: (item) => item.nameJa,
      priorityItems: commonStatuses,
    );
    if (result != null) {
      setState(() => _selectedResidenceStatus = result);
    }
  }

  Future<void> _selectResidenceRegion() async {
    final l10n = AppLocalizations.of(context);
    final result = await _showSearchableBottomSheet<Prefecture>(
      title: l10n.registerResidenceRegionLabel,
      searchHint: l10n.registerSearchHint,
      items: prefectures,
      labelBuilder: (item) => item.nameEn,
      subtitleBuilder: (item) => item.nameJa,
    );
    if (result != null) {
      setState(() => _selectedPrefecture = result);
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

                    // ── Profile fields ──────────────────────────────

                    // Nationality.
                    _SelectableFormField(
                      labelText: l10n.registerNationalityLabel,
                      hintText: l10n.registerNationalityHint,
                      icon: Icons.flag_outlined,
                      value: _selectedNationality != null
                          ? '${_selectedNationality!.name} (${_selectedNationality!.code})'
                          : null,
                      onTap: _selectNationality,
                      validator: (_) {
                        if (_selectedNationality == null) {
                          return l10n.registerNationalityHint;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Residence Status.
                    _SelectableFormField(
                      labelText: l10n.registerResidenceStatusLabel,
                      hintText: l10n.registerResidenceStatusHint,
                      icon: Icons.badge_outlined,
                      value: _selectedResidenceStatus?.nameEn,
                      onTap: _selectResidenceStatus,
                      validator: (_) {
                        if (_selectedResidenceStatus == null) {
                          return l10n.registerResidenceStatusHint;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),

                    // Residence Region.
                    _SelectableFormField(
                      labelText: l10n.registerResidenceRegionLabel,
                      hintText: l10n.registerResidenceRegionHint,
                      icon: Icons.location_on_outlined,
                      value: _selectedPrefecture != null
                          ? '${_selectedPrefecture!.nameEn} (${_selectedPrefecture!.nameJa})'
                          : null,
                      onTap: _selectResidenceRegion,
                      validator: (_) {
                        if (_selectedPrefecture == null) {
                          return l10n.registerResidenceRegionHint;
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

/// A tappable form field that shows a selected value or hint.
class _SelectableFormField extends FormField<String> {
  _SelectableFormField({
    required String labelText,
    required String hintText,
    required IconData icon,
    String? value,
    required VoidCallback onTap,
    required FormFieldValidator<String> validator,
  }) : super(
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<String> state) {
            final context = state.context;
            final cs = Theme.of(context).colorScheme;
            final tt = Theme.of(context).textTheme;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: labelText,
                      hintText: hintText,
                      prefixIcon: Icon(icon),
                      suffixIcon:
                          const Icon(Icons.arrow_drop_down),
                      errorText: state.errorText,
                    ),
                    child: value != null
                        ? Text(
                            value,
                            style: tt.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            hintText,
                            style: tt.bodyLarge?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        );
}

/// Searchable bottom sheet list used for nationality / status / region pickers.
class _SearchableList<T> extends StatefulWidget {
  const _SearchableList({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.labelBuilder,
    this.subtitleBuilder,
    this.priorityItems,
  });

  final String title;
  final String searchHint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String Function(T)? subtitleBuilder;
  final List<T>? priorityItems;

  @override
  State<_SearchableList<T>> createState() => _SearchableListState<T>();
}

class _SearchableListState<T> extends State<_SearchableList<T>> {
  final _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _buildOrderedList(widget.items);
    _searchController.addListener(_onSearch);
  }

  List<T> _buildOrderedList(List<T> items) {
    if (widget.priorityItems == null || widget.priorityItems!.isEmpty) {
      return items;
    }
    final prioritySet = widget.priorityItems!.toSet();
    final priority = items.where((i) => prioritySet.contains(i)).toList();
    final rest = items.where((i) => !prioritySet.contains(i)).toList();
    return [...priority, ...rest];
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredItems = _buildOrderedList(widget.items));
      return;
    }
    setState(() {
      _filteredItems = widget.items.where((item) {
        final label = widget.labelBuilder(item).toLowerCase();
        final subtitle =
            widget.subtitleBuilder?.call(item).toLowerCase() ?? '';
        return label.contains(query) || subtitle.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            children: [
              // Handle.
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title.
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title,
                  style: tt.titleMedium,
                ),
              ),
              // Search field.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // List.
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    final label = widget.labelBuilder(item);
                    final subtitle = widget.subtitleBuilder?.call(item);
                    return ListTile(
                      title: Text(label),
                      subtitle: subtitle != null ? Text(subtitle) : null,
                      onTap: () => Navigator.of(context).pop(item),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
