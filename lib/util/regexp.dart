class MyRegExp {
  static final RegExp phoneNumberRegex = RegExp(r'^01[0-9]{8,9}$');
  static final RegExp eightRegex = RegExp(r'.{8,}');
  static final RegExp enRegex = RegExp(r'.*[a-zA-Z].*');
  static final RegExp numRegex = RegExp(r'.*\d.*');
  static final RegExp specialRegex = RegExp(r'.*[!@#\$%^&*].*');
}
