import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interview_task/utils/constent_assets.dart';

class MyInsightsSection extends StatelessWidget {
  const MyInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
     double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Insights',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
         SizedBox(height: h*(16/h)),

        // 🔹 Row of two insight cards
        Row(
          children: [
            // Calories Card
            Expanded(
              child: Container(
                height:h* (151/h),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '550',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Calories',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4,),
                    const Text(
                      '1950 Remaining',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                     Spacer(),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0', style: TextStyle(color: Colors.white54)),
                        Text('2500', style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                     SizedBox(height: h*(8/h)),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 550 / 2500,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF66E3A4)),
                      ),
                    ),
                   
                    
                  ],
                ),
              ),
            ),
           SizedBox(width: w*(12/w)),

            // Weight Card
            Expanded(
              child: Container(
                height:h* (151/h),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '75',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: w*(6/w)),
                        Text(
                          'kg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: h*(4/h)),
                    Row(
                      children:  [
                        SvgPicture.asset(
                          arrowGreenIcon,
                          height: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+1.6kg',
                          style: TextStyle(
                            color: Color(0xFFA4A4A4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                   Spacer(),
                    const Text(
                      'Weight',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: h*(12/h),),
        HydrationCard(),
      ],
    );
  }
}

class HydrationCard extends StatelessWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Top dark card
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1D),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Left side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hydration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Log Now',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side (vertical slider look)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '2 L',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Container(
                    width: 3,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blueAccent.withOpacity(0.7),
                          Colors.blueGrey.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    '0 L',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Text(
                '0ml',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // 🔹 Bottom bar
        Container(
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF29565B),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: const Center(
            child: Text(
              '500 ml added to water log',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}