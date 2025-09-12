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
      final response = await http.get(
        Uri.parse('$qrData'),
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

  // Get scan history (jika API mendukung)
  static Future<Map<String, dynamic>> getScanHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/scan/history'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengambil history: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}