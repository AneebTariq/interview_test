import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:interview_task/models/plan_models.dart';
import 'package:interview_task/utils/constent_assets.dart';

import 'widgets/weekheader.dart';
import 'widgets/workout_card.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final List<WeekEntry> _weeks; // source of truth

  @override
  void initState() {
    super.initState();
    _weeks = _generateWeeksForCurrentMonth();

    // Add two sample workouts only to the first week (as requested)
    if (_weeks.isNotEmpty) {
      final firstWeek = _weeks.first;
      // put one workout on Monday (index 0) and one on Thursday (index 3)
      firstWeek.days[0].workouts.add(
        Workout(
          type: 'Arms Workout',
          title: 'Arm Blaster',
          durationLabel: '25m - 30m',
          durationMinutes: 25,
          color: Colors.greenAccent,
          icon: armIcon,
        ),
      );
      firstWeek.days[3].workouts.add(
        Workout(
          type: 'Leg Workout',
          title: 'Leg Day Blitz',
          durationLabel: '25m - 30m',
          durationMinutes: 25,
          color: Colors.blueAccent,
          icon: legIcon,
        ),
      );
    }
  }

  // Generate weeks that cover the whole current month. Weeks start on Monday.
  List<WeekEntry> _generateWeeksForCurrentMonth() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    final firstOfMonth = DateTime(year, month, 1);
    final lastOfMonth = DateTime(year, month + 1, 0);

    // find the Monday of the week that includes the 1st of the month (may be in previous month)
    final int weekdayOfFirst = firstOfMonth.weekday; // Monday = 1
    final DateTime firstWeekStart = firstOfMonth.subtract(Duration(days: weekdayOfFirst - 1));

    List<WeekEntry> weeks = [];
    DateTime cursor = firstWeekStart;
    int weekIdx = 1;

    // Keep generating weeks until we've passed the last day of month
    while (cursor.isBefore(lastOfMonth) || cursor.isAtSameMomentAs(lastOfMonth)) {
      List<DayEntry> days = List.generate(7, (i) {
        final date = DateTime(cursor.year, cursor.month, cursor.day + i);
        return DayEntry(date: date);
      });

      weeks.add(WeekEntry(weekIndex: weekIdx, days: days));

      // advance cursor by 7 days
      cursor = cursor.add(const Duration(days: 7));
      weekIdx++;
    }

    return weeks;
  }

  // Build DragAndDropLists from _weeks
  List<DragAndDropList> _buildDragLists() {
    return _weeks.map((week) {
      final header = WeekHeader(
        weekIndex: week.weekIndex,
        dateRange: week.dateRangeLabel(),
        totalMinutes: week.totalMinutes(),
      );

      final children = week.days.map((day) {
        return DragAndDropItem(
          child: _DayRow(
            day: day,
          ),
        );
      }).toList();

      return DragAndDropList(
        header: header,
        children: children,
      );
    }).toList();
  }

  // Convert global indexes to week/day/workout positions when reordering items
  void _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldWeek = _weeks[oldListIndex];
      final newWeek = _weeks[newListIndex];

      final movedItem = oldWeek.days[oldItemIndex];

      // If the day has workouts, we want to move the entire DayEntry between lists
      // BUT the library works with items within a list. To allow moving workouts between days,
      // we will interpret the DragAndDropItem as a day container. To move workouts between days,
      // you'd need to implement nested drag lists for workouts; for simplicity and to keep UI
      // consistent with the screenshot we move DayEntries (cards) as items.

      oldWeek.days.removeAt(oldItemIndex);
      newWeek.days.insert(newItemIndex, movedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lists = _buildDragLists();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        title: const Text("Training Calendar", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DragAndDropLists(
              children: lists,
              onItemReorder: _onItemReorder,
              onListReorder: (oldListIndex, newListIndex) {
                setState(() {
                  final moved = _weeks.removeAt(oldListIndex);
                  _weeks.insert(newListIndex, moved);
                });
              },
              listPadding: const EdgeInsets.symmetric(horizontal: 16,),
              listInnerDecoration: const BoxDecoration(color: Colors.transparent),
              itemDivider: const Divider(color: Color(0xFF1C1C1E), thickness: 1),
              itemDecorationWhileDragging: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _DayRow extends StatelessWidget {
  final DayEntry day;

  const _DayRow({required this.day});

  @override
  Widget build(BuildContext context) {
    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekdayIndex = day.date.weekday - 1; // Monday = 0

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weekdayNames[weekdayIndex], style: const TextStyle(color: Colors.white54)),
                    const SizedBox(height: 6),
                    Text('${day.date.day}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: day.workouts.isEmpty
                    ? Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: const Color(0xFF1C1C1E)),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('', style: TextStyle(color: Colors.white54)),
                        ),
                      )
                    : Column(
                        children: day.workouts.map((w) => WorkoutCard.fromWorkout(w)).toList(),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
