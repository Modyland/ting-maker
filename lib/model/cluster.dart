import 'package:flutter_naver_map/flutter_naver_map.dart';

class Cluster {
  int count = 0;
  double latitudeSum = 0;
  double longitudeSum = 0;
  Set<NMarker> markers;

  Cluster(
    double latitude,
    double longitude,
    this.markers,
  ) {
    count = markers.length;
    latitudeSum = latitude;
    longitudeSum = longitude;
  }

  void addMarker(NMarker marker) {
    count++;
    latitudeSum += marker.position.latitude;
    longitudeSum += marker.position.longitude;
    markers.add(marker);
  }

  NLatLng get averageLocation {
    return NLatLng(latitudeSum / count, longitudeSum / count);
  }
}
