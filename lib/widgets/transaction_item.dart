import 'package:etravel_mobile/models/transaction_overview.dart';
import 'package:etravel_mobile/view/common/border_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionOverview transaction;
  const TransactionItem({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(DateFormat.Hm().format(transaction.createTime!)),
          const SizedBox(
            width: 10,
          ),
          const BorderIcon(
            icon: Icon(
              Icons.arrow_right_alt_sharp,
              size: 20,
              color: Colors.white,
            ),
            backgroundColor: Color(0xff20c7af),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'No. ${transaction.id}',
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '-${transaction.amount.toStringAsFixed(2)} USD',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
