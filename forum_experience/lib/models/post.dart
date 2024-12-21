class Post {
  final String userId;
  final String username;
  final String message;
  final String timestamp;

  Post({
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  // Convertir l'objet Post en JSON
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'message': message,
        'timestamp': timestamp,
      };

  // Créer un objet Post à partir de JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      username: json['username'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}
