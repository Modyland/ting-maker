class UserModel {
  final num idx;
  final String id;
  final String phone;
  final String birth;
  final String gender;
  final String? profile;
  final String? aka;

  UserModel({
    required this.idx,
    required this.id,
    required this.phone,
    required this.birth,
    required this.gender,
    this.profile,
    this.aka,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idx: json['idx'],
      id: json['id'],
      phone: json['phone'],
      birth: json['birth'],
      gender: json['gender'],
      profile: json['profile'],
      aka: json['aka'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idx': idx,
        'id': id,
        'phone': phone,
        'birth': birth,
        'gender': gender,
        'profile': profile,
        'aka': aka,
      };
}
