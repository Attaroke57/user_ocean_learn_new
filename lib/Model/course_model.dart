class CourseModel {
  final String id;
  final String title;
  final String description;
  final String filePath;
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
    required this.filePath,
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

  final isLockedFromApiRaw = data['is_locked'] ?? false;
  final isLockedFromApi = isLockedFromApiRaw is bool
      ? isLockedFromApiRaw
      : (isLockedFromApiRaw.toString() == '1' || isLockedFromApiRaw.toString().toLowerCase() == 'true');

  // Kalau visitor, semua lesson yang dikunci akan tetap terkunci
  final lockedValue = userRole.toLowerCase() == 'visitor'
      ? true
      : isLockedFromApi;

  print('DEBUG isLockedFromApiRaw: $isLockedFromApiRaw, isLockedFromApi: $isLockedFromApi, userRole: $userRole');

  return CourseModel(
    id: json['id'].toString(),
    title: data['title'] ?? '',
    description: data['description'] ?? '',
    filePath: data['file_path'] ?? '',
    date: DateTime.tryParse(dateData['class_date'] ?? '') ?? DateTime.now(),
    releaseDate: release,
    qrCode: qrData['qr_code'],
    qrEndDate: DateTime.tryParse(qrData['end_at'] ?? ''),
    note: data['note'] ?? '',
    isLocked: lockedValue,
  );
}


}
