import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/shared/widgets/report_card.dart';
import 'package:reportes_ai/state/report_provider.dart';

import 'report_detail_screen.dart';

class ReportListScreen extends ConsumerStatefulWidget {
  const ReportListScreen({super.key});

  @override
  ConsumerState<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends ConsumerState<ReportListScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedFilter = 'Todos';
  String _searchQuery = '';
  bool _isSearching = false;

  static const List<String> _filters = [
    'Todos',
    'Pendiente',
    'Verificado',
    'Rechazado',
  ];

  List<ReportModel> _applyFilters(List<ReportModel> reports) {
    return reports.where((report) {
      final statusMapped = _mapStatus(report.status);
      final matchesFilter =
          _selectedFilter == 'Todos' || statusMapped == _selectedFilter;

      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          report.title.toLowerCase().contains(query) ||
          report.category.toLowerCase().contains(query) ||
          report.description.toLowerCase().contains(query) ||
          (report.locationLabel?.toLowerCase().contains(query) ?? false);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  String _mapStatus(String originalStatus) {
    final lower = originalStatus.toLowerCase();
    if (lower.contains('pendiente') || lower.contains('revisión') || lower.contains('enviado')) return 'Pendiente';
    if (lower.contains('verific') || lower.contains('atendido')) return 'Verificado';
    if (lower.contains('rechaz') || lower.contains('error')) return 'Rechazado';
    return originalStatus;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(allReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withAlpha(200),
            border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHighest)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded,
              color: AppColors.primary, size: 22),
          onPressed: () {},
        ),
        title: const Text(
          'VialAI',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded, color: AppColors.primary),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchCtrl.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'PU',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isSearching)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: AppColors.surfaceContainerLowest,
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Buscar reportes...',
                    hintStyle: const TextStyle(color: AppColors.outline),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis reportes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gestiona y revisa el estado de tus incidencias reportadas.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Chips filter
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected ? null : Border.all(color: AppColors.outline.withAlpha(50)),
                        boxShadow: isSelected
                            ? [BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 8, offset: const Offset(0, 2))]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reportsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Error',
                  subtitle: error.toString(),
                ),
                data: (reports) {
                  final filteredReports = _applyFilters(reports);

                  if (filteredReports.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.article_outlined,
                      title: 'No hay reportes',
                      subtitle: 'No se encontraron incidencias con estos filtros.',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      refreshReports(ref);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];

                        return ReportCard(
                          title: report.title,
                          description: report.locationLabel ?? report.description,
                          status: _mapStatus(report.status),
                          date: '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                          category: report.category,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportDetailScreen(report: report),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}