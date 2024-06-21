import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ting_maker/controller/community/community_view_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/comment.dart';
import 'package:ting_maker/model/nbo_detail.dart';
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
        if (item.img.isNotEmpty) const SizedBox(height: 7),
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
      ],
    ),
  );
}

Container nboDetailComment(NboDetail item) {
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
        if (item.comment.isNotEmpty)
          for (var i = 0; i < item.comment.length; i++)
            nboCommentProfile(item.comment[i], i, item.comment.length)
      ],
    ),
  );
}

Container nboCommentProfile(Comment item, int index, int length) {
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: Text(
            item.content,
            style: const TextStyle(color: Colors.black, height: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
          child: Text.rich(
              maxLines: 1,
              TextSpan(children: [
                TextSpan(
                    text: '답글 달기',
                    style: TextStyle(color: grey400, fontSize: 12, height: 1),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
              ])),
        ),
        if (item.comments.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: nboCommentReple(item.comments),
          )
      ],
    ),
  );
}

List<Widget> nboCommentReple(List<Comments> comments, {int maxComments = 3}) {
  final List<Widget> commentWidgets = [];
  final int numComments = comments.length;
  if (numComments > maxComments) {
    commentWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            // 더보기 버튼 클릭 시 추가 comments 보여주는 로직 구현
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('더보기', style: TextStyle(color: Colors.blue)),
              Icon(Icons.arrow_drop_down, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  } else {
    for (var i = 0; i < numComments; i++) {
      commentWidgets.add(Padding(
        padding:
            EdgeInsets.fromLTRB(10, 4, 0, comments.length - 1 == i ? 0 : 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                nboProfileIcon(comments[i].userIdx, 30, 15),
                const SizedBox(width: 7),
                nboProfileId(comments[i].aka, comments[i].writeTime,
                    small: true)
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
              child: Text(
                comments[i].content,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black, height: 1),
              ),
            ),
          ],
        ),
      ));
    }
  }

  return commentWidgets;
}
