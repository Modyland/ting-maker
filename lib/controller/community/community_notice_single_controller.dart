import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommunityNoticeSingleController extends GetxController {
  static CommunityNoticeSingleController get to => Get.find();
  Rx<dynamic> id = Get.arguments;
  final limitCount = 15;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

  PagingController<int, dynamic> get getPagingController => _pagingController;
  Rx<dynamic> get getId => id;

  @override
  void onInit() {
    super.onInit();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void onClose() {
    _pagingController.dispose();
    super.onClose();
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    //   final newItems = await service.tingApiGetdata(pageKey, limitCount);
    //   final isLastPage = newItems.length < limitCount;
    //   if (isLastPage) {
    //     _pagingController.appendLastPage(newItems);
    //   } else {
    //     final nextPageKey = pageKey + newItems.length;
    //     _pagingController.appendPage(newItems, nextPageKey);
    //   }
    // } catch (error) {
    //   _pagingController.error = error;
    // }
  }
}
