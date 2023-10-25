import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/booking/cart_view.dart';
import 'package:etravel_mobile/view/place/place_detail_viewv2.dart';
import 'package:etravel_mobile/view/place/search_place_view.dart';
import '../../models/place.dart';
import '../../models/tour.dart';
import '../../res/app_color.dart';
import '../../view_model/home_viewmodel.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var homeViewViewModel = HomeViewViewModel();
  var popularPlaces = <Place>[];
  var popularTours = <Tour>[];
  late Future<List<Place>> popularPlacesData;
  late Future<List<Tour>> popularToursData;

  @override
  void initState() {
    popularPlacesData = homeViewViewModel.getPopularPlaces();
    popularToursData = homeViewViewModel.getPopularTours();
    popularPlacesData.then((value) => popularPlaces = value);
    popularToursData.then((value) => popularTours = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopSection(screenWidth, screenHeight),
                  FutureBuilder<List<Tour>>(
                      future: popularToursData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return BottomSection(
                            popularTours: popularTours,
                            'Tours',
                            screenWidth,
                            screenHeight,
                            homeViewViewModel,
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                  FutureBuilder<List<Place>>(
                    future: popularPlacesData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return BottomSection(
                          popularPlaces: popularPlaces,
                          isPopularPlace: true,
                          'Places',
                          screenWidth,
                          screenHeight,
                          homeViewViewModel,
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TopSection extends StatelessWidget {
  double screenWidth;
  double screenHeight;

  TopSection(this.screenWidth, this.screenHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/background/hochiminhcity.jpg',
                  ),
                  colorFilter:
                      ColorFilter.mode(Colors.black12, BlendMode.darken)),
            ),
            width: screenWidth,
            height: 280,
          ),
          Container(
            height: 260,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CartView())),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white60,
                        ),
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),
                Text(
                  context.tr('explore_the_city_today'),
                  style: const TextStyle(
                    fontSize: 37,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        context.tr('discover_take_your_travel_to_next_level'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchPlaceView()));
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              context.tr('search_place'),
                              style: const TextStyle(
                                color: AppColors.searchTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                                width: 18,
                                height: 18,
                                child: Icon(Icons.search))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomSection extends StatelessWidget {
  String title;
  double screenWidth;
  double screenHeight;
  bool isPopularPlace;
  List<Place> popularPlaces;
  List<Tour> popularTours;
  HomeViewViewModel homeViewViewModel;

  BottomSection(
    this.title,
    this.screenWidth,
    this.screenHeight,
    this.homeViewViewModel, {
    super.key,
    this.isPopularPlace = false,
    this.popularPlaces = const [],
    this.popularTours = const [],
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
            bottom: 5,
          ),
          child: Text(
            title == 'Tours'
                ? context.tr('popular_tours')
                : context.tr('popular_places'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                isPopularPlace ? popularPlaces.length : popularTours.length,
                (index) {
              final itemWidth = screenWidth * 230 / 375;
              final itemHeight = screenHeight * 320 / 812;
              return GestureDetector(
                onTap: () {
                  if (isPopularPlace) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsViewV2(
                          placeId: popularPlaces[index].id!,
                        ),
                      ),
                    );
                  } else {
                    homeViewViewModel.getTourDetailsV2(
                        popularTours[index].id!, context, isPopularPlace);
                  }
                },
                child: Stack(alignment: AlignmentDirectional.topEnd, children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      left: index == 0 ? screenWidth * 20 / 375 : 0,
                      right: screenWidth * 15 / 375,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(4, 2)),
                        const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4, -4),
                            blurRadius: 15,
                            spreadRadius: 1)
                      ],
                    ),
                    width: itemWidth,
                    height: itemHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                isPopularPlace
                                    ? popularPlaces[index].image!.trim()
                                    : popularTours[index].image!.trim(),
                              ),
                            ),
                          ),
                          width: itemWidth,
                          height: itemHeight * .7375,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 10 / 375,
                            top: screenHeight * 10 / 812,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPopularPlace
                                    ? popularPlaces[index].name!
                                    : popularTours[index].name!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                      '${isPopularPlace ? popularPlaces[index].rate : popularTours[index].rate}'),
                                  const Icon(Icons.star_rounded,
                                      size: 16, color: Color(0xFFFFB23F))
                                ],
                              ),
                              Text(
                                '\$${isPopularPlace ? popularPlaces[index].price : popularTours[index].price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            }),
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class FavoriteLikeButton extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  bool isCheck;
  FavoriteLikeButton({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.isCheck = false,
  });

  @override
  State<StatefulWidget> createState() => _FavoriteLikeButtonState();
}

class _FavoriteLikeButtonState extends State<FavoriteLikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isCheck = !widget.isCheck;
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            top: widget.screenHeight * 15 / 812,
            right: widget.screenWidth * 25 / 375),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        width: widget.screenWidth * 36 / 375,
        height: widget.screenWidth * 36 / 375,
        child: Icon(
          !widget.isCheck ? Icons.favorite_border_outlined : Icons.favorite,
          color: !widget.isCheck ? Colors.black : Colors.red,
        ),
      ),
    );
  }
}
