import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/shared/widgets/custom_app_bar.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/shared/widgets/loading_widget.dart';
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

  static const List<String> _filters = [
    'Todos',
    'Enviado',
    'En revisión',
    'Atendido',
  ];

  List<ReportModel> _applyFilters(List<ReportModel> reports) {
    return reports.where((report) {
      final matchesFilter =
          _selectedFilter == 'Todos' || report.status == _selectedFilter;

      final query = _searchQuery.toLowerCase();
      final matchesSearch = query.isEmpty ||
          report.title.toLowerCase().contains(query) ||
          report.category.toLowerCase().contains(query);

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
    final reportsAsync = ref.watch(userReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Mis reportes',
        subtitle: 'Historial personal',
      ),
      body: Column(
        children: [
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
                TextField(
                  controller: _searchCtrl,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Buscar reportes...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
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
                        onSelected: (value) {
                          setState(() => _selectedFilter = filter);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: reportsAsync.when(
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.screenH),
                itemCount: 4,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: LoadingListItem(),
                ),
              ),
              error: (error, stackTrace) => EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Error',
                subtitle: error.toString(),
              ),
              data: (reports) {
                final filteredReports = _applyFilters(reports);

                if (filteredReports.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.article_outlined,
                    title: 'Aún no tienes reportes',
                    subtitle:
                        'Cuando crees tu primer reporte, aparecerá aquí.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(userReportsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.screenH),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];

                      return ReportCard(
                        title: report.title,
                        description: report.description,
                        status: report.status,
                        date:
                            '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
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
    );
  }
}