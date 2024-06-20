import 'package:ting_maker/model/comment.dart';

class NboDetail {
  final int idx;
  final int useridx;
  final String writetime;
  final String aka;
  final int likes;
  final String vilege;
  final String subject;
  final String title;
  final String content;
  final int commentes;
  final List<int> img;
  final List<Comment> comment;

  NboDetail({
    required this.idx,
    required this.useridx,
    required this.writetime,
    required this.aka,
    required this.likes,
    required this.vilege,
    required this.subject,
    required this.title,
    required this.content,
    required this.commentes,
    required this.img,
    required this.comment,
  });

  factory NboDetail.fromJson(Map<String, dynamic> json) {
    return NboDetail(
      idx: json['idx'],
      useridx: json['useridx'],
      writetime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      vilege: json['vilege'],
      subject: json['subject'],
      title: json['title'],
      content: json['content'],
      commentes: json['commentes'],
      img: List<int>.from(json['imgIdxArr']),
      comment: (json['commentDto'] as List<dynamic>)
          .map((item) => Comment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'useridx': useridx,
      'writetime': writetime,
      'aka': aka,
      'likes': likes,
      'vilege': vilege,
      'subject': subject,
      'title': title,
      'content': content,
      'commentes': commentes,
      'imgIdxArr': img,
      'commentDto': comment,
    };
  }
}
