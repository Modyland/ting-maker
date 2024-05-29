class Nbo {
  final int idx;
  final String writetime;
  final String aka;
  final int likes;
  final String vilege;
  final String subject;
  final String title;
  final String content;

  Nbo({
    required this.idx,
    required this.writetime,
    required this.aka,
    required this.likes,
    required this.vilege,
    required this.subject,
    required this.title,
    required this.content,
  });

  factory Nbo.fromJson(Map<String, dynamic> json) {
    return Nbo(
      idx: json['idx'],
      writetime: json['writetime'],
      aka: json['aka'],
      likes: json['likes'],
      vilege: json['vilege'],
      subject: json['subject'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'writetime': writetime,
      'aka': aka,
      'likes': likes,
      'vilege': vilege,
      'subject': subject,
      'title': title,
      'content': content,
    };
  }
}
