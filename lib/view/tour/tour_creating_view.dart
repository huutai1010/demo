import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/view/tour/tourvision_viewv2.dart';
import '../../models/place.dart';
import '../../res/app_color.dart';
import '../../view_model/tour_creating_viewmodel.dart';
import 'package:flutter/material.dart';
import '../confirm/confirm_payment_view.dart';

class TourCreatingView extends StatefulWidget {
  const TourCreatingView({super.key});
  @override
  State<StatefulWidget> createState() => _TourCreatingViewState();
}

class _TourCreatingViewState extends State<TourCreatingView> {
  final TourCreatingViewModel tourCreatingViewModel = TourCreatingViewModel();
  late Future<List<Place>> cartPlacesData;
  late Future<List<Tour>> cartTourData;
  late List<Place> listPlacesCreating;
  late List<Tour> listTourBooking;
  late double totalPrice = 0.0;

  @override
  void initState() {
    cartPlacesData = tourCreatingViewModel.getPlacesFromCart();
    cartTourData = tourCreatingViewModel.getToursFromCart();

    cartPlacesData.then((value) {
      listPlacesCreating = value;
      //tourCreatingViewModel.getTotalPrice().then((value) => totalPrice = value);
    });

    cartTourData.then((value) {
      listTourBooking = value;
      tourCreatingViewModel
          .getToursTotalPrice()
          .then((value) => totalPrice = value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<List<Tour>>(
        future: cartTourData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 40 / 812,
                  left: screenWidth * 15 / 375,
                  right: screenWidth * 15 / 375),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      context.tr('tour_creating'),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TourVisionViewV2()));
                      },
                      child: Text(
                        context.tr('manage_places'),
                        style: const TextStyle(
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
                        listTourBooking.length,
                        (index) => Container(
                          margin: EdgeInsets.only(
                              top: index == 0 ? screenHeight * 20 / 812 : 0,
                              bottom: screenHeight * 20 / 812),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(listTourBooking[index]
                                            .image ??
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1mNtxgS1qmFueq76nVLu7QLv5F2-McAsvpg&usqp=CAU'),
                                  ),
                                ),
                                width: screenWidth * 124 / 375,
                                height: screenWidth * 124 / 375,
                              ),
                              SizedBox(
                                width: screenWidth * 10 / 375,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: screenHeight * 124 / 812,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              listTourBooking[index].name!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'Steamed milk and mocha sauce \ntopped with sweeten...',
                                        style: TextStyle(
                                            color: AppColors.grayTextColor),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.card_travel_sharp,
                                            color: AppColors.cardColor,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 5 / 375),
                                          Text(
                                            '\$${listTourBooking[index].total} USD',
                                            style: const TextStyle(
                                                color:
                                                    AppColors.priceTextColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 10 / 812),
                Row(
                  children: [
                    SizedBox(width: screenWidth * 15 / 375),
                    Text(
                      '\$$totalPrice',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ConfirmPaymentView()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.primaryColor,
                        ),
                        width: screenWidth * 166 / 375,
                        height: screenHeight * 43 / 812,
                        alignment: Alignment.center,
                        child: Text(
                          context.tr('payment'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 50 / 812),
              ]),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
