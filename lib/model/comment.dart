class Comment {
  final int idx;
  final int userIdx;
  final String writeTime;
  final String id;
  final int postNum;
  final String aka;
  int likes;
  final String content;
  final int isImg;
  final int commentCount;
  final List<Comments> comments;
  String imgupDate;
  Comment({
    required this.idx,
    required this.userIdx,
    required this.writeTime,
    required this.id,
    required this.aka,
    required this.postNum,
    required this.likes,
    required this.content,
    required this.isImg,
    required this.comments,
    required this.commentCount,
    required this.imgupDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userIdx: json['useridx'],
      postNum: json['postNum'],
      idx: json['idx'],
      writeTime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      content: json['content'],
      isImg: json['isImg'],
      commentCount: json['commentes'],
      comments: (json['comments'] as List<dynamic>)
          .map((item) => Comments.fromJson(item))
          .toList(),
      imgupDate: json['imgupDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'useridx': userIdx,
      'postNum': postNum,
      'idx': idx,
      'writetime': writeTime,
      'aka': aka,
      'likes': likes,
      'content': content,
      'isImg': isImg,
      'commentes': commentCount,
      'comments': comments,
      'imgupDate': imgupDate,
    };
  }
}

class Comments {
  final int idx;
  final int userIdx;
  final String id;
  final String writeTime;
  final int nboNum;
  final int commentNum;
  final String aka;
  int likes;
  final String content;
  final int isImg;
  final int? pause;
  String imgupDate;

  Comments({
    required this.idx,
    required this.userIdx,
    required this.id,
    required this.writeTime,
    required this.nboNum,
    required this.commentNum,
    required this.aka,
    required this.likes,
    required this.content,
    required this.isImg,
    this.pause,
    required this.imgupDate,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      idx: json['idx'],
      userIdx: json['useridx'],
      id: json['id'],
      writeTime: json['writetime'],
      nboNum: json['nboNum'],
      commentNum: json['commentNum'],
      aka: json['aka'],
      likes: json['likes'],
      content: json['content'],
      isImg: json['isImg'],
      pause: json['pause'],
      imgupDate: json['imgupDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'useridx': userIdx,
      'id': id,
      'writetime': writeTime,
      'nboNum': nboNum,
      'commentNum': commentNum,
      'aka': aka,
      'likes': likes,
      'content': content,
      'isImg': isImg,
      'pause': pause,
      'imgupDate': imgupDate,
    };
  }
}
