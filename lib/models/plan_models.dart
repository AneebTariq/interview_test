// ----------------------------- Models -----------------------------
import 'dart:ui';

class Workout {
  final String type;
  final String title;
  final String durationLabel; // e.g. "25m - 30m"
  final int durationMinutes; // numeric value for summing (approx.)
  final Color color;
  final String icon;

  Workout({
    required this.type,
    required this.title,
    required this.durationLabel,
    required this.durationMinutes,
    required this.color,
    required this.icon,
  });
}

class DayEntry {
  final DateTime date;
  final List<Workout> workouts;

  DayEntry({required this.date, List<Workout>? workouts}) : workouts = workouts ?? [];
}

class WeekEntry {
  final int weekIndex; // 1-based inside the month
  final List<DayEntry> days; // always 7 entries Mon-Sun (may include prev/next month dates)

  WeekEntry({required this.weekIndex, required this.days});
 static String monthName(int m) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[m];
  }
  // human readable date range like "December 8–14"
  String dateRangeLabel() {
    final month = monthName(days.first.date.month);
    // ignore: unused_local_variable
    final startDay = days.firstWhere((d) => d.date.month == days.first.date.month || d.date.month == days.first.date.month, orElse: () => days.first).date.day;
    // ignore: unused_local_variable
    final visibleDays = days.where((d) => d.date.month == days[0].date.month).toList();

    // to display the first and last day that actually belong to the current month
    final firstInMonth = days.firstWhere((d) => d.date.month == days[0].date.month, orElse: () => days.first);
    final lastInMonth = days.lastWhere((d) => d.date.month == days[0].date.month, orElse: () => days.last);

    return "$month ${firstInMonth.date.day}–${lastInMonth.date.day}";
  }

  int totalMinutes() {
    return days.fold(0, (prev, d) => prev + d.workouts.fold(0, (p, w) => p + w.durationMinutes));
  }
}
