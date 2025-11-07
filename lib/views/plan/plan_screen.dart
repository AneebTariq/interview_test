import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
 late List<DragAndDropList> _weekDays;

  @override
  void initState() {
    super.initState();

    final weekData = [
      {
        'day': 'Mon 8',
        'workouts': [
          {'type': 'Arms Workout', 'title': 'Arm Blaster', 'duration': '25m - 30m', 'color': Colors.greenAccent}
        ]
      },
      {'day': 'Tue 9', 'workouts': []},
      {'day': 'Wed 10', 'workouts': []},
      {
        'day': 'Thu 11',
        'workouts': [
          {'type': 'Leg Workout', 'title': 'Leg Day Blitz', 'duration': '25m - 30m', 'color': Colors.blueAccent}
        ]
      },
      {'day': 'Fri 12', 'workouts': []},
      {'day': 'Sat 13', 'workouts': []},
      {'day': 'Sun 14', 'workouts': []},
    ];

    _weekDays = weekData.map((day) {
      return DragAndDropList(
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "${day['day']}",
            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        children: (day['workouts'] as List).map((workout) {
          return DragAndDropItem(
            child: WorkoutCard(
              type: workout['type'],
              title: workout['title'],
              duration: workout['duration'],
              color: workout['color'],
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            alignment: Alignment.centerLeft,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Week 2/8\nDecember 8–14", style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text("Total: 60min", style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1C1C1E), thickness: 1),
          Expanded(
            child: DragAndDropLists(
              children: _weekDays,
              onItemReorder: _onItemReorder,
              onListReorder: (_, __) {},
              listPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              listInnerDecoration: const BoxDecoration(color: Colors.transparent),
              itemDivider: const Divider(color: Colors.transparent),
              itemDecorationWhileDragging: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E0E10),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Nutrition"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Plan"),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: "Mood"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final movedItem = _weekDays[oldListIndex].children.removeAt(oldItemIndex);
      _weekDays[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }
}

class WorkoutCard extends StatelessWidget {
  final String type;
  final String title;
  final String duration;
  final Color color;

  const WorkoutCard({
    super.key,
    required this.type,
    required this.title,
    required this.duration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                type,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
              Text(duration, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}