import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../common/common_app_bar.dart';
import 'transaction_header.dart';
import 'transaction_list_view.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: Text(
          context.tr('transactions'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(),
      ),
      body: const Column(
        children: [
          TransactionHeader(),
          Expanded(
            child: TransactionListView(),
          ),
        ],
      ),
    );
  }
}
