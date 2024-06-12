class Comment {
  final int idx;
  final String writetime;
  final String id;
  final int postNum;
  final String aka;
  final int likes;
  final String content;

  Comment({
    required this.id,
    required this.postNum,
    required this.idx,
    required this.writetime,
    required this.aka,
    required this.likes,
    required this.content,
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
    };
  }
}
