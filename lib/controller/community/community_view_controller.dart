import 'dart:async';
import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/comment.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityViewController extends GetxController {
  final picker = ImagePicker();
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode commentFocus = FocusNode();

  final Rx<Map<String, dynamic>> args = Rx(Get.arguments);
  final Rx<NboDetail?> detail = Rx(null);
  final RxList<Comment> comment = RxList([]);
  final RxList<RxMap<String, dynamic>> comments = RxList([]);
  final Rx<int> imgCount = Rx(0);
  final Rx<bool> isLoading = Rx(true);
  final Rx<bool> isFocusing = Rx(false);
  final RxList<Uint8List> regiImage = RxList<Uint8List>([]);
  final RxMap<String, int> repleData = RxMap({'commentIdx': -1, 'userIdx': -1});

  Map<String, dynamic> get getArgs => args.value;
  NboDetail? get getDetail => detail.value;
  bool get getIsLoading => isLoading.value;
  bool get getCommentFocus => isFocusing.value;
  bool get getReple {
    if (repleData['commentIdx'] == -1 && repleData['userIdx'] == -1) {
      return false;
    }
    return true;
  }

  List<Comment> get sortingComment {
    final data = comment.toList()
      ..sort((a, b) {
        int likeCompare = a.likes.compareTo(b.likes);
        if (likeCompare == 0) {
          final aDateTime = DateTime.parse(a.writeTime.replaceAll(' ', 'T'));
          final bDateTime = DateTime.parse(b.writeTime.replaceAll(' ', 'T'));
          return bDateTime.compareTo(aDateTime);
        }
        return likeCompare;
      });
    return data;
  }

  List<Comments> sortingComments(List<Comments> co) {
    final data = co
      ..sort((a, b) {
        int likeCompare = a.likes.compareTo(b.likes);
        if (likeCompare == 0) {
          final aDateTime = DateTime.parse(a.writeTime.replaceAll(' ', 'T'));
          final bDateTime = DateTime.parse(b.writeTime.replaceAll(' ', 'T'));
          return bDateTime.compareTo(aDateTime);
        }
        return likeCompare;
      });
    return data;
  }

  @override
  void onReady() async {
    super.onReady();
    await detailInit();
    commentFocus.addListener(() => isFocusing(commentFocus.hasFocus));
  }

  Future<void> detailInit() async {
    try {
      final item = await service.getNboDetailSelect(
        getArgs['idx'],
        NavigationProvider.to.getPerson.id,
      );
      if (item != null) {
        detail(item);
        comment.addAll(item.comment);
        for (var comment in item.comment) {
          comments.add(RxMap({'idx': comment.idx, 'data': comment.comments}));
        }
        log('$comments');
        if (item.img.isEmpty) {
          await Future.delayed(Durations.short2, () => isLoading(false));
        }
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  Future<Map<String, Object>> getLoadContentImage(
      NboDetail item, int idx) async {
    //  ?   /commentImgSelect  // 댓글
    //  ?   /cmtCmtImgSelect  //대댓글
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
        if (getReple) {
          final req = {
            "kind": 'cmtCmtInsert',
            'useridx': NavigationProvider.to.getPerson.idx,
            'id': NavigationProvider.to.getPerson.id,
            'nboNum': getDetail!.idx,
            'commentNum': repleData['commentIdx'],
            'aka': NavigationProvider.to.getPerson.aka,
            'content': commentController.text,
            'img': regiImage.toList().isNotEmpty ? regiImage.toList() : null,
          };
          final res = await service.nboCommentSecondInsert(req);
          (comments.firstWhere((item) => item['idx'] == res!.commentNum)['data']
                  as List)
              .add(res);
          cancelReple();
        } else {
          final req = {
            'kind': 'commentInsert',
            'useridx': NavigationProvider.to.getPerson.idx,
            'id': NavigationProvider.to.getPerson.id,
            'postNum': getDetail!.idx,
            'aka': NavigationProvider.to.getPerson.aka,
            'content': commentController.text,
            'img': regiImage.toList().isNotEmpty ? regiImage.toList() : null,
          };
          final res = await service.nboCommentInsert(req);
          comment.add(res!);
        }
        commentController.clear();
      }
    } catch (err) {
      log('$err');
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  void commentReple(int commentNum, int userIdx) {
    repleData({'commentIdx': commentNum, 'userIdx': userIdx});
    commentFocus.requestFocus();
    showKeyboard();
  }

  void cancelReple() {
    repleData({'commentIdx': -1, 'userIdx': -1});
  }

  void showKeyboard() {
    FocusScope.of(Get.context!).requestFocus(commentFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = commentFocus.context;
      if (context != null) {
        SystemChannels.textInput.invokeMethod('TextInput.show');
      }
    });
  }

  // void hideKeyboard() {
  //   FocusScope.of(Get.context!).unfocus();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     SystemChannels.textInput.invokeMethod('TextInput.hide');
  //   });
  // }
}
