String getTimeDiff(String stringTime) {
  final now = DateTime.now();
  final time = DateTime.parse(stringTime.replaceAll(' ', 'T'));
  final diff = now.difference(time);

  if (diff.inMinutes < 30) {
    return "방금";
  } else if (diff.inHours < 2) {
    return "1시간 전";
  } else if (diff.inHours < 24) {
    return "${diff.inHours}시간 전";
  } else if (diff.inDays < 2) {
    return "하루 전";
  } else if (diff.inDays < 7) {
    return "${diff.inDays}일 전";
  } else if (diff.inDays < 14) {
    return "일주일 전";
  } else if (diff.inDays < 30) {
    return "이주 전";
  } else if (diff.inDays < 60) {
    return "한달 전";
  } else if (diff.inDays < 365) {
    return "${(diff.inDays / 30).floor()}개월 전";
  } else {
    return "${(diff.inDays / 365).floor()}년 전";
  }
}
