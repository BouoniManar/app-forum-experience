class Comment {
  String commentId;
  String userId;
  String username;
  String message;
  String timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'username': username,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static Comment fromJson(String commentId, Map<String, dynamic> json) {
    return Comment(
      commentId: commentId,
      userId: json['userId'],
      username: json['username'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}
