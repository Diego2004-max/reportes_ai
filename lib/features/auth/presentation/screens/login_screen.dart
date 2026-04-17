import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:reportes_ai/app/router/app_router.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/shared/widgets/custom_textfield.dart';
import 'package:reportes_ai/shared/widgets/primary_button.dart';
import 'package:reportes_ai/state/auth_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final user = await ref.read(authRepositoryProvider).login(
            email: _emailCtrl.text,
            password: _passwordCtrl.text,
          );

      await ref.read(sessionProvider.notifier).saveLocalSession(
            userId: user.id,
            email: user.email,
            userName: user.fullName,
          );

      if (!mounted) return;
      context.go(AppRoutes.app);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 100),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.huge),
                    _BrandHeader(),
                    const SizedBox(height: AppSpacing.xxxl),
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
                          Text(
                            'Bienvenido',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Inicia sesión para continuar',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu correo';
                              }
                              final emailReg = RegExp(
                                r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$',
                              );
                              if (!emailReg.hasMatch(value)) {
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
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              if (value.length < 6) {
                                return 'Mínimo 6 caracteres';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _onLogin(),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          PrimaryButton(
                            label: 'Iniciar Sesión',
                            onPressed: _onLogin,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.border),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                child: Text(
                                  'o continúa con',
                                  style: theme.textTheme.labelMedium,
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.border),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _GoogleSignInButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Google Sign-In se conecta en el siguiente bloque.',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xl,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: _goToRegister,
                            child: const Text('Regístrate'),
                          ),
                        ],
                      ),
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

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: const Icon(
            Icons.assessment_rounded,
            color: AppColors.textOnPrimary,
            size: 36,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Reportes AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Gestión inteligente de reportes',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        child: const Text('Continuar con Google'),
      ),
    );
  }
}