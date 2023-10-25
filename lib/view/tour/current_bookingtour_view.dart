import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/tour/tour_tracking_view.dart';
import 'package:flutter/material.dart';

class CurrentBookingTour extends StatelessWidget {
  const CurrentBookingTour({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * 40 / 812,
            left: screenWidth * 15 / 375,
            right: screenWidth * 15 / 375),
        child: Column(children: [
          Row(
            children: [
              Text(
                context.tr('your_places'),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TourTrackingView(),
                    ),
                  );
                },
                child: const Text(
                  'Tour tracking',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  7,
                  (index) => Container(
                    margin: EdgeInsets.only(
                        top: index == 0 ? screenHeight * 20 / 812 : 0,
                        bottom: screenHeight * 20 / 812),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://cdn3.ivivu.com/2022/10/h%E1%BB%93-con-r%C3%B9a-ivivu-12.jpg'),
                            ),
                          ),
                          width: screenWidth * 124 / 375,
                          height: screenWidth * 124 / 375,
                        ),
                        SizedBox(
                          width: screenWidth * 10 / 375,
                        ),
                        SizedBox(
                          height: screenHeight * 124 / 812,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ho Con Rua',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Steamed milk and mocha sauce \ntopped with sweeten...',
                                style:
                                    TextStyle(color: AppColors.grayTextColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
