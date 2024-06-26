import 'dart:convert';

import 'package:get/get_connect/connect.dart';
import 'package:ting_maker/model/comment.dart';
import 'package:ting_maker/model/nbo_detail.dart';
import 'package:ting_maker/model/nbo_list.dart';

class MainProvider extends GetConnect {
  static const base = 'http://db.medsyslab.co.kr:4500/';
  @override
  void onInit() {
    super.onInit();
    httpClient
      ..baseUrl = base
      ..defaultContentType = 'application/json'
      ..timeout = const Duration(seconds: 5);
  }

  Future<Response> phoneCheck(String phone, bool check) async {
    return httpClient.get('SMS/sendSMS?id=&phone=$phone&check=$check');
  }

  Future<Response> phoneCheck2(String phone, String code) async {
    return httpClient.get('SMS/checkSMS?phone=$phone&code=$code');
  }

  Future<Response> tingApiGetdata(Map data) async {
    return httpClient.post('ting/api_getdata', body: data);
  }

  Future<Response> visibleUpdater(Map data) async {
    return httpClient.put('position/visibleUpdate', body: data);
  }

  Future<Response> getSubject(int length) async {
    return httpClient.get('nbo/nbo_Subject?length=$length');
  }

  Future<List<NboList>?> getNboSelect(int limit, String id,
      {String? keyword, int? idx}) async {
    String url = 'nbo/nboSelect?limit=$limit&id=$id';
    if (keyword != null) {
      url += '&keyword=$keyword';
    }
    if (idx != null) {
      url += '&idx=$idx';
    }
    final res = await httpClient.get(url);
    if (res.statusCode! <= 400) {
      final List<dynamic> data = json.decode(res.bodyString!);
      return data.map((json) => NboList.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<NboDetail?> getNboDetailSelect(int idx, String id) async {
    final res = await httpClient.get('nbo/nboClick?idx=$idx&id=$id');

    if (res.statusCode! <= 400) {
      final data = json.decode(res.bodyString!);
      final NboDetail detail = NboDetail.fromJson(data);
      return detail;
    } else {
      return null;
    }
  }

  Future<Response> nboInsert(Map data) async {
    return httpClient.post('nbo/api_post', body: data);
  }

  Future<dynamic> nboCommentInsert(Map data) async {
    final res = await httpClient.post('nbo/api_commentPost', body: data);
    if (data['kind'] == 'commentInsert') {
      if (res.statusCode! <= 400) {
        final data = json.decode(res.bodyString!);
        data['likes'] = 0;
        data['commentes'] = 0;
        data['comments'] = [];
        final Comment comment = Comment.fromJson(data);
        return comment;
      }
    } else {
      return res;
    }
  }

  Future<dynamic> nboCommentSecondInsert(Map data) async {
    final res = await httpClient.post('nbo/api_cmtCmtPost', body: data);
    if (data['kind'] == 'cmtCmtInsert') {
      if (res.statusCode! <= 400) {
        final data = json.decode(res.bodyString!);
        data['likes'] = 0;
        final Comments comments = Comments.fromJson(data);
        return comments;
      }
    } else {
      return res;
    }
  }

  Future<Response> updateLikes(Map data) async {
    return httpClient.post('likes/api_getdata', body: data);
  }
}
