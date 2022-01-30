import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:router_go/database/model/inventory_model.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

class LazyScrollView extends StatefulWidget {
  const LazyScrollView({Key? key}) : super(key: key);

  @override
  State<LazyScrollView> createState() => _LazyScrollViewState();
}

class _LazyScrollViewState extends State<LazyScrollView> {
  static const _pageSize = 20;

  final PagingController<int, Inventory> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    // final newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
    // final isLastPage = newItems.length < _pageSize;
    // if (isLastPage) {
    // _pagingController.appendLastPage(newItems);
    // } else {
    // final nextPageKey = pageKey + newItems.length;
    // _pagingController.appendPage(newItems, nextPageKey);
    // }
    // } catch (error) {
    //   _pagingController.error = error;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Inventory>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Inventory>(
        itemBuilder: (context, item, index) => ListTile(),
      ),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
