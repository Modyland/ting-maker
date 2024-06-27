import 'package:flutter_naver_map/flutter_naver_map.dart';

class Cluster {
  int count = 0;
  double latitudeSum = 0;
  double longitudeSum = 0;
  Set<NMarker> markers;
  List<String> idxs;

  Cluster(double latitude, double longitude, this.markers, this.idxs) {
    count = markers.length;
    idxs = idxs;
    latitudeSum = latitude;
    longitudeSum = longitude;
  }

  void addMarker(NMarker marker, String key) {
    count++;
    latitudeSum += marker.position.latitude;
    longitudeSum += marker.position.longitude;
    markers.add(marker);
    idxs.add(key);
  }

  NLatLng get averageLocation {
    return NLatLng(latitudeSum / count, longitudeSum / count);
  }
}
