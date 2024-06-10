import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';
import 'package:ting_maker/model/nbo.dart';

class MainProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient
      ..baseUrl = dotenv.get('TEST_URL')
      ..defaultContentType = 'application/json'
      ..timeout = const Duration(seconds: 3);
  }

  Future<Response> loginLog(Map data) async {
    return httpClient.post('/Login_log/api_getdata', body: data);
  }

  Future<Response> phoneCheck(String phone, bool check) async {
    return httpClient.get('/SMS/sendSMS?id=&phone=$phone&check=$check');
  }

  Future<Response> phoneCheck2(String phone, String code) async {
    return httpClient.get('/SMS/checkSMS?phone=$phone&code=$code');
  }

  Future<Response> tingApiGetdata(Map data) async {
    return httpClient.post('/ting/api_getdata', body: data);
  }

  Future<Response> visibleUpdater(Map data) async {
    return httpClient.put('/position/visibleUpdate', body: data);
  }

  Future<Response> getSubject(int length) async {
    return httpClient.get('/nbo/nbo_Subject?length=$length');
  }

  Future<List<Nbo>?> getNboSelect(
    int limit, {
    String? id,
    String? keyword,
    int? idx,
  }) async {
    String url = '/nbo/nboSelect?limit=$limit';
    if (id != null) {
      url += '&id=$id';
    }
    if (keyword != null) {
      url += '&keyword=$keyword';
    }
    if (idx != null) {
      url += '&idx=$idx';
    }
    final res = await httpClient.get(url);
    if (res.statusCode! <= 400) {
      final List<dynamic> data = json.decode(res.bodyString!);
      return data.map((json) => Nbo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<Response> nboInsert(Map data) async {
    return httpClient.post('/nbo/api_post', body: data)
      ..timeout(const Duration(seconds: 10));
  }
}
