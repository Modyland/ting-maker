import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/service/navigation_service.dart';

class CommunityNoticeSingleController extends GetxController {
  static CommunityNoticeSingleController get to => Get.find();
  final Rx<String> id = Rx(Get.arguments);
  final RxList<Rx<NboList>> nboList = RxList<Rx<NboList>>([]);
  final PagingController<int, Rx<NboList>> _pagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, Rx<NboList>> get getPagingController =>
      _pagingController;
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
        CommunityController.to.limitSize,
        NavigationProvider.to.getPerson.id,
        keyword: getId,
        idx: pageKey != 0 ? _pagingController.itemList?.last.value.idx : null,
      );
      if (newItems != null) {
        nboList.addAll(newItems.map((e) => e.obs));
        final startIndex = pageKey * CommunityController.to.limitSize;
        final endIndex = startIndex + newItems.length;
        final data = nboList.sublist(startIndex, endIndex);
        final isLastPage = newItems.length < CommunityController.to.limitSize;
        if (isLastPage) {
          _pagingController.appendLastPage(data);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(data, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> goDetail(int idx) async {
    Get.toNamed('/home/community_view',
        arguments: {'idx': idx, 'to': 'community_notice'});
  }
}
