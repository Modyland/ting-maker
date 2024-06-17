import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/util/time.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/marker_img.dart';

Container nboDetailSubjectBadge(NboDetail item) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
    decoration: BoxDecoration(
      color: grey300,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.library_books_rounded, color: Colors.white, size: 16),
        const SizedBox(width: 3),
        Text(
          item.subject,
          style: const TextStyle(color: Colors.white, fontSize: 12, height: 1),
        ),
      ],
    ),
  );
}

Container nboDetailProfile(NboDetail item) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.03),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: pointColor.withAlpha(100),
              backgroundImage: markerImg(item.idx),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.aka,
                    style: TextStyle(color: grey500, fontSize: 14, height: 1)),
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

Container nboDetailContent(NboDetail item) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.03),
          child: Text(item.title),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: MyApp.height * 0.03),
          child: Text(item.content),
        ),
        if (item.imgIdxArr.isNotEmpty)
          for (var idx in item.imgIdxArr)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExtendedImage.network(
                  '${service.baseUrl}nbo/nboImgSelect?imgIdx=$idx',
                  cacheKey: 'nboImg_${item.idx}_$idx',
                  imageCacheName: 'nboImg_${item.idx}_$idx',
                  cacheMaxAge: const Duration(days: 3),
                  fit: BoxFit.cover,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Center(
                          child: CircularProgressIndicator(color: pointColor));
                    }
                    return null;
                  },
                ).image),
              ),
            )
      ],
    ),
  );
}
