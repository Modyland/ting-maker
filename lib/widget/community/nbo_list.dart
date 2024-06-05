import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/model/nbo.dart';
import 'package:ting_maker/util/time.dart';
import 'package:ting_maker/widget/common_style.dart';

class NboListWidget extends StatelessWidget {
  const NboListWidget({
    super.key,
    required this.controller,
  });

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
      fontSize: 16,
      height: 1,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
    );
    TextStyle contentStyle = TextStyle(
      fontSize: 13,
      height: 1,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
      color: grey400,
    );
    return RefreshIndicator(
      onRefresh: () async {
        controller.getPagingController.refresh();
      },
      child: PagedListView(
        physics: const AlwaysScrollableScrollPhysics(),
        pagingController: controller.getPagingController,
        builderDelegate: PagedChildBuilderDelegate<Nbo>(
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.5, horizontal: 7),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: grey300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        item.subject,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10, height: 1),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(item.title, style: titleStyle),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Text(item.content, style: contentStyle),
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: contentStyle,
                            children: [
                              TextSpan(text: item.vilege),
                              const TextSpan(text: '·'),
                              TextSpan(text: getTimeDiff(item.writetime)),
                              const TextSpan(text: '·'),
                              TextSpan(text: item.likes.toString()),
                            ],
                          ),
                        ),
                        const Row(
                          children: [],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
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
