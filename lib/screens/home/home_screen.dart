import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/report_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/empty_state.dart';

/// Home (Dashboard) screen.
/// Shows statistics cards, a recent reports section, and the bottom nav bar.
/// UI only — index changes are internal state, no router logic modified.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  // ── Mock data (UI preview only) ───────────────────────────────────────────
  static const List<Map<String, String>> _recentReports = [
    {
      'title': 'Bache en Avenida Principal',
      'description':
          'Gran bache en la vía principal que afecta la circulación de vehículos.',
      'status': 'En Proceso',
      'date': '24 Mar 2026',
      'category': 'Infraestructura',
    },
    {
      'title': 'Fuga de agua en Calle 5',
      'description':
          'Tubería rota generando acumulación de agua en la vía pública.',
      'status': 'Pendiente',
      'date': '23 Mar 2026',
      'category': 'Servicios Públicos',
    },
    {
      'title': 'Luminaria dañada Parque Central',
      'description':
          'Alumbrado público sin funcionamiento en el parque central.',
      'status': 'Resuelto',
      'date': '21 Mar 2026',
      'category': 'Alumbrado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reportes AI',
        subtitle: 'Panel de control',
        actions: [
          IconButton(
            onPressed: () {
              // TODO: open notifications screen
            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Avatar
          _AvatarButton(),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ────────────────────────────────────────────────
              _GreetingHeader(),

              const SizedBox(height: AppSpacing.xxl),

              // ── Stat cards ───────────────────────────────────────────────
              Text('Resumen general',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _StatCardItem(
                      label: 'Total',
                      value: '24',
                      icon: Icons.folder_open_rounded,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.infoLight,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _StatCardItem(
                      label: 'Pendientes',
                      value: '8',
                      icon: Icons.schedule_rounded,
                      iconColor: AppColors.warning,
                      iconBg: AppColors.warningLight,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _StatCardItem(
                      label: 'En Proceso',
                      value: '11',
                      icon: Icons.autorenew_rounded,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.infoLight,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _StatCardItem(
                      label: 'Resueltos',
                      value: '5',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.success,
                      iconBg: AppColors.successLight,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Quick actions ────────────────────────────────────────────
              Text('Acciones rápidas',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Nuevo Reporte',
                      color: AppColors.primary,
                      background: AppColors.infoLight,
                      onTap: () {
                        // TODO: navigate to create report
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.map_outlined,
                      label: 'Ver Mapa',
                      color: AppColors.success,
                      background: AppColors.successLight,
                      onTap: () {
                        // TODO: navigate to map
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.bar_chart_rounded,
                      label: 'Análisis',
                      color: AppColors.warning,
                      background: AppColors.warningLight,
                      onTap: () {
                        // TODO: navigate to analytics
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              // ── Recent reports ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reportes recientes',
                      style:
                          theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      // TODO: navigate to report list
                    },
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ..._recentReports.map(
                (r) => ReportCard(
                  title: r['title']!,
                  description: r['description']!,
                  status: r['status']!,
                  date: r['date']!,
                  category: r['category'],
                  onTap: () {
                    // TODO: navigate to report detail
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: navigate to create report
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nuevo Reporte',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        elevation: 4,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Buenos días! 👋',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Aquí está el resumen de hoy',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to profile
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: const Center(
          child: Text(
            'U',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCardItem extends StatelessWidget {
  const _StatCardItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 120,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
