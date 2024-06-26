import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ting_maker/controller/community/community_view_controller.dart';
import 'package:ting_maker/icons/ting_icons_icons.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/comment.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/util/time.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/marker_img.dart';

TextStyle titleStyle =
    const TextStyle(fontSize: 20, height: 1, color: Colors.black);

TextStyle contentStyle =
    const TextStyle(fontSize: 15, height: 1, color: Colors.black);

Skeleton nboProfileIcon(int idx, double size, double radius) {
  return Skeleton.replace(
    replacement: ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: SizedBox(
        width: size,
        height: size,
        child: const ColoredBox(color: Colors.white),
      ),
    ),
    child: CircleAvatar(
      radius: radius,
      backgroundImage: markerImg(idx),
    ),
  );
}

Column nboProfileId(String aka, String writeTime, {bool small = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(aka,
          style:
              TextStyle(color: grey500, fontSize: small ? 12 : 14, height: 1)),
      const SizedBox(height: 3),
      Text(getTimeDiff(writeTime),
          style:
              TextStyle(color: grey400, fontSize: small ? 10 : 12, height: 1)),
    ],
  );
}

Container nboDetailImg({ImageInfo? info, ImageProvider<Object>? image}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: AspectRatio(
        aspectRatio:
            info != null ? info.image.width / info.image.height : 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            image: image != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: image,
                  )
                : null,
          ),
        ),
      ),
    ),
  );
}

Align nboDetailSubjectBadge(NboDetail item) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
      constraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),
      decoration: BoxDecoration(
        color: grey300,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.library_books_rounded,
              color: Colors.white, size: 16),
          const SizedBox(width: 3),
          Text(
            item.subject,
            style:
                const TextStyle(color: Colors.white, fontSize: 12, height: 1),
          ),
        ],
      ),
    ),
  );
}

Container nboDetailProfile(NboDetail item) {
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    child: Column(
      children: [
        Row(
          children: [
            nboProfileIcon(item.userIdx, 50, 25),
            const SizedBox(width: 7),
            nboProfileId(item.aka, item.writeTime)
          ],
        )
      ],
    ),
  );
}

Container nboDetailContent(NboDetail item, CommunityViewController controller) {
  final list = NavigationProvider.to.getNboLikes;
  bool isLike = list.contains(item.idx);
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.01),
          child: Text(item.title, style: titleStyle),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.01),
          child: Text(item.content, style: contentStyle),
        ),
        for (var idx in item.img)
          FutureBuilder<Map<String, Object>>(
            future: controller.getLoadContentImage(item, idx),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final image = snapshot.data!['image'] as ImageProvider;
                final info = snapshot.data!['info'] as ImageInfo;
                return nboDetailImg(info: info, image: image);
              } else {
                return nboDetailImg();
              }
            },
          ),
        GestureDetector(
          onTap: () {
            if (isLike) {
              controller.updateLike('deleteNbo_likes', false, 0);
            } else {
              controller.updateLike('insertNbo_likes', true, 0);
            }
          },
          child: Icon(
            isLike ? TingIcons.favorite : TingIcons.favorite_border,
            color: isLike ? pointColor : grey400,
          ),
        ),
        const SizedBox(height: 7),
      ],
    ),
  );
}

Container nboDetailComment(NboDetail item, CommunityViewController controller) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 3, color: grey300),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text('댓글 ${item.commentCount}'),
          ],
        ),
        if (controller.comment.isNotEmpty)
          Column(
            children: [
              for (var c in controller.comment)
                nboCommentProfile(
                  c,
                  controller.getCommentReple(c.idx)['data'],
                  controller.getCommentReple(c.idx)['showCount'],
                  (int num, int idx, String aka) =>
                      controller.commentReple(num, idx, aka),
                  () => controller.showCommentsAdd(c.idx),
                  () => controller.updateLike('insertComment_likes', true, 1,
                      commentIdx: c.idx),
                  () => controller.updateLike('deleteComment_likes', false, 1,
                      commentIdx: c.idx),
                  (i) => controller.updateLike('insertCmtcmt_likes', true, 2,
                      commentIdx: c.idx, repleIdx: i),
                  (i) => controller.updateLike('deleteCmtcmt_likes', false, 2,
                      commentIdx: c.idx, repleIdx: i),
                  controller.getLoadCommentImage,
                  () => controller.showMenuPopup(
                      isParent: true, commentIdx: c.idx),
                  (i) => controller.showMenuPopup(
                      isParent: false, commentIdx: c.idx, repleIdx: i),
                )
            ],
          )
      ],
    ),
  );
}

Column nboCommentImg(String type, int idx, Function callback) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FutureBuilder<Map<String, Object>>(
        future: callback(type, idx),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final image = snapshot.data!['image'] as ImageProvider;
            final info = snapshot.data!['info'] as ImageInfo;
            return nboDetailImg(info: info, image: image);
          } else {
            return nboDetailImg();
          }
        },
      ),
    ],
  );
}

Container nboCommentProfile(
  Comment item,
  List<Comments> data,
  int showCount,
  Function(int, int, String) callback,
  VoidCallback countAdd,
  VoidCallback addLike,
  VoidCallback removeLike,
  Function(int) addRepleLike,
  Function(int) removeRepleLike,
  Function imgCallback,
  Function showModal,
  Function(int) showModalChild,
) {
  final list = NavigationProvider.to.getCommentLikes;
  bool isLike = list.contains(item.idx);
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            nboProfileIcon(item.userIdx, 40, 20),
            const SizedBox(width: 7),
            nboProfileId(item.aka, item.writeTime),
            const Spacer(),
            if (NavigationProvider.to.getPerson.idx == item.userIdx)
              IconButton(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                splashRadius: 15,
                onPressed: () {
                  showModal();
                },
                icon: Icon(
                  Icons.more_vert,
                  color: grey400,
                ),
              )
          ],
        ),
        if (item.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              item.content,
              style: const TextStyle(color: Colors.black, height: 1),
            ),
          ),
        if (item.isImg == 1) nboCommentImg('comment', item.idx, imgCallback),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => isLike ? removeLike() : addLike(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                child: Row(
                  children: [
                    if (isLike)
                      Icon(TingIcons.favorite, color: pointColor, size: 12)
                    else
                      Icon(TingIcons.favorite_border, color: grey400, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '좋아요 ${item.likes}',
                      style: TextStyle(
                        color: isLike ? pointColor : grey400,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                callback(item.idx, item.userIdx, item.aka);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                child: Text(
                  '답글 달기',
                  style: TextStyle(color: grey400, fontSize: 12, height: 1),
                ),
              ),
            ),
          ],
        ),
        if (item.comments.isNotEmpty && data.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: nboCommentReple(
              data,
              showCount,
              countAdd,
              (i) => addRepleLike(i),
              (i) => removeRepleLike(i),
              imgCallback,
              (i) => showModalChild(i),
            ),
          )
      ],
    ),
  );
}

List<Widget> nboCommentReple(
  List<Comments> comments,
  int showCount,
  VoidCallback countAdd,
  Function(int) addRepleLike,
  Function(int) removeRepleLike,
  Function imgCallback,
  Function(int) showModalChild,
) {
  final list = NavigationProvider.to.getRepleLikes;
  final List<Widget> commentWidgets = [];
  final int numComments = comments.length;
  for (var i = 0; i < min(showCount, numComments); i++) {
    bool isLike = list.contains(comments[i].idx);
    commentWidgets.add(
      Padding(
        padding: EdgeInsets.fromLTRB(12, 4, 0, i == numComments - 1 ? 0 : 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                nboProfileIcon(comments[i].userIdx, 30, 15),
                const SizedBox(width: 7),
                nboProfileId(
                  comments[i].aka,
                  comments[i].writeTime,
                  small: true,
                ),
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    maxHeight: 30,
                  ),
                  iconSize: 17,
                  splashRadius: 15,
                  onPressed: () {
                    showModalChild(comments[i].idx);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: grey400,
                  ),
                )
              ],
            ),
            if (comments[i].content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                child: Text(
                  comments[i].content,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black, height: 1),
                ),
              ),
            if (comments[i].isImg == 1)
              nboCommentImg('reple', comments[i].idx, imgCallback),
            GestureDetector(
              onTap: () => isLike
                  ? removeRepleLike(comments[i].idx)
                  : addRepleLike(comments[i].idx),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 0, 0),
                child: Row(
                  children: [
                    if (isLike)
                      Icon(TingIcons.favorite, color: pointColor, size: 11)
                    else
                      Icon(TingIcons.favorite_border, color: grey400, size: 11),
                    const SizedBox(width: 2),
                    Text(
                      '좋아요 ${comments[i].likes}',
                      style: TextStyle(
                        color: isLike ? pointColor : grey400,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  if (numComments > showCount) {
    commentWidgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 2, 0, 0),
        child: GestureDetector(
          onTap: () {
            countAdd();
          },
          child: Text(
            '이전 ${numComments - min(showCount, numComments)}개 답글 보기',
            style: TextStyle(
              fontSize: 12,
              color: pointColor,
            ),
          ),
        ),
      ),
    );
  }
  return commentWidgets;
}
