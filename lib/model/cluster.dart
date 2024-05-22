import 'package:flutter_naver_map/flutter_naver_map.dart';

class Cluster {
  int count = 0;
  double latitudeSum = 0;
  double longitudeSum = 0;
  Set<NMarker> markers;
  List<String> userIdxs;

  Cluster(double latitude, double longitude, this.markers, this.userIdxs) {
    count = markers.length;
    userIdxs = userIdxs;
    latitudeSum = latitude;
    longitudeSum = longitude;
  }

  void addMarker(NMarker marker, String userIdx) {
    count++;
    latitudeSum += marker.position.latitude;
    longitudeSum += marker.position.longitude;
    markers.add(marker);
    userIdxs.add(userIdx);
  }

  NLatLng get averageLocation {
    return NLatLng(latitudeSum / count, longitudeSum / count);
  }
}
