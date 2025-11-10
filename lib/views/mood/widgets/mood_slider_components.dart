import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:interview_task/utils/constent_assets.dart';

/// --- 1. Mood Data Structure ---
class Mood {
  final String name;
  final String icon;
  final Color color;
  final double startDegree;

  const Mood(this.name, this.icon, this.color, this.startDegree);
}

/// --- 2. Mood List (Each covers 90° segment) ---
const List<Mood> moods = [
  Mood("Calm", calmIcon, Color(0xFF6AAB9E), 315),
  Mood("Happy",happyIcon, Color(0xFFE5C07B), 45),
  Mood("Anxious", contentIcon, Color(0xFFD06B8D), 135),
  Mood("Energetic", peacefulIcon, Color(0xFFE59C7B), 225),
];

/// --- 3. Custom Painter (Colored Mood Ring) ---
class MoodArcPainter extends CustomPainter {
  final List<Mood> moods;
  final double arcWidth;

  MoodArcPainter({required this.moods, required this.arcWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const sweep = math.pi / 2;

    for (final mood in moods) {
      final paint = Paint()
        ..color = mood.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcWidth;

      final start = (mood.startDegree * math.pi / 180) - (math.pi / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - arcWidth / 2),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MoodArcPainter oldDelegate) =>
      oldDelegate.arcWidth != arcWidth || oldDelegate.moods != moods;
}

/// --- 4. Slider Handle (White Circular Button) ---
class SliderHandle extends StatelessWidget {
  const SliderHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'R',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

/// --- 5. Mood Slider with Smooth Handle Animation ---
class MoodSlider extends StatefulWidget {
  final double size;
  final Widget icon;
  final Function(String moodName, String moodIcon) onMoodChanged;

  const MoodSlider({
    super.key,
    required this.size,
    required this.icon,
    required this.onMoodChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider>
    with SingleTickerProviderStateMixin {
  late double _currentAngle;

  late AnimationController _controller;
  late Animation<double> _angleAnimation;

  final double _initialHandleAngle = math.pi * 1.75; // 315°

  @override
  void initState() {
    super.initState();
    _currentAngle = _initialHandleAngle;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedMood(_currentAngle);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final vector = details.localPosition - center;
    final double newAngle = math.atan2(vector.dy, vector.dx);

    _animateHandle(newAngle);
    _updateSelectedMood(newAngle);
  }

  void _animateHandle(double newAngle) {
    _controller.stop();

    final double startAngle = _currentAngle;
    double delta = newAngle - startAngle;

    // Ensure shortest rotation path
    if (delta.abs() > math.pi) {
      delta -= math.pi * 2 * delta.sign;
    }

    _angleAnimation = Tween<double>(
      begin: startAngle,
      end: startAngle + delta,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller
      ..reset()
      ..forward();

    _angleAnimation.addListener(() {
      setState(() {
        _currentAngle = _angleAnimation.value;
      });
    });
  }

  void _updateSelectedMood(double rawAngle) {
    double angleDegrees = (rawAngle * 180 / math.pi + 90 + 360) % 360;

    for (final mood in moods) {
      double start = mood.startDegree % 360;
      double end = (start + 90) % 360;

      bool inSegment;
      if (start < end) {
        inSegment = angleDegrees >= start && angleDegrees < end;
      } else {
        inSegment = angleDegrees >= start || angleDegrees < end;
      }

      if (inSegment) {
        widget.onMoodChanged(mood.name, mood.icon);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.size / 2;
    final double arcWidth = radius * 0.25;

    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(widget.size),
            painter: MoodArcPainter(moods: moods, arcWidth: arcWidth),
          ),
          Transform.translate(
            offset: Offset(
              math.cos(_currentAngle) * (radius - arcWidth / 2),
              math.sin(_currentAngle) * (radius - arcWidth / 2),
            ),
            child: const SliderHandle(),
          ),
          widget.icon,
        ],
      ),
    );
  }
}
