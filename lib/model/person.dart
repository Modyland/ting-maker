import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  final num idx;
  @HiveField(1)
  final String id;
  @HiveField(2)
  String phone;
  @HiveField(3)
  final String birth;
  @HiveField(4)
  final String gender;
  @HiveField(5)
  int visible;
  @HiveField(6)
  String? profile;
  @HiveField(7)
  String? aka;

  Person({
    required this.idx,
    required this.id,
    required this.phone,
    required this.birth,
    required this.gender,
    required this.visible,
    this.profile,
    this.aka,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      idx: json['idx'],
      id: json['id'],
      phone: json['phone'],
      birth: json['birth'],
      gender: json['gender'],
      visible: json['visible'],
      profile: json['profile'],
      aka: json['aka'],
    );
  }
}
