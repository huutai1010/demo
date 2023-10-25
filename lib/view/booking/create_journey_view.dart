import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/booking/allplacesitem_view.dart';
import 'package:etravel_mobile/view/booking/journeycurrently_view.dart';
import 'package:etravel_mobile/view/booking/journeynotgone_view.dart';
import 'package:etravel_mobile/view/booking/popup_creating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateJourneyView extends StatefulWidget {
  const CreateJourneyView({super.key});
  @override
  State<CreateJourneyView> createState() => _CreateJourneyViewState();
}

class _CreateJourneyViewState extends State<CreateJourneyView> {
  var _selectedTab = 0;

  final _pages = <Widget>[
    const JourneyCurrentlyGoneView(),
    const JourneyNotGoneView(),
    const Text('4'),
    const PlacesNotGoneView(),
    const Text('6'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _options = [
      context.tr('journey_is_go'),
      context.tr('journey_not_gone'),
      context.tr('journey_has_gone'),
      context.tr('location_not_gone'),
      context.tr('location_has_gone'),
    ];
    return ChangeNotifierProvider<SelectOption>(
      create: (context) => SelectOption(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Consumer<SelectOption>(
            builder: (context, model, child) {
              return model.selected
                  ? const Text('')
                  : Text(context.tr('warehouse'));
            },
          ),
          toolbarHeight: 70,
          leading: Consumer<SelectOption>(
            builder: (context, model, child) {
              return model.selected
                  ? IconButton(
                      onPressed: () {
                        model.toggle();
                      },
                      icon: const Icon(Icons.close))
                  : const BackButton(color: Colors.white);
            },
          ),
          actions: [
            Consumer<SelectOption>(builder: (context, myModel, child) {
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BookingDialog(
                        image: 'assets/images/background/create_journey.png',
                        title: context.tr('create_new_journey'),
                        content:
                            context.tr('would_you_like_to_create_this_journey'),
                        actionName: context.tr('confirm'),
                      );
                    },
                  );
                },
                child: Text(
                  myModel.selected ? context.tr('create_journey') : '',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            })
          ],
        ),
        body: Column(
          children: [
            _getTabsSelection(_options),
            _pages[_selectedTab],
          ],
        ),
      ),
    );
  }

  Widget _getTabsSelection(List<String> _options) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(_options.length, (index) {
          var check = _selectedTab == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: check
                        ? AppColors.primaryColor
                        : const Color(0xFFF5F5F5),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                style: TextStyle(
                  fontWeight: check ? FontWeight.bold : FontWeight.w300,
                  color: check ? AppColors.primaryColor : Colors.black,
                  fontSize: 14,
                ),
                _options[index],
              ),
            ),
          );
        })),
      ),
    );
  }
}

class BookingDialog extends StatelessWidget {
  String image;
  String title;
  String content;
  String actionName;

  BookingDialog({
    required this.image,
    required this.title,
    required this.content,
    required this.actionName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 335,
        height: 464,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close))
              ],
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              width: 190,
              height: 200,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            //const SizedBox(height: 15),
            Text(
              content,
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PopupCreating()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor,
                ),
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                alignment: Alignment.center,
                width: 250,
                height: 44,
                child: Text(
                  actionName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
