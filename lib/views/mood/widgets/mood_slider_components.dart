// --- 1. Mood Data Structure ---
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Mood {
  final String name;
  final String icon;
  final Color color;
  
  // Angle boundary (degrees) for mood detection, 0 is at the top, increasing clockwise
  final double startDegree; 

  const Mood(this.name, this.icon, this.color, this.startDegree);
}

// 4 Moods defined with their colors and start positions (90-degree segments)
const List<Mood> moods = [
  // Teal/Green segment (Top Right/Top)
  Mood("Calm", "😌", Color(0xFF6AAB9E), 315), 
  // Orange segment (Top Left)
  Mood("Happy", "😊", Color(0xFFE5C07B), 45), 
  // Pink/Purple segment (Bottom Left)
  Mood("Anxious", "😟", Color(0xFFD06B8D), 135), 
  // Coral/Peach segment (Bottom Right)
  Mood("Energetic", "🤩", Color(0xFFE59C7B), 225), 
];

// --- 2. Mood Arc Painter (Draws the Ring) ---
class MoodArcPainter extends CustomPainter {
  final List<Mood> moods;
  final double arcWidth;

  MoodArcPainter({required this.moods, required this.arcWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Total sweep for a full circle is 2 * pi radians
    final double segmentSweep = math.pi / 2; 

    for (int i = 0; i < moods.length; i++) {
      final mood = moods[i];
      final paint = Paint()
        ..color = mood.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcWidth
        ..strokeCap = StrokeCap.butt;
      
      // Calculate start angle in radians. 
      // 0 degrees is to the right (X-axis). We shift it by -90 degrees (pi/2) to start at the top.
      double startAngleInRadians = (mood.startDegree * math.pi / 180.0) - (math.pi / 2.0) ;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - arcWidth / 2),
        startAngleInRadians,
        segmentSweep,
        false, 
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MoodArcPainter oldDelegate) => false;
}

// --- 3. Slider Handle (The White Circle) ---
class SliderHandle extends StatelessWidget {
  const SliderHandle({Key? key}) : super(key: key);

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
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        // The 'R' indicator from the original design
        child: Text(
          'R', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 18
          ),
        ),
      ),
    );
  }
}

// --- 4. The Main Mood Slider Widget ---
class MoodSlider extends StatefulWidget {
  final double size;
  final Function(String moodName, String moodIcon) onMoodChanged;

  const MoodSlider({
    Key? key,
    required this.size,
    required this.onMoodChanged,
  }) : super(key: key);

  @override
  _MoodSliderState createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  // Angle in radians, 0 is to the right (X-axis)
  double _currentAngle = 0.0; 
  // Handle start position on the circle (Top right, matching the image)
  final double _initialHandleAngle = math.pi * 1.75; // 315 degrees in radians

  @override
  void initState() {
    super.initState();
    _currentAngle = _initialHandleAngle;
    // Notify parent about the initial mood
    _updateSelectedMood(_initialHandleAngle);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // 1. Calculate the center of the circular area
    final Offset center = Offset(widget.size / 2, widget.size / 2);

    // 2. Calculate the vector from the center to the touch point
    final Offset vector = details.localPosition - center;

    // 3. Calculate the new raw angle (in radians, -pi to pi, 0 is right)
    final double rawAngle = math.atan2(vector.dy, vector.dx);

    setState(() {
      _currentAngle = rawAngle;
      _updateSelectedMood(rawAngle);
    });
  }

  void _updateSelectedMood(double rawAngle) {
    // 1. Normalize angle to 0-360 degrees, starting at the top and increasing clockwise.
    // 0 is right (X-axis). 
    // To make 0 at the top (Y-axis), we shift it by -90 degrees, then normalize.
    double angleDegrees = (rawAngle * 180 / math.pi + 90 + 360) % 360; 

    // Find the current mood based on the angle
    Mood selectedMood = moods.first;
    double minDiff = 360;

    for (var mood in moods) {
      // Find the center angle of the segment (start + 45 degrees)
      double centerAngle = (mood.startDegree + 45) % 360;

      // Calculate the difference, handling the 360/0 wrap-around
      double diff = (angleDegrees - centerAngle + 180) % 360 - 180;
      double absDiff = diff.abs();
      
      if (absDiff < minDiff) {
        minDiff = absDiff;
        selectedMood = mood;
      }
    }
    
    // Notify the parent screen
    widget.onMoodChanged(selectedMood.name, selectedMood.icon);
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.size / 2;
    final double arcWidth = radius * 0.25;

    return Container(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onPanUpdate: _handlePanUpdate,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. The Mood Arc Ring
            CustomPaint(
              size: Size.square(widget.size),
              painter: MoodArcPainter(moods: moods, arcWidth: arcWidth),
            ),

            // 2. The Slider Handle (Rotated using Transform.translate)
            // It is positioned by translating it outwards by the radius
            Transform.translate(
              offset: Offset(
                math.cos(_currentAngle) * (radius - arcWidth / 2),
                math.sin(_currentAngle) * (radius - arcWidth / 2),
              ),
              child: const SliderHandle(),
            ),

            // 3. Central Icon Placeholder (The parent widget will handle the actual icon)
            Container(
              width: widget.size * 0.45,
              height: widget.size * 0.45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              // The icon is placed by the parent using AnimatedSwitcher
            ),
          ],
        ),
      ),
    );
  }
}