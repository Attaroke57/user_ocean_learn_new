import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int weekNumber;
  final String date;
  final bool isPast;
  final String title;
  final bool isFreeUser; // ini sebenarnya "isLocked" di UI
  final VoidCallback onViewDetails;

  const ScheduleCard({
    super.key,
    required this.weekNumber,
    required this.date,
    required this.isPast,
    required this.title,
    required this.isFreeUser,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Week $weekNumber: $title",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPast ? "Completed on $date" : "Upcoming on $date",
            style: TextStyle(
              color: isPast ? Colors.grey : Colors.green,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: !isFreeUser ? onViewDetails : null, // <-- enable jika !isFreeUser
              icon: const Icon(Icons.info_outline),
              label: const Text("View Course Details"),
              style: ElevatedButton.styleFrom(
                backgroundColor: !isFreeUser
                    ? Colors.blue.shade100
                    : Colors.grey.shade200,
                foregroundColor: !isFreeUser
                    ? Colors.black87
                    : Colors.grey.shade500,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
