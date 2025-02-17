class Post {
  String postId;
  String userId;
  String title;
  String content;
  String postType;
  DateTime eventDate;
  String location;
  DateTime dateCreated;
  DateTime dateUpdated;
  bool isDeleted;
  List<String> comments;

  Post({
    required this.postId,
    required this.userId,
    required this.title,
    required this.content,
    required this.postType,
    required this.eventDate,
    required this.location,
    required this.dateCreated,
    required this.dateUpdated,
    required this.isDeleted,
    this.comments = const [],
  });
}
