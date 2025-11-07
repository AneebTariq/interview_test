import 'package:flutter/material.dart';
import 'package:interview_task/views/mood/widgets/mood_slider_components.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
 String _currentMoodName = moods.first.name;
  String _currentMoodIcon = moods.first.icon;
  final double _sliderSize = 320;

  void _updateMood(String name, String icon) {
    setState(() {
      _currentMoodName = name;
      _currentMoodIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Start your day',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'How are you feeling at the Moment?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              
              // Spacing to push content down
              const Spacer(flex: 2),

              // --- Custom Mood Slider ---
              Center(
                child: MoodSlider(
                  size: _sliderSize,
                  onMoodChanged: _updateMood,
                ),
              ),
              
              // --- Central Mood Icon Display ---
              Center(
                child: Container(
                  width: _sliderSize * 0.45,
                  height: _sliderSize * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Only here to confirm size
                    borderRadius: BorderRadius.circular(24),
                  ),
                  // AnimatedSwitcher to smoothly transition the icon
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Center(
                      // Key is crucial for AnimatedSwitcher to detect content change
                      child: Text(
                        _currentMoodIcon,
                        key: ValueKey<String>(_currentMoodIcon),
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Mood Name Text ---
              const SizedBox(height: 30),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(sizeFactor: animation, child: child),
                    );
                  },
                  child: Text(
                    _currentMoodName,
                    key: ValueKey<String>(_currentMoodName),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 3),

              // --- Continue Button ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected mood: $_currentMoodName')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}