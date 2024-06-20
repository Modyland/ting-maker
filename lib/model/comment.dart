class Comment {
  final int idx;
  final String writetime;
  final String id;
  final int postNum;
  final String aka;
  final int likes;
  final String content;
  final int isImg;
  final List<Comments> comments;

  Comment({
    required this.id,
    required this.postNum,
    required this.idx,
    required this.writetime,
    required this.aka,
    required this.likes,
    required this.content,
    required this.isImg,
    required this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postNum: json['postNum'],
      idx: json['idx'],
      writetime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      content: json['content'],
      isImg: json['isImg'],
      comments: (json['comments'] as List<dynamic>)
          .map((item) => Comments.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postNum': postNum,
      'idx': idx,
      'writetime': writetime,
      'aka': aka,
      'likes': likes,
      'content': content,
      'isImg': isImg,
      'comments': comments,
    };
  }
}

class Comments {
  final int idx;
  final String id;
  final String writetime;
  final int nboNum;
  final int commentNum;
  final String aka;
  final int likes;
  final String content;
  final int isImg;
  final int pause;

  Comments({
    required this.idx,
    required this.id,
    required this.writetime,
    required this.nboNum,
    required this.commentNum,
    required this.aka,
    required this.likes,
    required this.content,
    required this.isImg,
    required this.pause,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      idx: json['idx'],
      id: json['id'],
      writetime: json['writetime'],
      nboNum: json['nboNum'],
      commentNum: json['commentNum'],
      aka: json['aka'],
      likes: json['likes'],
      content: json['content'],
      isImg: json['isImg'],
      pause: json['pause'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'id': id,
      'writetime': writetime,
      'nboNum': nboNum,
      'commentNum': commentNum,
      'aka': aka,
      'likes': likes,
      'content': content,
      'isImg': isImg,
      'pause': pause,
    };
  }
}
