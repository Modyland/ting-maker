import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/model/nbo.dart';
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
      onRefresh: () async {
        controller.getPagingController.refresh();
      },
      child: PagedListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        pagingController: controller.getPagingController,
        builderDelegate: PagedChildBuilderDelegate<Nbo>(
          itemBuilder: (context, item, idx) {
            return nboItem(item, titleStyle, contentStyle);
          },
          firstPageProgressIndicatorBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
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
