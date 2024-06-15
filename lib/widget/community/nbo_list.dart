import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/community/nbo_item.dart';

class NboListWidget extends StatelessWidget {
  const NboListWidget({
    super.key,
    required this.controller,
  });

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: pointColor,
      onRefresh: () async {
        controller.getPagingController.refresh();
      },
      child: PagedListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        pagingController: controller.getPagingController,
        builderDelegate: PagedChildBuilderDelegate<NboList>(
          itemBuilder: (context, item, idx) {
            return nboItem(context, item, controller.goDetail);
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
                onPressed: () => controller.getPagingController.refresh(),
                child: const Text('다시 시도'),
              ),
            );
          },
          newPageErrorIndicatorBuilder: (context) {
            return Center(
              child: TextButton(
                onPressed: () =>
                    controller.getPagingController.retryLastFailedRequest(),
                child: const Text('다시 시도'),
              ),
            );
          },
        ),
      ),
    );
  }
}
