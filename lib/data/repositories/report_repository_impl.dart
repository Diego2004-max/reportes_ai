import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:reportes_ai/data/models/report_model.dart';

abstract final class UserReportStatus {
  static const String submitted = 'Enviado';
  static const String reviewing = 'En revisión';
  static const String attended = 'Atendido';
}

class ReportRepositoryImpl {
  final SupabaseClient _client = Supabase.instance.client;

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
    final cleanDescription = description.trim();
    final cleanTitle = title.trim().isEmpty
        ? _buildFallbackTitle(cleanDescription)
        : title.trim();

    final inserted = await _client
        .from('reports')
        .insert({
          'user_id': userId,
          'title': cleanTitle,
          'description': cleanDescription,
          'category': category,
          'status': status,
          'location_label': locationLabel,
          'latitude': latitude,
          'longitude': longitude,
          'image_url': imagePaths.isNotEmpty ? imagePaths.first : null,
          'audio_url': audioPath,
        })
        .select()
        .single();

    return _fromRow(inserted);
  }

  Future<List<ReportModel>> getReportsByUserId(String userId) async {
    final rows = await _client
        .from('reports')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((row) => _fromRow(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  Future<List<ReportModel>> getAllReports() async {
    final rows = await _client
        .from('reports')
        .select()
        .order('created_at', ascending: false);

    return (rows as List)
        .map((row) => _fromRow(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  Future<void> deleteReport(String reportId) async {
    await _client.from('reports').delete().eq('id', reportId);
  }

  ReportModel _fromRow(Map<String, dynamic> row) {
    final imageUrl = row['image_url'] as String?;

    return ReportModel(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      category: row['category'] as String,
      status: row['status'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      locationLabel: row['location_label'] as String?,
      latitude: (row['latitude'] as num?)?.toDouble(),
      longitude: (row['longitude'] as num?)?.toDouble(),
      imagePaths: imageUrl != null && imageUrl.isNotEmpty ? [imageUrl] : const [],
      audioPath: row['audio_url'] as String?,
    );
  }

  String _buildFallbackTitle(String description) {
    final clean = description.trim().replaceAll('\n', ' ');

    if (clean.isEmpty) {
      return 'Reporte ciudadano';
    }

    final words = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final short = words.take(5).join(' ');

    if (short.isEmpty) {
      return 'Reporte ciudadano';
    }

    return short[0].toUpperCase() + short.substring(1);
  }
}