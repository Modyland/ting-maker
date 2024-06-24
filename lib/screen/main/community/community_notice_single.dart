import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community/community_notice_single_controller.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/widget/common_appbar.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/community/nbo_item.dart';

class CommunityNoticeSingleScreen
    extends GetView<CommunityNoticeSingleController> {
  const CommunityNoticeSingleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      body: RefreshIndicator(
        color: pointColor,
        onRefresh: () async {
          controller.nboList.clear();
          controller.getPagingController.refresh();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: grey200),
                ),
              ),
              child: Obx(
                () => Text(
                  controller.getId,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    height: 1,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PagedListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: controller.getPagingController,
                builderDelegate: PagedChildBuilderDelegate<Rx<NboList>>(
                  itemBuilder: (context, item, idx) {
                    return Obx(() =>
                        nboItem(context, item.value, controller.goDetail));
                  },
                  firstPageProgressIndicatorBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(color: pointColor),
                    );
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(color: pointColor),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) {
                    return Center(
                      child: TextButton(
                        onPressed: () =>
                            controller.getPagingController.refresh(),
                        child: const Text('다시 시도'),
                      ),
                    );
                  },
                  newPageErrorIndicatorBuilder: (context) {
                    return Center(
                      child: TextButton(
                        onPressed: () => controller.getPagingController
                            .retryLastFailedRequest(),
                        child: const Text('다시 시도'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
