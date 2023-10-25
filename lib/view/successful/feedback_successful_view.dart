import '../../res/app_color.dart';
import 'package:flutter/material.dart';

class FeedbackSuccessfulView extends StatelessWidget {
  const FeedbackSuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/success/success.png'),
              ),
            ),
            width: screenWidth * 106 / 375,
            height: screenWidth * 106 / 375,
          ),
          SizedBox(height: screenHeight * 15 / 812),
          const Text(
            'Give Feedback successfully',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          GestureDetector(
            child: Container(
              width: screenWidth * .75,
              height: screenHeight * 50 / 812,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: screenHeight * 50 / 812),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primaryColor,
              ),
              child: const Text(
                'DONE',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
