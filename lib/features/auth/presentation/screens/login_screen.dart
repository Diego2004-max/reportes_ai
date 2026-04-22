import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:reportes_ai/app/router/app_router.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/state/auth_provider.dart';
import 'package:reportes_ai/state/session_provider.dart';
import 'package:reportes_ai/shared/widgets/brand_logo.dart';
import 'package:reportes_ai/shared/widgets/vial_card.dart';
import 'package:reportes_ai/shared/widgets/vial_text_field.dart';
import 'package:reportes_ai/shared/widgets/vial_button.dart';

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 100),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    _BrandHeader(),
                    const SizedBox(height: 48),
                    VialCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          VialTextField(
                            label: 'Correo electrónico',
                            hint: 'usuario@ejemplo.com',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.outline),
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
                          const SizedBox(height: 20),
                          VialTextField(
                            label: 'Contraseña',
                            hint: '••••••••',
                            controller: _passwordCtrl,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.outline),
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
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          VialButton(
                            onPressed: _onLogin,
                            text: 'Iniciar sesión',
                            isLoading: _isLoading,
                          ),
                           
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(height: 1, color: AppColors.surfaceContainerHighest),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'o continuar con',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.outline,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(height: 1, color: AppColors.surfaceContainerHighest),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          VialButton(
                            isSecondary: true,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Google Sign-In próximamente.'),
                                ),
                              );
                            },
                            text: 'Google',
                            icon: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuA4M3h0fwvW9FNN239hABmil0c7p8A_TfNbQvt_Ks4ikfiBd5c-gdeRFRvmK5GnIlYc2qkKpA8iyTwZUFBZz-vvvK0_QS-8B1xzcZaSgFN241xZupqcMmIu0rtGIAZEPyOecC4Dt9d-fwf4SeoVXDuJedMh7TSH_nLSmsVtcSXsbtb2MwUlI6SIURrWe0mMlUvsTVUmgxiWMSke4Ql59A-hZdVg0o0OvdbPQVMrCAEI48djLkcldBveW69cQpZ9XB7-N-E9MB7FFss',
                              width: 20,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: AppColors.textPrimary),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '¿No tienes una cuenta? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: _goToRegister,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Regístrate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
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
    return const Column(
      children: [
        BrandLogo(size: 68),
        SizedBox(height: 24),
        Text(
          'VialAI',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Reporta · Predice · Protege',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.textSecondary,
            letterSpacing: 0.25,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}