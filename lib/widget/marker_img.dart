import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ting_maker/service/service.dart';
import 'package:ting_maker/widget/common_style.dart';

ImageProvider<Object> markerImg(int idx, {String? date}) {
  return ExtendedImage.network(
    "${MainProvider.base}ting/mapProfiles?idx=$idx",
    cache: false,
    // cacheKey: 'markerImg_${idx}_$date',
    // imageCacheName: 'markerImg_${idx}_$date',
    // cacheMaxAge: const Duration(days: 3),
    loadStateChanged: (state) {
      if (state.extendedImageLoadState == LoadState.loading) {
        return Center(child: CircularProgressIndicator(color: pointColor));
      }
      return null;
    },
  ).image;
}
