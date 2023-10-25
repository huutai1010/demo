import 'package:chip_list/chip_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/category.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/view/map/search_result_view.dart';
import 'package:etravel_mobile/view/place/place_detail_viewv2.dart';
import 'package:etravel_mobile/view_model/search_viewmodel.dart';
import 'package:flutter/material.dart';

class SearchPlaceView extends StatefulWidget {
  const SearchPlaceView({super.key});

  @override
  State<SearchPlaceView> createState() => _SearchPlaceViewState();
}

class _SearchPlaceViewState extends State<SearchPlaceView> {
  var searchPlaceController = TextEditingController();
  String searchPlace = '';
  final _categoryNames = <String>[];
  late List<CategoryLanguage> categories = [];
  late List<Place> placesAround = [];
  final searchViewModel = SearchViewModel();
  var _selectedIndexes = <int>[];
  var selectedCaregories = <String>[];
  late Future<List<CategoryLanguage>> getCategoryData;
  late Future<List<Place>> getPlacesArroundData;

  @override
  void initState() {
    getCategoryData = searchViewModel.getCategory();
    getPlacesArroundData = searchViewModel.getPlacesAround();

    getPlacesArroundData.then((value) {
      placesAround = value;
      print('placesAround = ${placesAround.length}');
    });

    getCategoryData.then((value) {
      categories = value;
      categories.map((category) => category.name).toList().forEach((name) {
        if (name != null) {
          _categoryNames.add(name);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            _buildChipChoices(),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                context.tr('recommended'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _buildPlacesRecommended(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Place>> _buildPlacesRecommended() {
    return FutureBuilder<List<Place>>(
        future: getPlacesArroundData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  placesAround.length,
                  (index) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsViewV2(
                            placeId: placesAround[index].id!),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: index == 0 ? 20 : 0, right: 15, top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: .2),
                      ),
                      width: 190,
                      height: 265,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              image: DecorationImage(
                                image: NetworkImage(placesAround[index].image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: 190,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              placesAround[index].name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text('${placesAround[index].rate}'),
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFFFB23F)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '\$${placesAround[index].price}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.black.withOpacity(.6),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  FutureBuilder<List<CategoryLanguage>> _buildChipChoices() {
    return FutureBuilder<List<CategoryLanguage>>(
        future: getCategoryData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 5, top: 15, bottom: 20),
              child: ChipList(
                supportsMultiSelect: true,
                shouldWrap: true,
                activeBgColorList: const [AppColors.primaryColor],
                inactiveBorderColorList: const [Colors.grey],
                inactiveBgColorList: const [Colors.white],
                activeTextColorList: const [Colors.white],
                inactiveTextColorList: const [Colors.black],
                listOfChipNames: _categoryNames,
                listOfChipIndicesCurrentlySeclected: _selectedIndexes,
                extraOnToggle: (index) {
                  loggerInfo.i(index);
                  selectedCaregories =
                      _selectedIndexes.map((e) => _categoryNames[e]).toList();
                  loggerInfo.i(_selectedIndexes);
                  loggerInfo.i(selectedCaregories);
                  setState(() {});
                },
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.searchBorderColor.withOpacity(.3),
                  width: .5,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.only(left: 20),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration.collapsed(
                        hintStyle: const TextStyle(
                            color: AppColors.placeDetailTitleColor),
                        hintText: '${context.tr('find_your_places')}...'),
                    controller: searchPlaceController,
                    onChanged: (value) {
                      setState(() {
                        searchPlace = value;
                      });
                    },
                  ),
                ),
              ]),
            ),
          ),
          TextButton(
            onPressed: () async {
              await searchViewModel
                  .searchByCategories(_selectedIndexes)
                  .then((value) {
                if (searchViewModel.loading == false && value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultView(listSearchPlaces: value),
                    ),
                  );
                }
              });
            },
            child: Text(
              context.tr('search'),
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
