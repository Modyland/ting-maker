import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/widget/common_style.dart';

class CommunityViewController extends GetxController {
  final Rx<NboDetail> detail = Rx(Get.arguments);
  final TextEditingController commentController = TextEditingController();
  NboDetail get getDetail => detail.value;

  RxList<Uint8List> commentImage = RxList<Uint8List>();

  Future<Map<String, Object>> getLoadContentImage(
      NboDetail item, int idx) async {
    final image = ExtendedImage.network(
      '${MainProvider.base}nbo/nboImgSelect?imgIdx=$idx',
      cacheKey: 'nboImg_${item.idx}_$idx',
      imageCacheName: 'nboImg_${item.idx}_$idx',
      cacheMaxAge: const Duration(days: 3),
      fit: BoxFit.cover,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Center(child: CircularProgressIndicator(color: pointColor));
        }
        return null;
      },
    ).image;

    final Completer<ImageInfo> completer = Completer();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        completer.complete(info);
      }),
    );
    final info = await completer.future;
    return {'image': image, 'info': info};
  }
}
