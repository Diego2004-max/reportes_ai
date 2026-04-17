import 'package:uuid/uuid.dart';

import 'package:reportes_ai/data/local/hive/hive_service.dart';
import 'package:reportes_ai/data/models/report_model.dart';

abstract final class UserReportStatus {
  static const String submitted = 'Enviado';
  static const String reviewing = 'En revisión';
  static const String attended = 'Atendido';
}

class ReportRepositoryImpl {
  final Uuid _uuid = const Uuid();

  Future<ReportModel> createReport({
    required String userId,
    required String title,
    required String description,
    required String category,
    String status = UserReportStatus.submitted,
    String? locationLabel,
    double? latitude,
    double? longitude,
    List<String> imagePaths = const [],
    String? audioPath,
  }) async {
    final report = ReportModel(
      id: _uuid.v4(),
      userId: userId,
      title: title.trim(),
      description: description.trim(),
      category: category,
      status: status,
      createdAt: DateTime.now(),
      locationLabel: locationLabel,
      latitude: latitude,
      longitude: longitude,
      imagePaths: imagePaths,
      audioPath: audioPath,
    );

    await HiveService.reportsBox.put(report.id, report.toMap());
    return report;
  }

  Future<List<ReportModel>> getReportsByUserId(String userId) async {
    final reports = HiveService.reportsBox.values
        .map(
          (raw) => ReportModel.fromMap(
            Map<String, dynamic>.from(raw as Map),
          ),
        )
        .where((report) => report.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return reports;
  }

  Future<void> deleteReport(String reportId) async {
    await HiveService.reportsBox.delete(reportId);
  }
}