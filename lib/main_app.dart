import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/booking/create_journey_view.dart';
import 'package:etravel_mobile/view/booking/booking_history_view.dart';
import 'package:flutter_svg/svg.dart';
import 'res/app_color.dart';
import 'view/home/home_view.dart';
import 'view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'view/conversation/conversation_list_view.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final _homeView = const HomeView();
  final _bookingHistoryView = const BookingHistoryView();
  final _createJourneyView = const CreateJourneyView();
  final _conversationListView = const ConversationListView();
  final _profileView = const ProfileView();
  List<Widget> _options = [];
  final _basePath = 'assets/images/sample';
  // var _icon = <Map<String, dynamic>>[];

  @override
  void initState() {
    _options = [
      _homeView,
      _bookingHistoryView,
      _createJourneyView,
      _conversationListView,
      _profileView,
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var icon = [
      {
        'icon': '$_basePath/home_fill.svg',
        'label': context.tr('home'),
      },
      {'icon': '$_basePath/history3.svg', 'label': context.tr('booking')},
      {
        'icon': '$_basePath/travel2.svg',
        'label': context.tr('tracking'),
      },
      {
        'icon': '$_basePath/message3.svg',
        'label': context.tr('chat'),
      },
      {
        'icon': '$_basePath/profile3.svg',
        'label': context.tr('profile'),
      }
    ];
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: _options[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(.3),
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: List.generate(
            icon.length,
            (index) => BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 3),
                width: index == 2 ? 35 : 24,
                height: index == 2 ? 35 : 24,
                child: SvgPicture.asset(
                  icon[index]['icon']!,
                  // ignore: deprecated_member_use
                  color: _selectedIndex == index
                      ? (index != 2 ? AppColors.primaryColor : null)
                      : (index != 2 ? AppColors.unselectedColor : null),
                ),
              ),
              label: icon[index]['label'],
            ),
          ),
          currentIndex: _selectedIndex,
          unselectedItemColor: AppColors.unselectedColor,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
