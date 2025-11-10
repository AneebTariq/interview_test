import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:interview_task/views/mood/widgets/mood_slider_components.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String _currentMoodName = moods.first.name;
  String _currentMoodIcon = moods.first.icon;

  void _updateMood(String name, String icon) {
    if (_currentMoodName != name) {
      setState(() {
        _currentMoodName = name;
        _currentMoodIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Mood',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400,color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Start your day',
                style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              const Text(
                'How are you feeling at the Moment?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: h * (38 / h)),
              // Mood Slider 
              Center(
                child: MoodSlider(
                  size: h * (240 / h),
                   // Mood Icon Animation
                  icon: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: SvgPicture.asset(
                        key: ValueKey(_currentMoodIcon),
                        _currentMoodIcon,
                        width: h * 0.110,
                        height: h * 0.110,
                      ),
                    ),
                  ),
                  onMoodChanged: _updateMood,
                ),
              ),
              SizedBox(height: h * (24 / h)),
              // Mood Name Animation
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    _currentMoodName,
                    key: ValueKey(_currentMoodName),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Spacer(),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: h * (49 / h),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected mood: $_currentMoodName'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
