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
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class LessonCard extends StatelessWidget {
  final CourseModel course;

  const LessonCard({Key? key, required this.course}) : super(key: key);

  Future<void> _downloadAndOpenPdf(BuildContext context) async {
    final token = await UserStorage
        .getToken(); // sesuaikan dengan tempat kamu simpan token
    final url =
        'https://ocean-learn-api.rplrus.com/api/v1/courses/${course.id}/download';

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/lesson_${course.id}.pdf');
          await file.writeAsBytes(bytes);

          // Check if file exists and is accessible before opening
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
                  Text(DateFormat('MMMM d yyyy').format(course.date),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                decoration: BoxDecoration(
                  color: secondarycolor,
                  border: Border.all(color: primarycolor, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ScanQRPage());
                  },
                  child: Text(
                    "Attendance",
                    style: GoogleFonts.poppins(
                      color: textcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
