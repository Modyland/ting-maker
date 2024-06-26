import 'dart:async';
import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community/community_notice_single_controller.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/comment.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/util/overlay.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityViewController extends GetxController {
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
  final RxMap<String, dynamic> repleData =
      RxMap({'commentIdx': -1, 'userIdx': -1, 'aka': ''});

  Map<String, dynamic> get getArgs => args.value;
  NboDetail? get getDetail => detail.value;
  bool get getIsLoading => isLoading.value;
  bool get getCommentFocus => isFocusing.value;
  bool get getReple =>
      repleData['commentIdx'] != -1 && repleData['userIdx'] != -1;

  @override
  void onReady() async {
    super.onReady();
    await detailInit();
    commentFocus.addListener(() => isFocusing(commentFocus.hasFocus));
  }

  void changeCommentCount(bool flag, int len) {
    detail.update((v) => v!.commentCount += flag ? len : -len);
    final listIdx = CommunityController.to.nboList
        .indexWhere((item) => item.value.idx == detail.value?.idx);
    CommunityController.to.nboList[listIdx]
        .update((v) => v!.commentes += flag ? len : -len);
    if (args.value['to'] == 'community_notice') {
      final listIdx = CommunityNoticeSingleController.to.nboList
          .indexWhere((item) => item.value.idx == detail.value?.idx);
      CommunityNoticeSingleController.to.nboList[listIdx]
          .update((v) => v!.commentes += flag ? len : -len);
    }
  }

  void changeLikeCount(bool flag) {
    final listIdx = CommunityController.to.nboList
        .indexWhere((item) => item.value.idx == detail.value?.idx);
    CommunityController.to.nboList[listIdx]
        .update((v) => v!.likes += flag ? 1 : -1);
    if (args.value['to'] == 'community_notice') {
      final listIdx = CommunityNoticeSingleController.to.nboList
          .indexWhere((item) => item.value.idx == detail.value?.idx);
      CommunityNoticeSingleController.to.nboList[listIdx]
          .update((v) => v!.likes += flag ? 1 : -1);
    }
  }

  Future<void> detailInit() async {
    try {
      comment.clear();
      comments.clear();
      final item = await service.getNboDetailSelect(
        getArgs['idx'],
        NavigationProvider.to.getPerson.id,
      );
      if (item != null) {
        detail(item);
        comment.addAll(item.comment);
        for (var comment in item.comment) {
          comments.add(
            RxMap({
              'idx': comment.idx,
              'data': comment.comments,
              'showCount': 3,
            }),
          );
        }
        if (item.img.isEmpty) {
          Future.delayed(Durations.short2, () => isLoading(false));
        }
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  Future<Map<String, Object>> getLoadContentImage(
      NboDetail item, int idx) async {
    final image = ExtendedImage.network(
      '${MainProvider.base}nbo/nboImgSelect?imgIdx=$idx',
      cacheKey: 'nboImg_${item.idx}_$idx',
      imageCacheName: 'nboImg_${item.idx}_$idx',
      cacheMaxAge: const Duration(days: 3),
      fit: BoxFit.cover,
    ).image;

    final Completer<ImageInfo> completer = Completer();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) async {
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

  Future<Map<String, Object>> getLoadCommentImage(String type, int idx) async {
    final url = type == 'comment' ? 'commentImgSelect' : 'cmtCmtImgSelect';
    final image = ExtendedImage.network(
      '${MainProvider.base}nbo/$url?imgIdx=$idx',
      cacheKey: '${type}_$idx',
      imageCacheName: '${type}_$idx',
      cacheMaxAge: const Duration(days: 3),
      fit: BoxFit.cover,
    ).image;

    final Completer<ImageInfo> completer = Completer();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) async {
        completer.complete(info);
      }),
    );
    final info = await completer.future;
    return {'image': image, 'info': info};
  }

  RxMap<String, dynamic> getCommentReple(int idx) =>
      comments.firstWhere((item) => item['idx'] == idx);

  void showCommentsAdd(int idx) {
    final data = getCommentReple(idx);
    final maxCount = (data['data'] as List).length;
    final addCount = maxCount - data['showCount'];
    if (addCount > 10) {
      data['showCount'] += 10;
    } else {
      data['showCount'] += 10;
    }
  }

  Future<void> commentSubmit() async {
    try {
      if (commentController.text.isNotEmpty || regiImage.isNotEmpty) {
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
          final res = await service.nboCommentSecondInsert(req) as Comments;
          (getCommentReple(res.commentNum)['data'] as List<Comments>).add(res);
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
          final res = await service.nboCommentInsert(req) as Comment;
          comment.add(res);
          comments.add(
            RxMap({'idx': res.idx, 'data': res.comments, 'showCount': 3}),
          );
        }
        changeCommentCount(true, 1);
        commentController.clear();
        regiImage.clear();
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  void commentReple(int commentNum, int userIdx, String aka) {
    repleData({'commentIdx': commentNum, 'userIdx': userIdx, 'aka': aka});
    commentFocus.requestFocus();
    showKeyboard();
  }

  void cancelReple() {
    repleData({'commentIdx': -1, 'userIdx': -1, 'aka': ''});
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

  Future<void> updateLike(
    String kind,
    bool isInsert,
    int flag, {
    int? commentIdx,
    int? repleIdx,
  }) async {
    try {
      final req = {
        'kind': kind,
        'id': NavigationProvider.to.getPerson.id,
        'nbo_idx': getDetail!.idx,
        if (kind == 'insertComment_likes' || kind == 'deleteComment_likes')
          'comment_idx': commentIdx,
        if (kind == 'insertCmtcmt_likes' || kind == 'deleteCmtcmt_likes')
          'comment_idx': commentIdx,
        'cmtCmt_idx': repleIdx,
      };

      final res = await service.updateLikes(req);
      final data = json.decode(res.bodyString!);
      if (data) {
        _updateLikeList(kind, isInsert, flag, commentIdx, repleIdx);
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  void _updateLikeList(
    String kind,
    bool isInsert,
    int flag,
    int? commentIdx,
    int? repleIdx,
  ) {
    if (flag == 0) {
      _updateNboLikes(isInsert, getDetail!.idx);
    } else if (flag == 1) {
      _updateCommentLikes(isInsert, commentIdx);
    } else {
      _updateRepleLikes(isInsert, commentIdx, repleIdx);
    }
  }

  void _updateNboLikes(bool isInsert, int nboIdx) {
    if (isInsert) {
      NavigationProvider.to.nboLikes.add(nboIdx);
      changeLikeCount(true);
    } else {
      NavigationProvider.to.nboLikes.remove(nboIdx);
      changeLikeCount(false);
    }
  }

  void _updateCommentLikes(bool isInsert, int? commentIdx) {
    if (isInsert) {
      NavigationProvider.to.commentLikes.add(commentIdx);
      comment.firstWhere((item) => item.idx == commentIdx).likes += 1;
    } else {
      NavigationProvider.to.commentLikes.remove(commentIdx);
      comment.firstWhere((item) => item.idx == commentIdx).likes -= 1;
    }
  }

  void _updateRepleLikes(bool isInsert, int? commentIdx, int? repleIdx) {
    if (isInsert) {
      NavigationProvider.to.repleLikes.add(repleIdx);
      final data = getCommentReple(commentIdx!)['data'] as List<Comments>;
      data.firstWhere((item) => item.idx == repleIdx).likes += 1;
    } else {
      NavigationProvider.to.repleLikes.remove(repleIdx);
      final data = getCommentReple(commentIdx!)['data'] as List<Comments>;
      data.firstWhere((item) => item.idx == repleIdx).likes -= 1;
    }
  }

  void showMenuPopup({
    bool? isNbo,
    bool? isParent,
    int? commentIdx,
    int? repleIdx,
  }) {
    late Future<void> Function() delCallback;
    String updateText = '댓글 수정하기';
    String deleteText = '댓글 삭제하기';
    if (isNbo == true) {
      updateText = '게시글 수정하기';
      deleteText = '게시글 삭제하기';
    } else {
      if (isParent == false) {
        updateText = '답글 수정하기';
        deleteText = '답글 삭제하기';
      }
    }
    if (repleIdx != null) {
      delCallback = () => repleDelete(repleIdx, commentIdx!);
    } else if (commentIdx != null) {
      delCallback = () => commentDelete(commentIdx);
    } else {
      delCallback = () => nboDelete();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(
                    updateText,
                    style: TextStyle(color: grey500),
                  ),
                  onPressed: () async {
                    Get.back();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    deleteText,
                    style: TextStyle(color: errColor),
                  ),
                  onPressed: () async {
                    Get.back();
                    if (isNbo == true) {
                      OverlayManager.showOverlay(Get.overlayContext!);
                    }
                    await delCallback();
                  },
                ),
              ],
            ));
  }

  Future<void> nboDelete() async {
    try {
      final req = {
        'kind': 'nboDelete',
        'idx': getDetail!.idx,
      };
      final res = await service.nboInsert(req);
      final data = json.decode(res.bodyString!);
      if (data) {
        CommunityController.to.nboList.clear();
        CommunityController.to.getPagingController.refresh();
        Get.back();
        noTitleSnackbar('게시글이 삭제되었습니다.', time: 2);
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    } finally {
      OverlayManager.hideOverlay();
    }
  }

  Future<void> commentDelete(int idx) async {
    try {
      final req = {
        'kind': 'commentDelete',
        'idx': idx,
        'postNum': getDetail!.idx,
      };
      final res = await service.nboCommentInsert(req) as Response;
      final data = json.decode(res.bodyString!);
      if (data) {
        comment.removeWhere((item) => item.idx == idx);
        final comments = getCommentReple(idx)['data'] as List<Comments>;
        final deleteLength = comments.length + 1;
        changeCommentCount(false, deleteLength);
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }

  Future<void> repleDelete(int idx, int commentIdx) async {
    try {
      final req = {
        'kind': 'cmtCmtDelete',
        'idx': idx,
        'nboNum': getDetail!.idx,
        'commentNum': commentIdx,
      };
      final res = await service.nboCommentSecondInsert(req) as Response;
      final data = json.decode(res.bodyString!);
      if (data) {
        final comments = getCommentReple(commentIdx)['data'] as List<Comments>;
        final copy = List<Comments>.from(comments);
        copy.removeWhere((item) => item.idx == idx);
        getCommentReple(commentIdx)['data'] = copy;
        changeCommentCount(false, 1);
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    }
  }
}
