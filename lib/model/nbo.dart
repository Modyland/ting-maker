class Nbo {
  final int idx;
  final String writetime;
  final String aka;
  final int likes;
  final int commentes;
  final String vilege;
  final String subject;
  final String title;
  final String content;
  final int isImg;

  Nbo({
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

  factory Nbo.fromJson(Map<String, dynamic> json) {
    return Nbo(
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
