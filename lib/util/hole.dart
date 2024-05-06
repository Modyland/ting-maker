import 'package:flutter_naver_map/flutter_naver_map.dart';

class MainPolygon {
  String name;
  List<NLatLng> location;

  MainPolygon(this.name, this.location) {
    name = name;
    location = location;
  }
}

final Set<MainPolygon> mainPolygons = {};

// 인구 해수욕장
const firstHole = [
  NLatLng(37.97516942756443, 128.75991801561898),
  NLatLng(37.975198344759114, 128.75858722699306),
  NLatLng(37.97202838604466, 128.7585229572622),
  NLatLng(37.97133635532912, 128.75841540723474),
  NLatLng(37.970888312127585, 128.75825678322914),
  NLatLng(37.96938022407764, 128.7572990836732),
  NLatLng(37.968735596452866, 128.75703337178876),
  NLatLng(37.968002190904286, 128.756981750776),
  NLatLng(37.967640797385776, 128.75705278882614),
  NLatLng(37.96735110469308, 128.75714829348604),
  NLatLng(37.96699633659959, 128.75737879277412),
  NLatLng(37.9666041876856, 128.75769942924376),
  NLatLng(37.966201332446694, 128.75813359477476),
  NLatLng(37.9658949802756, 128.7587407389144),
  NLatLng(37.96561902948454, 128.7597241002134),
  NLatLng(37.965589739080805, 128.76168053353643),
  NLatLng(37.96570224181751, 128.76439135099707),
  NLatLng(37.96637735361385, 128.76322411673237),
  NLatLng(37.96730183906474, 128.76284796964956),
  NLatLng(37.96868708500644, 128.7629835146461),
  NLatLng(37.9691327336982, 128.76330141385847),
  NLatLng(37.969281045099414, 128.76602460114557),
  NLatLng(37.97090153386334, 128.7648913456206),
  NLatLng(37.97157863804491, 128.76569275350562),
  NLatLng(37.97276405863615, 128.76353623880672),
  NLatLng(37.972314724439904, 128.76226233747497),
  NLatLng(37.97270878627047, 128.76121344186808),
  NLatLng(37.973856370361496, 128.76037599317),
  NLatLng(37.97444629761174, 128.76008282516307),
];

// 서피비치
const secondHole = [
  NLatLng(38.031665302649834, 128.7070408312934),
  NLatLng(38.0340514784721, 128.71144695758653),
  NLatLng(38.02223482659343, 128.72914717003331),
  NLatLng(38.017891538256244, 128.72310116568127),
];
