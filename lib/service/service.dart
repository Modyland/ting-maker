import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';

class MainProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = dotenv.get('TEST_URL')
      ..defaultContentType = 'application/json'
      ..timeout = const Duration(seconds: 10);
    // ..addRequestModifier<dynamic>((request) {
    //   request.headers['Authorization'] = 'token value';
    //   return request;
    // });
  }

  Future<Response> phoneCheck(String phone) => httpClient.get(
        '/SMS/sendSMS?id=&phone=$phone',
      );
  Future<Response> phoneCheck2(String phone, String code) => httpClient.get(
        '/SMS/checkSMS?phone=$phone&code=$code',
      );
  Future<Response> signupUser(Map data) =>
      httpClient.post('/ting/api_getdata', body: {data});
  // Future<Response> postCases(List<int> image) {
  //   final form = FormData({
  //     'file': MultipartFile(image, filename: 'avatar.png'),
  //     'otherFile': MultipartFile(image, filename: 'cover.png'),
  //   });
  //   return post('http://youapi/users/upload', form);
  // }

  // GetSocket userMessages() {
  //   return socket('https://yourapi/users/socket');
  // }
}
