import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:interview_task/utils/constent_assets.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard({super.key});

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isDay = true;
  double? temperature;

  final WeatherFactory _weather =
      WeatherFactory("YOUR_OPENWEATHER_API_KEY"); // 👈 Replace with your API key

  @override
  void initState() {
    super.initState();
    _checkTime();
    _fetchTemperature();
  }

  void _checkTime() {
    final hour = DateTime.now().hour;
    setState(() {
      isDay = hour >= 6 && hour < 18; // Day: 6am–6pm
    });
  }

  Future<void> _fetchTemperature() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      Weather weather = await _weather.currentWeatherByLocation(
          position.latitude, position.longitude);

      setState(() {
        temperature = weather.temperature?.celsius;
      });
    } catch (e) {
      debugPrint("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Workouts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              isDay ? dayIcon : nightIcon,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            Text(
              temperature != null ? '${temperature!.toStringAsFixed(0)}°' : '9°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Workout Card
        Container(
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Left stripe
              Container(
                width: 6,
                height: 84,
                decoration: const BoxDecoration(
                  color: Color(0xFF32AAB7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'December 22 - 25m - 30m',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Upper Body',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SvgPicture.asset(
                  arrowRightIcon,
                  color: Colors.white70,
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
