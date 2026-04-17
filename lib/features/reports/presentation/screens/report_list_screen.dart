import 'package:flutter/material.dart';
import '../../../../shared/widgets/report_card.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_widget.dart';
import 'report_detail_screen.dart';
import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';

/// Report List screen with search bar, filter chip row, and scrollable cards.
/// UI only — no backend or navigation logic.
class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedFilter = 'Todos';
  final bool _isLoading = false;
  String _searchQuery = '';

  static const List<String> _filters = [
    'Todos',
    'Pendiente',
    'En Proceso',
    'Resuelto',
    'Rechazado',
  ];

  static const List<Map<String, String>> _allReports = [
    {
      'title': 'Bache en Avenida Principal',
      'description':
          'Gran bache en la vía principal que afecta la circulación vehicular.',
      'status': 'En Proceso',
      'date': '24 Mar 2026',
      'category': 'Infraestructura',
    },
    {
      'title': 'Fuga de agua en Calle 5',
      'description': 'Tubería rota generando acumulación de agua.',
      'status': 'Pendiente',
      'date': '23 Mar 2026',
      'category': 'Servicios Públicos',
    },
    {
      'title': 'Luminaria dañada Parque Central',
      'description': 'Alumbrado público sin funcionamiento en el parque.',
      'status': 'Resuelto',
      'date': '21 Mar 2026',
      'category': 'Alumbrado',
    },
    {
      'title': 'Basura acumulada Cra 12',
      'description': 'Acumulación de residuos sólidos sin recolectar.',
      'status': 'Pendiente',
      'date': '20 Mar 2026',
      'category': 'Aseo',
    },
    {
      'title': 'Semáforo averiado Calle 15',
      'description': 'El semáforo no funciona generando riesgo vial.',
      'status': 'Rechazado',
      'date': '19 Mar 2026',
      'category': 'Tránsito',
    },
    {
      'title': 'Árbol caído Barrio Norte',
      'description': 'Árbol caído bloqueando la vía principal del barrio.',
      'status': 'Resuelto',
      'date': '18 Mar 2026',
      'category': 'Espacio Público',
    },
  ];

  List<Map<String, String>> get _filteredReports {
    return _allReports.where((r) {
      final matchesFilter =
          _selectedFilter == 'Todos' || r['status'] == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          r['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reports = _filteredReports;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reportes',
        subtitle: '${_allReports.length} reportes en total',
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
            tooltip: 'Ordenar',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search + filter bar ──────────────────────────────────────────
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.md,
              AppSpacing.screenH,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Buscar reportes…',
                    hintStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textDisabled),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.close_rounded, size: 20),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Filter chips row
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final selected = _selectedFilter == filter;
                      return FilterChip(
                        label: Text(filter),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedFilter = filter),
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.infoLight,
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.screenH,
                      right: AppSpacing.screenH,
                      top: AppSpacing.screenH,
                      bottom: 120.0,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: LoadingListItem(),
                    ),
                  )
                : reports.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'Sin resultados',
                        subtitle:
                            'No se encontraron reportes con ese filtro o búsqueda.',
                        actionLabel: 'Limpiar filtros',
                        onAction: () {
                          _searchCtrl.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedFilter = 'Todos';
                          });
                        },
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async =>
                            await Future.delayed(
                                const Duration(milliseconds: 800)),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.screenH,
                            right: AppSpacing.screenH,
                            top: AppSpacing.screenH,
                            bottom: 120.0,
                          ),
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            final r = reports[index];
                            return ReportCard(
                              title: r['title']!,
                              description: r['description']!,
                              status: r['status']!,
                              date: r['date']!,
                              category: r['category'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ReportDetailScreen()),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
