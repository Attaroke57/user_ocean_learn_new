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

    // PERBAIKAN UTAMA: Logic locking yang lebih jelas
    bool finalLockStatus = false;
    
    // Jika visitor, semua lesson selalu terkunci
    if (userRole.toLowerCase() == 'visitor') {
      finalLockStatus = true;
    } 
    // Jika user basic/free dan lesson dari API dikunci, tetap dikunci
    else if ((userRole.toLowerCase() == 'basic' || userRole.toLowerCase() == 'student') && isLockedFromApi) {
      finalLockStatus = true;
    }
    // Jika user premium/pro, ikuti status dari API
    else if (userRole.toLowerCase() == 'premium' || userRole.toLowerCase() == 'pro' || userRole.toLowerCase() == 'member') {
      finalLockStatus = isLockedFromApi;
    }
    // Default: ikuti status dari API
    else {
      finalLockStatus = isLockedFromApi;
    }

    print('=== COURSE MODEL DEBUG ===');
    print('Title: ${data['title']}');
    print('Raw isLocked from API: $isLockedFromApiRaw');
    print('Parsed isLocked from API: $isLockedFromApi');
    print('User Role: $userRole');
    print('Final Lock Status: $finalLockStatus');
    print('==========================');

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
      isLocked: finalLockStatus,
    );
  }
}