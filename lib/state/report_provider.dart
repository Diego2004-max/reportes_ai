import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/data/repositories/report_repository_impl.dart';
import 'package:reportes_ai/state/session_provider.dart';

final reportRepositoryProvider = Provider<ReportRepositoryImpl>((ref) {
  return ReportRepositoryImpl();
});

class ReportRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void refresh() {
    state++;
  }
}

final reportRefreshProvider =
    NotifierProvider<ReportRefreshNotifier, int>(ReportRefreshNotifier.new);

void refreshReports(WidgetRef ref) {
  ref.read(reportRefreshProvider.notifier).refresh();
}

class ReportStats {
  final int total;
  final int submitted;
  final int reviewing;
  final int attended;

  const ReportStats({
    required this.total,
    required this.submitted,
    required this.reviewing,
    required this.attended,
  });
}

final allReportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  ref.watch(reportRefreshProvider);
  return ref.read(reportRepositoryProvider).getAllReports();
});

final userReportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  ref.watch(reportRefreshProvider);

  final session = ref.watch(sessionProvider);
  final userId = session.userId;

  if (!session.isAuthenticated || userId == null) {
    return [];
  }

  return ref.read(reportRepositoryProvider).getReportsByUserId(userId);
});

final recentUserReportsProvider =
    FutureProvider.family<List<ReportModel>, int>((ref, limit) async {
  final reports = await ref.watch(userReportsProvider.future);

  if (reports.length <= limit) {
    return reports;
  }

  return reports.take(limit).toList();
});

final userReportStatsProvider = FutureProvider<ReportStats>((ref) async {
  final reports = await ref.watch(userReportsProvider.future);

  return ReportStats(
    total: reports.length,
    submitted:
        reports.where((r) => r.status == UserReportStatus.submitted).length,
    reviewing:
        reports.where((r) => r.status == UserReportStatus.reviewing).length,
    attended:
        reports.where((r) => r.status == UserReportStatus.attended).length,
  );
});