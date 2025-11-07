import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({super.key});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getCurrentWeekDays(DateTime date) {
    int weekday = date.weekday; // Monday = 1
    DateTime monday = date.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = getCurrentWeekDays(selectedDate);
    double h = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) {
        bool isSelected =
            day.day == selectedDate.day &&
            day.month == selectedDate.month &&
            day.year == selectedDate.year;

        return GestureDetector(
          onTap: () => setState(() => selectedDate = day),
          child: Column(
            children: [
              Text(
                DateFormat('E').format(day).substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: h * 0.012),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 9),
                decoration: BoxDecoration(
                  color:isSelected?const Color(0x3020B76F): const Color(0xFF18181C),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.greenAccent, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
