import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_list.dart';

class CommunityNoticeSingleController extends GetxController {
  static CommunityNoticeSingleController get to => Get.find();
  Rx<dynamic> id = Rx(Get.arguments);
  final limitSize = 10;
  final PagingController<int, NboList> _pagingController =
      PagingController(firstPageKey: 0);

  PagingController<int, NboList> get getPagingController => _pagingController;
  String get getId => id.value;

  @override
  void onInit() {
    super.onInit();
    _pagingController.addPageRequestListener((pageKey) async {
      await _fetchPage(pageKey);
    });
  }

  @override
  void onClose() {
    _pagingController.dispose();
    super.onClose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await service.getNboSelect(
        limitSize,
        keyword: getId,
        idx: pageKey != 0 ? _pagingController.itemList?.last.idx : null,
      );
      if (newItems != null) {
        final isLastPage = newItems.length < limitSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
