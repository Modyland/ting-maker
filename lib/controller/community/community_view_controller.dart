import 'dart:async';
import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityViewController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocus = FocusNode();

  final Rx<Map<String, dynamic>> args = Rx(Get.arguments);
  final Rx<NboDetail?> detail = Rx(null);
  final Rx<int> imgCount = Rx(0);
  final Rx<bool> isLoading = Rx(true);
  final Rx<bool> isFocusing = Rx(false);

  Map<String, dynamic> get getArgs => args.value;
  NboDetail? get getDetail => detail.value;
  bool get getIsLoading => isLoading.value;
  bool get getCommentFocus => isFocusing.value;

  @override
  void onReady() async {
    super.onReady();
    await detailInit();
    commentFocus.addListener(() => isFocusing(commentFocus.hasFocus));
  }

  Future<void> detailInit() async {
    final item = await service.getNboDetailSelect(
      getArgs['idx'],
      personBox.get('person')!.id,
    );
    detail(item!);
    if (item.img.isEmpty) {
      await Future.delayed(Durations.short2, () => isLoading(false));
    }
  }

  Future<Map<String, Object>> getLoadContentImage(
      NboDetail item, int idx) async {
//     /commentImgSelect // 댓글
//      /cmtCmtImgSelect  //대댓글
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
        if (imgCount.value == item.img.length) {
          Future.delayed(Durations.short2, () => isLoading(false));
        }
      }),
    );
    final info = await completer.future;
    return {'image': image, 'info': info};
  }

  Future<void> commentSubmit() async {
    try {
      if (commentController.text != '') {
        final req = {
          'kind': 'commentInsert',
          'id': personBox.get('person')!.id,
          'postNum': getDetail!.idx,
          'aka': personBox.get('person')!.aka,
          'content': commentController.text
        };
        final res = await service.nboCommentInsert(req);
      }
    } catch (err) {
      log('$err');
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }
}
