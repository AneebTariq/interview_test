import 'package:flutter/material.dart';

class WeekHeader extends StatelessWidget {
  final int weekIndex;
  final String dateRange;
  final int totalMinutes;

  const WeekHeader({required this.weekIndex, required this.dateRange, required this.totalMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
       decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(top: BorderSide(color: Color(0xff4855DF),width: 2),),
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Week $weekIndex', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 4),
              Text(dateRange, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
          Text('Total: ${totalMinutes}min', style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}