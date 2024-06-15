import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ting_maker/icons/tingicons_icons.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_list.dart';
import 'package:ting_maker/util/time.dart';
import 'package:ting_maker/widget/common_style.dart';

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

InkWell nboItem(
  BuildContext context,
  NboList item,
  Future<void> Function(int) callback,
) {
  return InkWell(
    onTap: () async {
      await callback(item.idx);
    },
    child: Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 3),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: grey100),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                nboSubjectBadge(item),
                nboTitleContent(item, titleStyle),
                Text.rich(
                  TextSpan(
                    style: contentStyle,
                    children: [
                      TextSpan(text: item.vilege),
                      const TextSpan(text: ' · '),
                      TextSpan(text: getTimeDiff(item.writetime)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: item.isImg == 1
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (item.isImg == 1) nboFirstImg(item),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Tingicons.heart, color: grey400, size: 16),
                        Text('\t${item.likes}', style: contentStyle),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Tingicons.comment, color: grey400, size: 16),
                        Text('\t${item.commentes}', style: contentStyle),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

SizedBox nboFirstImg(NboList item) {
  return SizedBox(
    width: double.infinity,
    height: 80,
    child: Card(
      elevation: 4,
      shadowColor: grey200,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: ExtendedImage.network(
        '${baseUrl}nbo/nboImgFirstSelect?nboidx=${item.idx}',
        cacheKey: 'nboFirstImg${item.idx}',
        imageCacheName: 'nboFirstImg${item.idx}',
        cacheMaxAge: const Duration(days: 3),
        fit: BoxFit.cover,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState == LoadState.loading) {
            return Center(child: CircularProgressIndicator(color: pointColor));
          }
          return null;
        },
      ),
    ),
  );
}

Column nboTitleContent(
  NboList item,
  TextStyle titleStyle,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(item.title, style: titleStyle, maxLines: 1),
      ),
      Text(item.content.splitMapJoin('\n', onMatch: (m) => ' '),
          style: contentStyle, maxLines: 1),
    ],
  );
}

Container nboSubjectBadge(NboList item) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
    decoration: BoxDecoration(
      color: grey300,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    child: Text(
      item.subject,
      style: const TextStyle(color: Colors.white, fontSize: 10, height: 1),
    ),
  );
}
