import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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

InkWell nboItem(NboList item, TextStyle titleStyle, TextStyle contentStyle) {
  return InkWell(
    onTap: () {},
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
            flex: item.isImg == 1 ? 8 : 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                nboSubjectBadge(item),
                nboTitleContent(item, titleStyle, contentStyle),
                Text.rich(
                  TextSpan(
                    style: contentStyle,
                    children: [
                      TextSpan(text: item.vilege),
                      const TextSpan(text: '·'),
                      TextSpan(text: getTimeDiff(item.writetime)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: item.isImg == 1 ? 2 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: item.isImg == 1
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (item.isImg == 1) nboFirstImg(item),
                const Text('1234')
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
      color: pointColor.withAlpha(30),
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
      ),
    ),
  );
}

Column nboTitleContent(
    NboList item, TextStyle titleStyle, TextStyle contentStyle) {
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
