import 'package:flutter/material.dart';

class AdminSummaryCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String icon;

  const AdminSummaryCardWidget({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
              ],
            )
          ],
        ),
      ),
    );
  }
}