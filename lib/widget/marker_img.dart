import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:ting_maker/service/service.dart';

Image markerImg(int idx) {
  log('${MainProvider.base}ting/mapProfiles?idx=$idx');
  return Image.network(
    "${MainProvider.base}ting/mapProfiles?idx=$idx",
    // cacheKey: 'markerImg_${idx}_$date',
    // imageCacheName: 'markerImg_${idx}_$date',
    // cacheMaxAge: const Duration(days: 3),
  );
}
