import 'dart:convert';
import 'package:http/http.dart' as http;

class QRService {
  static const String baseUrl = 'https://api.momentumoceanlearn.com/api/v1';

  // Check attendance status
  static Future<Map<String, dynamic>> checkAttendanceStatus(String courseId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendence/check/$courseId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Berhasil mengecek status kehadiran'
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengecek status kehadiran: ${response.statusCode}',
          'error': response.body
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'error': e.toString()
      };
    }
  }

  // Scan QR Code dan kirim ke API
  static Future<Map<String, dynamic>> scanQR(String qrData, String token) async {
  try {
    // Kalau qrData berisi full URL, ambil param qr_data
    String qrValue;
    if (qrData.contains("qr_data=")) {
      Uri uri = Uri.parse(qrData);
      qrValue = uri.queryParameters['qr_data'] ?? "";
    } else {
      qrValue = qrData;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/scan?qr_data=$qrValue'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'success': true,
        'data': data,
        'message': 'QR berhasil di-scan'
      };
    } else {
      return {
        'success': false,
        'message': 'Gagal mengirim data QR: ${response.statusCode}',
        'error': response.body
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error: $e',
      'error': e.toString()
    };
  }
}


  // Validasi format QR (opsional)
  static bool isValidQRFormat(String qrData) {
    if (qrData.isEmpty) return false;

    // Tambahkan validasi sesuai format QR yang diharapkan
    // Contoh: cek apakah berisi URL, atau format khusus
    return qrData.length > 3;
  }
  
}