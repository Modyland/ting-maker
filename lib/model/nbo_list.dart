class NboList {
  final int idx;
  final String writetime;
  final String aka;
  int likes;
  int commentes;
  final String vilege;
  final String subject;
  final String title;
  final String content;
  final int isImg;

  NboList({
    required this.idx,
    required this.writetime,
    required this.aka,
    required this.likes,
    required this.commentes,
    required this.vilege,
    required this.subject,
    required this.title,
    required this.content,
    required this.isImg,
  });

  factory NboList.fromJson(Map<String, dynamic> json) {
    return NboList(
      idx: json['idx'],
      writetime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      commentes: json['commentes'],
      vilege: json['vilege'],
      subject: json['subject'],
      title: json['title'],
      content: json['content'],
      isImg: json['isImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'writetime': writetime,
      'aka': aka,
      'likes': likes,
      'commentes': commentes,
      'vilege': vilege,
      'subject': subject,
      'title': title,
      'content': content,
      'isImg': isImg,
    };
  }
}
