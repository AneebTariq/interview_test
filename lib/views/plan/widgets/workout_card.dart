import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:interview_task/models/plan_models.dart';
import 'package:interview_task/utils/constent_assets.dart';

class WorkoutCard extends StatelessWidget {
  final String type;
  final String title;
  final String duration;
  final Color color;
  final String icon;

  const WorkoutCard({
    super.key,
    required this.type,
    required this.title,
    required this.duration,
    required this.color,
    required this.icon,
  });

  factory WorkoutCard.fromWorkout(Workout w) => WorkoutCard(
    type: w.type,
    title: w.title,
    duration: w.durationLabel,
    color: w.color,
    icon: w.icon,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10,right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(dotsIcon,height: 22,width: 22,),
                SizedBox(width: 8,),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(icon,height: 10,width: 10,),
                      SizedBox(width: 4,),
                      Text(
                        type,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(width: 32,),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w400),
                ),
                Spacer(),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
