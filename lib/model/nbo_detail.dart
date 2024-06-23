import 'package:ting_maker/model/comment.dart';

class NboDetail {
  final int idx;
  final int userIdx;
  final String writeTime;
  final String aka;
  int likes;
  final String vilege;
  final String subject;
  final String title;
  final String content;
  final List<int> img;
  int commentCount;
  final List<Comment> comment;

  NboDetail({
    required this.idx,
    required this.userIdx,
    required this.writeTime,
    required this.aka,
    required this.likes,
    required this.vilege,
    required this.subject,
    required this.title,
    required this.content,
    required this.img,
    required this.comment,
    required this.commentCount,
  });

  factory NboDetail.fromJson(Map<String, dynamic> json) {
    return NboDetail(
      idx: json['idx'],
      userIdx: json['useridx'],
      writeTime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      vilege: json['vilege'],
      subject: json['subject'],
      title: json['title'],
      content: json['content'],
      img: List<int>.from(json['imgIdxArr']),
      comment: (json['commentDto'] as List<dynamic>)
          .map((item) => Comment.fromJson(item))
          .toList(),
      commentCount: json['commentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'useridx': userIdx,
      'writetime': writeTime,
      'aka': aka,
      'likes': likes,
      'vilege': vilege,
      'subject': subject,
      'title': title,
      'content': content,
      'imgIdxArr': img,
      'commentDto': comment,
      'commentCount': commentCount,
    };
  }
}
