import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesNotGoneView extends StatefulWidget {
  const PlacesNotGoneView({super.key});
  @override
  State<StatefulWidget> createState() => _PlacesNotGoneViewState();
}

class SelectOption with ChangeNotifier {
  bool selected = false;

  toggle() {
    selected = !selected;
    notifyListeners();
  }
}

class _PlacesNotGoneViewState extends State<PlacesNotGoneView> {
  //bool selected = false;
  SelectOption selectOption = SelectOption();
  //bool selected = false;
  List<bool> isChecks = [];
  List<int> items = [1, 2, 3, 4, 5]; // demo

  @override
  void initState() {
    isChecks = items.map((e) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(items.length, (index) {
            return _getItemPlace(index);
          }),
        ),
      ),
    );
  }

  Widget _getItemPlace(int index) {
    var itemSize = MediaQuery.of(context).size.width;
    return Consumer<SelectOption>(builder: (context, model, child) {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            loggerInfo.i('Long press');
            //selected = !selected;
            model.toggle();
          });
        },
        child: Consumer<SelectOption>(builder: (context, model, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.selected ? _getCheckBox(index) : Container(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(
                    top: 10, bottom: 10, right: model.selected ? 15 : 0),
                width: model.selected ? itemSize * .75 : itemSize * .9,
                alignment: Alignment.center,
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1688892547009-fbb0212bbbdb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3387&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: model.selected ? 93 : 113,
                      height: 118,
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Landmark 81',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primaryColor,
                            ),
                            Text('2,5Km')
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_filled_outlined,
                              color: Color(0xFFFC820A),
                            ),
                            Text('1 giờ 30 phút')
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Expanded _getCheckBox(int index) {
    return Expanded(
      child: Center(
        child: Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          checkColor: Colors.white,
          activeColor: AppColors.primaryColor,
          //tristate: true,
          value: isChecks[index],
          onChanged: (val) {
            setState(() {
              isChecks[index] = !isChecks[index];
            });
          },
        ),
      ),
    );
  }
}

class ItemPlace extends StatefulWidget {
  SelectOption selectOption;
  ItemPlace({required this.selectOption, super.key});
  @override
  State<StatefulWidget> createState() => _ItemPlaceState();
}

class _ItemPlaceState extends State<ItemPlace> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    var itemSize = MediaQuery.of(context).size.width;
    return Consumer<SelectOption>(builder: (context, model, child) {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            loggerInfo.i('Long press');
            widget.selectOption.selected = !widget.selectOption.selected;
            model.toggle();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.selectOption.selected
                ? Expanded(
                    child: Center(
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        checkColor: Colors.white,
                        activeColor: AppColors.primaryColor,
                        tristate: true,
                        value: checked,
                        onChanged: (val) {
                          setState(() {
                            checked = !checked;
                          });
                        },
                      ),
                    ),
                  )
                : Container(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              width:
                  widget.selectOption.selected ? itemSize * .75 : itemSize * .9,
              alignment: Alignment.center,
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1688892547009-fbb0212bbbdb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3387&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: widget.selectOption.selected ? 93 : 113,
                    height: 118,
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Landmark 81',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryColor,
                          ),
                          Text('2,5Km')
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled_outlined,
                            color: Color(0xFFFC820A),
                          ),
                          Text('1 giờ 30 phút')
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
