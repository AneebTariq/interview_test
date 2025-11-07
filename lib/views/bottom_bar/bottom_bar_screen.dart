import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_task/utils/colors.dart';
import 'package:interview_task/utils/constent_assets.dart';
import 'package:interview_task/views/home/home_screen.dart';
import 'package:interview_task/views/mood/mood_screen.dart';
import 'package:interview_task/views/plan/plan_screen.dart';
import 'package:interview_task/views/profile/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const PlanScreen(),
    const MoodScreen(),
    const ProfileScreen(),
  ];

  final items = [
    {'icon': nutritionIcon, 'label': 'Nutrition'},
    {'icon': planIcon, 'label': 'Plan'},
    {'icon': moodIcon, 'label': 'Mood'},
    {'icon': personIcon, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: h*0.015,top: h*0.013,right: w*0.025,left: w*0.025),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color:AppColors.borderClr))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      items[index]['icon']!,
                      height: h*0.024,
                      width: w*0.024,
                      colorFilter: ColorFilter.mode(
                        isSelected ?AppColors.whiteClr : AppColors.disablenavClr,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label']!,
                      style: TextStyle(
                        color: isSelected ? AppColors.whiteClr :  AppColors.disablenavClr,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                   SizedBox(height: h*0.01),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
