import 'package:flutter_naver_map/flutter_naver_map.dart';

class Cluster {
  double latitudeSum = 0;
  double longitudeSum = 0;
  int count = 0;
  Set<NMarker> markers;

  Cluster(double latitude, double longitude, this.markers) {
    latitudeSum = latitude;
    longitudeSum = longitude;
    count = markers.length;
  }

  void addMarker(NMarker marker) {
    markers.add(marker);
    latitudeSum += marker.position.latitude;
    longitudeSum += marker.position.longitude;
    count++;
  }

  void addUser() {
    // 사용자 정보 추가해야 리스트로 보여줌
  }

  NLatLng get averageLocation {
    return NLatLng(latitudeSum / count, longitudeSum / count);
  }
}
