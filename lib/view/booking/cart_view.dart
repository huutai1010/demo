import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/payment/choosepayment_view.dart';
import 'package:etravel_mobile/view/place/place_detail_viewv2.dart';
import 'package:etravel_mobile/view_model/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var cartViewModel = CartViewModel();
  late Future<List<Place>> cartPlaceData;
  final _style1 = const TextStyle(fontSize: 25, fontWeight: FontWeight.w400);
  var bookingPlaceItems = <Place>[];
  final ScrollController scrollController = ScrollController();
  var style8 = const TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  var style9 = const TextStyle(color: AppColors.primaryColor, fontSize: 12);

  @override
  void initState() {
    cartPlaceData = cartViewModel.getCartPlace();
    cartPlaceData.then((places) => bookingPlaceItems = places);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartViewModel>(
      create: (context) => cartViewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Cart'),
          actions: [
            TextButton(
                onPressed: () async {
                  await cartViewModel.removeAllBookingItems();
                  bookingPlaceItems = [];
                  setState(() {});
                },
                child: const Text('Delete all')),
            const SizedBox(width: 10),
          ],
        ),
        body: Stack(
          children: [
            _buildCartInfos(scrollController),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Hidable(
                  preferredWidgetSize: const Size.fromHeight(74),
                  controller: scrollController,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -2),
                        color: Colors.grey.withOpacity(.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ]),
                    height: 74,
                    child: Row(children: [
                      const SizedBox(width: 40),
                      FutureBuilder<double>(
                        future: cartViewModel.getCartPrice(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('\$${cartViewModel.price}',
                                style: style8);
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                      Text('/${context.tr('total')}', style: style9),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChoosePaymentView(
                              places: bookingPlaceItems,
                              isCustomTour: true,
                              price: cartViewModel.price,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor,
                          ),
                          width: 173,
                          height: 52,
                          child: Text(
                            context.tr('payment'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildCartInfos(ScrollController controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          FutureBuilder<List<Place>>(
            future: cartPlaceData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bookingPlaceItems.isNotEmpty
                          ? Text(context.tr('places'), style: _style1)
                          : const Text(''),
                      Column(
                        children: List.generate(
                          bookingPlaceItems.length,
                          (index) {
                            var bookingItem = bookingPlaceItems[index];
                            var place = bookingItem;
                            return _buildBookingItem(
                              place.placeImages![0].url!,
                              place.name!,
                              place.price!,
                              placeId: bookingItem.id!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Dismissible _buildBookingItem(String image, String name, double price,
      {int? placeId, int? tourId}) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final confirmed = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure you want to delete?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    if (placeId != null) {
                      await cartViewModel
                          .deletePlaceInCart(placeId)
                          .then((value) async {
                        await cartViewModel.getCartPrice().then((value) {
                          Navigator.pop(context, true);
                          setState(() {});
                        });
                      });
                    }
                  },
                  child: const Text('Yes'),
                )
              ],
            );
          },
        );
        return confirmed;
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailsViewV2(placeId: placeId!),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 124,
                height: 124,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined),
                    const SizedBox(width: 10),
                    Text('\$$price USD'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
