import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';

class SampleProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = dotenv.get('HOST_URL')
      ..defaultContentType = 'application/json'
      ..timeout = const Duration(seconds: 10);
    // ..addRequestModifier<dynamic>((request) {
    //   request.headers['Authorization'] = 'token value';
    //   return request;
    // });
  }

  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', data);
  // Post request with File
  Future<Response> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
