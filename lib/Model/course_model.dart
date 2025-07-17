class CourseModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final DateTime date;
  final DateTime? releaseDate;
  final String? qrCode;
  final DateTime? qrEndDate;
  final String note;
  final bool isLocked;
  

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.date,
    this.releaseDate,
    this.qrCode,
    this.qrEndDate,
    this.note = '',
    required this.isLocked,
  });

  factory CourseModel.fromApiJson(Map<String, dynamic> json, String userRole) {
  final data = json['data'] ?? json;
  final dateData = json['date'] ?? {};
  final qrData = json['qr_data'] ?? {};

  final release = DateTime.tryParse(dateData['release_at'] ?? '');
  final now = DateTime.now();

  final isLockedFromApi = data['is_locked'] ?? false;

  // Kalau visitor, semua lesson yang dikunci akan tetap terkunci
  final isLocked = userRole.toLowerCase() == 'visitor'
      ? true
      : isLockedFromApi;

  return CourseModel(
    id: json['id'].toString(),
    title: data['title'] ?? '',
    description: data['description'] ?? '',
    videoUrl: data['video_url'] ?? '',
    date: DateTime.tryParse(dateData['class_date'] ?? '') ?? DateTime.now(),
    releaseDate: release,
    qrCode: qrData['qr_code'],
    qrEndDate: DateTime.tryParse(qrData['end_at'] ?? ''),
    note: data['note'] ?? '',
    isLocked: isLocked,
  );
}


}
