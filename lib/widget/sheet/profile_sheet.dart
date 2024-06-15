import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/cluster.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/dialog/profile_dialog.dart';

Future<void> showProfileSheet(List<dynamic> users, Cluster cluster) async {
  return await Get.bottomSheet(
    Container(
      height: MyApp.height * 0.4,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: ListView.builder(
        itemCount: cluster.idxs.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final userIdx = cluster.idxs[index];
          final user =
              users.firstWhere((u) => u['userIdx'].toString() == userIdx);
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: pointColor.withAlpha(100),
                backgroundImage: ExtendedImage.network(
                  "${baseUrl}ting/mapProfiles?idx=$userIdx",
                  cache: true,
                  cacheKey: 'markerImg$userIdx',
                  imageCacheName: 'markerImg$userIdx',
                  cacheMaxAge: const Duration(days: 3),
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Center(
                          child: CircularProgressIndicator(color: pointColor));
                    }
                    return null;
                  },
                ).image,
              ),
              title: Text(
                '${user['aka']}',
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () async {
                await showProfileDialog(userIdx);
              },
            ),
          );
        },
      ),
    ),
    ignoreSafeArea: true,
    backgroundColor: Colors.transparent,
  );
}
