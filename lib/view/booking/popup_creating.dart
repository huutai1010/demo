import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/successful/create_journey_successful.dart';
import 'package:flutter/material.dart';

class PopupCreating extends StatefulWidget {
  const PopupCreating({super.key});

  @override
  State<PopupCreating> createState() => _PopupCreatingState();
}

class _PopupCreatingState extends State<PopupCreating> {
  bool _isNearby = false;
  bool _isChekingTime = false;
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
        width: 343,
        height: 396,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF039855),
                        ),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF039855),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              Text(
                context.tr('create_new_journey'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                context.tr('new_journeys_will_be_created_from_your_choices.'),
                style: const TextStyle(color: Color(0xFF475467)),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        checkColor: Colors.white,
                        activeColor: AppColors.primaryColor,
                        value: _isNearby,
                        onChanged: (val) {
                          _isNearby = val!;
                          setState(() {});
                        },
                      ),
                      Text(
                        context.tr('near_me'),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        checkColor: Colors.white,
                        activeColor: AppColors.primaryColor,
                        value: _isChekingTime,
                        onChanged: (val) {
                          _isChekingTime = val!;
                          setState(() {});
                        },
                      ),
                      Text(
                        context.tr('open_close_time'),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreateJourneySuccessfulView())),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryColor,
                  ),
                  alignment: Alignment.center,
                  width: 310,
                  height: 45,
                  child: const Text(
                    'Có',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.searchBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  width: 310,
                  height: 45,
                  child: const Text(
                    'Không',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
