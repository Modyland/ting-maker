import 'package:flutter/material.dart';
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

Container nboDetailProfile(NboDetail item, bool loading) {
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              backgroundImage: markerImg(item.idx),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(item.aka,
                    style: TextStyle(color: grey500, fontSize: 14, height: 1)),
                const SizedBox(height: 3),
                Text(getTimeDiff(item.writetime),
                    style: TextStyle(color: grey400, fontSize: 12, height: 1)),
              ],
            )
          ],
        )
      ],
    ),
  );
}

Container nboDetailContent(NboDetail item, CommunityViewController controller) {
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: grey300),
      ),
    ),
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
        if (item.imgIdxArr.isNotEmpty) const SizedBox(height: 7),
        for (var idx in item.imgIdxArr)
          FutureBuilder<Map<String, Object>>(
            future: controller.getLoadContentImage(item, idx),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final image = snapshot.data!['image'] as ImageProvider;
                final info = snapshot.data!['info'] as ImageInfo;
                return Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AspectRatio(
                      aspectRatio: info.image.width / info.image.height,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                );
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
    child: Column(
      children: [
        Row(
          children: [
            Text('댓글 ${item.commentDto.length}'),
          ],
        ),
        if (item.commentDto.isNotEmpty)
          for (var c in item.commentDto) nboCommentProfile(c)
      ],
    ),
  );
}

Container nboCommentProfile(Comment item) {
  return Container(
    padding: EdgeInsets.only(top: MyApp.height * 0.015),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: markerImg(item.idx),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(item.aka,
                    style: TextStyle(color: grey500, fontSize: 14, height: 1)),
                const SizedBox(height: 3),
                Text(getTimeDiff(item.writetime),
                    style: TextStyle(color: grey400, fontSize: 12, height: 1)),
              ],
            )
          ],
        ),
        Text(item.content),
      ],
    ),
  );
}
