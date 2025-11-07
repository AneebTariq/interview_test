import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:interview_task/utils/colors.dart';
import 'package:interview_task/utils/constent_assets.dart';
import 'package:interview_task/views/home/widgets/calender_bottom_sheet.dart';
import 'package:interview_task/views/home/widgets/my_insite.dart';
import 'package:interview_task/views/home/widgets/week_calender.dart';
import 'package:interview_task/views/home/widgets/workouts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String today = DateFormat('dd MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: EdgeInsets.only(top: h * 0.018, bottom: h * 0.018),
          child: SvgPicture.asset(
            notificationIcon,
            height: h * 0.024,
            width: w * 0.024,
          ),
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: () => CalendarBottomSheet.show(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(clockIcon, height: h * 0.02, width: w * 0.02),
              SizedBox(width: 4),
              Text(
                'Week 1/4',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteClr,
                ),
              ),
              SizedBox(width: 4),
              SvgPicture.asset(
                arrowDownIcon,
                height: h * 0.008,
                width: w * 0.008,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: h * 0.024,
            horizontal: w * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today, $today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteClr,
                ),
              ),
              SizedBox(height: h * 0.016),
              WeekCalendar(),
              SizedBox(height: h * 0.016),
              Center(
                child: Container(
                  width: w * 0.15,
                  height: h * 0.01,
                  decoration: BoxDecoration(
                    color: Color(0xff282A39),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              SizedBox(height: h * 0.024),
              WorkoutCard(),
              SizedBox(height: h * 0.032),
              MyInsightsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
