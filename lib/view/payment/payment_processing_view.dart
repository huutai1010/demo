import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/successful/payment_successful_view.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentProcessingView extends StatefulWidget {
  final String paymentUrl;
  const PaymentProcessingView({required this.paymentUrl, super.key});

  @override
  State<PaymentProcessingView> createState() => _PaymentProcessingViewState();
}

class _PaymentProcessingViewState extends State<PaymentProcessingView> {
  bool isConfirming = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageStarted: (url) {
                      if (url.contains('/transactions/confirm')) {
                        setState(() {
                          isConfirming = true;
                        });
                        BookingRepository().confirmBooking(url).then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentSuccessfulView(),
                            ),
                          );
                        }).catchError((err) {
                          print('Confirming failed');
                        });
                      }
                    },
                    onNavigationRequest: (_) {
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.paymentUrl)),
            ),
            isConfirming
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: AppColors.backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const Stack(),
          ],
        ),
      ),
    );
  }
}
