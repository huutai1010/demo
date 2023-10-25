import 'package:etravel_mobile/view/transaction/transaction_detail_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/transaction_overview.dart';
import 'package:flutter/material.dart';

import '../../repository/transaction_repository.dart';
import '../../widgets/transaction_item.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({
    super.key,
  });

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  static const _pageSize = 10;

  final PagingController<int, TransactionOverview> _pagingController =
      PagingController(firstPageKey: 0);
  Future<void> _getTransaction(int pageKey) async {
    try {
      final response =
          await TransactionRepository().getTransactions(pageKey, _pageSize);
      final responseData = (response['transactions']['data'] as List<dynamic>)
          .map((responseItem) {
        return TransactionOverview.fromJson(responseItem);
      }).toList();
      final isLastPage = responseData.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(responseData);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(responseData, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getTransaction(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
        ],
      ),
      child: PagedListView<int, TransactionOverview>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<TransactionOverview>(
          itemBuilder: (ctx, item, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        TransactionDetailView(transactionId: item.id),
                  ),
                );
              },
              child: TransactionItem(
                transaction: item,
              ),
            );
          },
        ),
      ),
    );
  }
}
