import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_ocean_learn/Model/course_model.dart';
import 'package:user_ocean_learn/Page/QrScannerPage/QrScannerPage.dart';
import 'package:user_ocean_learn/Services/QrService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class LessonCard extends StatefulWidget {
  final CourseModel course;

  const LessonCard({Key? key, required this.course}) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _isCheckingAttendance = false;
  bool _hasAttended = false;
  String? _attendanceTime;

  @override
  void initState() {
    super.initState();
    _checkAttendanceStatus();
  }

  Future<void> _checkAttendanceStatus() async {
    setState(() {
      _isCheckingAttendance = true;
    });

    final token = await UserStorage.getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isCheckingAttendance = false;
      });
      return;
    }

    try {
      final response = await QRService.checkAttendanceStatus(widget.course.id, token);
      
      if (response['success']) {
        final data = response['data'];
        final status = data['data']['status'];
        final attendanceTime = data['data']['attendance_time'];
        
        setState(() {
          _hasAttended = status == 'present';
          _attendanceTime = attendanceTime;
        });
      }
    } catch (e) {
      print('Error checking attendance: $e');
    }

    setState(() {
      _isCheckingAttendance = false;
    });
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Sudah Absen',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda sudah melakukan absensi untuk kelas ini.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              if (_attendanceTime != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Waktu Absen: $_attendanceTime',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: primarycolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleAttendanceButtonTap() {
    if (_hasAttended) {
      _showAttendanceDialog();
    } else {
      Get.to(() => ScanQRPage());
    }
  }

  Future<void> _downloadAndOpenPdf(BuildContext context) async {
    final token = await UserStorage.getToken();
    final url = 'https://api.momentumoceanlearn.com/api/v1/courses/${widget.course.id}/download';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/lesson_${widget.course.id}.pdf');
        await file.writeAsBytes(bytes);

        if (await file.exists()) {
          final result = await OpenFile.open(file.path);
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to open file: ${result.message}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File does not exist after download')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to download PDF: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Incoming Class",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(DateFormat('MMMM d yyyy').format(widget.course.date),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
              _isCheckingAttendance
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(primarycolor),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      decoration: BoxDecoration(
                        color: _hasAttended ? Colors.green.withOpacity(0.1) : secondarycolor,
                        border: Border.all(
                          color: _hasAttended ? Colors.green : primarycolor, 
                          width: 1.5
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: _handleAttendanceButtonTap,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_hasAttended) ...[
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                            ],
                            Text(
                              _hasAttended ? "Attended" : "Attendance",
                              style: GoogleFonts.poppins(
                                color: _hasAttended ? Colors.green : textcolor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              'Assets/images/lesson.svg',
              width: 200,
              height: 140,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: secondarycolor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primarycolor, width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _downloadAndOpenPdf(context),
                borderRadius: BorderRadius.circular(24),
                child: Center(
                  child: Text(
                    "Let's check the lessons!",
                    style: GoogleFonts.poppins(
                      color: textcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}