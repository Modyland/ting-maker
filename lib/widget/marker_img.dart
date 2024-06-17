import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/widget/common_style.dart';

ImageProvider<Object> markerImg(int idx) {
  return ExtendedImage.network(
    "${service.baseUrl}ting/mapProfiles?idx=$idx",
    cache: true,
    cacheKey: 'markerImg_$idx',
    imageCacheName: 'markerImg_$idx',
    cacheMaxAge: const Duration(days: 3),
    loadStateChanged: (state) {
      if (state.extendedImageLoadState == LoadState.loading) {
        return Center(child: CircularProgressIndicator(color: pointColor));
      }
      return null;
    },
  ).image;
}
