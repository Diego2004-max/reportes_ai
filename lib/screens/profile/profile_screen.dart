import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_card.dart';

/// App settings and user profile screen.
/// Shows user info header, stats row, and a list of menu options.
/// UI only — no backend logic.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ── Mock User Data ────────────────────────────────────────────────────────
  static const _mockName = 'Juan Pérez';
  static const _mockEmail = 'juan.perez@email.com';
  static const _mockMemberSince = 'Miembro desde Ene 2026';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Mi Perfil',
        subtitle: 'Configuración de cuenta',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH, vertical: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header: Avatar & User Info ──────────────────────────────────
            AppCard(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(60),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _mockName.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(_mockName, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(_mockEmail, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      _mockMemberSince,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── User Stats Row ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ProfileStatTile(
                    label: 'Mis Reportes',
                    value: '12',
                    icon: Icons.article_outlined,
                    color: AppColors.primary,
                    bgColor: AppColors.infoLight,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ProfileStatTile(
                    label: 'Resueltos',
                    value: '9',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    bgColor: AppColors.successLight,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ProfileStatTile(
                    label: 'Puntos',
                    value: '350',
                    icon: Icons.star_outline_rounded,
                    color: AppColors.warning,
                    bgColor: AppColors.warningLight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Menu List ───────────────────────────────────────────────────
            Text('Ajustes Generales',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuListItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Editar Perfil',
                    onTap: () {},
                  ),
                  const Divider(),
                  _MenuListItem(
                    icon: Icons.article_outlined,
                    title: 'Mis Reportes Registrados',
                    onTap: () {},
                  ),
                  const Divider(),
                  _MenuListItem(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () {},
                  ),
                  const Divider(),
                  _MenuListItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Ayuda y Soporte',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Logout Button ───────────────────────────────────────────────
            AppCard(
              padding: EdgeInsets.zero,
              child: _MenuListItem(
                icon: Icons.logout_rounded,
                title: 'Cerrar Sesión',
                iconColor: AppColors.error,
                textColor: AppColors.error,
                showArrow: false,
                onTap: () {
                  // TODO: Perform logout logic
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  const _MenuListItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDestructive = textColor == AppColors.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: isDestructive
            ? AppColors.errorLight.withAlpha(50)
            : AppColors.primaryLight.withAlpha(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor ?? AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textDisabled,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
