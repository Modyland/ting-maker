import 'package:extended_image/extended_image.dart';
import 'package:ting_maker/service/service.dart';

ExtendedNetworkImageProvider markerImg(int idx) {
  return ExtendedNetworkImageProvider(
    "${MainProvider.base}ting/mapProfiles?idx=$idx",
    cache: false,
    // cacheKey: 'markerImg_${idx}_$date',
    // imageCacheName: 'markerImg_${idx}_$date',
    // cacheMaxAge: const Duration(days: 3),
  );
}
