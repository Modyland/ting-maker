import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/service.dart';

class CommunityViewController extends GetxController {
  final Rx<Map<String, dynamic>> args = Rx(Get.arguments);
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocus = FocusNode();
  final Rx<NboDetail?> detail = Rx(null);
  final Rx<bool> isLoading = Rx(true);
  final Rx<int> imgCount = Rx(0);

  Map<String, dynamic> get getArgs => args.value;
  NboDetail? get getDetail => detail.value;
  bool get getIsLoading => isLoading.value;
  bool get getCommentFocus => commentFocus.hasFocus;

  @override
  void onReady() async {
    super.onReady();
    await detailInit();
  }

  Future<void> detailInit() async {
    final item =
        await service.getNboDetail(getArgs['idx'], personBox.get('person')!.id);
    detail(item!);
    if (item.imgIdxArr.isEmpty) {
      await Future.delayed(Durations.short2, () => isLoading(false));
    }
  }

  Future<Map<String, Object>> getLoadContentImage(
    NboDetail item,
    int idx,
  ) async {
    final image = ExtendedImage.network(
      '${MainProvider.base}nbo/nboImgSelect?imgIdx=$idx',
      cacheKey: 'nboImg_${item.idx}_$idx',
      imageCacheName: 'nboImg_${item.idx}_$idx',
      cacheMaxAge: const Duration(days: 3),
      fit: BoxFit.cover,
    ).image;

    final Completer<ImageInfo> completer = Completer();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        completer.complete(info);
        imgCount.value += 1;
        if (imgCount.value == item.imgIdxArr.length) {
          Future.delayed(Durations.short2, () => isLoading(false));
        }
      }),
    );
    final info = await completer.future;
    return {'image': image, 'info': info};
  }
}
