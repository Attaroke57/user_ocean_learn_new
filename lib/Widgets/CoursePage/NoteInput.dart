import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class NoteInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NoteInput({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    color: secondarycolor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primarycolor, width: 1.5),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onSave,
                      child: Center(
                        child: Text(
                          "Save note",
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
              ),
              const SizedBox(width: 16),
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: secondarycolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primarycolor, width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onCancel,
                    child: Icon(
                      Icons.close, 
                      color: textcolor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Write note here",
                hintStyle: GoogleFonts.poppins(
                  color: textcolor.withOpacity(0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 3,
              style: GoogleFonts.poppins(
                color: textcolor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}