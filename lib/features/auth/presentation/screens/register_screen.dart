import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/custom_textfield.dart';
import 'package:reportes_ai/shared/widgets/primary_button.dart';

/// Register screen — same design language as LoginScreen.
/// UI only: no real auth logic yet.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Crear cuenta',
        showBack: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Únete a Reportes AI',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Completa el formulario para registrarte',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xxl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Nombre completo',
                        hint: 'Juan Pérez',
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          if (v.trim().length < 3) {
                            return 'Mínimo 3 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      CustomTextField(
                        label: 'Correo electrónico',
                        hint: 'tu@correo.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Ingresa tu correo';
                          }
                          final emailReg = RegExp(
                            r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                          );
                          if (!emailReg.hasMatch(v)) {
                            return 'Correo no válido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      CustomTextField(
                        label: 'Contraseña',
                        hint: '••••••••',
                        controller: _passwordCtrl,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Ingresa una contraseña';
                          }
                          if (v.length < 8) {
                            return 'Mínimo 8 caracteres';
                          }
                          final hasUpper = v.contains(RegExp(r'[A-Z]'));
                          final hasDigit = v.contains(RegExp(r'[0-9]'));
                          if (!hasUpper || !hasDigit) {
                            return 'Incluye mayúscula y número';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      CustomTextField(
                        label: 'Confirmar contraseña',
                        hint: '••••••••',
                        controller: _confirmCtrl,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Confirma tu contraseña';
                          }
                          if (v != _passwordCtrl.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _onRegister(),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _PasswordHint(),

                      const SizedBox(height: AppSpacing.xl),

                      PrimaryButton(
                        label: 'Crear cuenta',
                        onPressed: _onRegister,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes cuenta? ',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Inicia sesión'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'La contraseña debe tener al menos 8 caracteres, '
              'una mayúscula y un número.',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}