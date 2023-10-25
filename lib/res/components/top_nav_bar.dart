import '../app_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopNavBar extends StatelessWidget {
  String navTitle;
  TopNavBar({required this.navTitle});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: _screenWidth,
      height: _screeHeight * 50 / 812, // Custom
      padding: EdgeInsets.only(
          left: _screenWidth * 24 / 375,
          right: _screenWidth * 24 / 375,
          bottom: _screeHeight * 10 / 812),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.2),
            offset: Offset(2, 2),
            blurRadius: 16,
            spreadRadius: 4,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: _screenWidth * 7.5 / 375,
                height: _screeHeight * 15 / 812,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Vector.png'),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              navTitle,
              style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.shadowColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
          Spacer(),
          Container(
            width: _screenWidth * 7.5 / 375,
            height: _screeHeight * 15 / 812,
          )
        ],
      ),
    );
  }
}
