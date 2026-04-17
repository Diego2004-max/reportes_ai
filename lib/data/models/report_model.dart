class ReportModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime createdAt;
  final String? locationLabel;
  final double? latitude;
  final double? longitude;
  final List<String> imagePaths;
  final String? audioPath;

  const ReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.locationLabel,
    this.latitude,
    this.longitude,
    this.imagePaths = const [],
    this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'locationLabel': locationLabel,
      'latitude': latitude,
      'longitude': longitude,
      'imagePaths': imagePaths,
      'audioPath': audioPath,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      locationLabel: map['locationLabel'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      imagePaths: (map['imagePaths'] as List?)?.cast<String>() ?? const [],
      audioPath: map['audioPath'] as String?,
    );
  }
}