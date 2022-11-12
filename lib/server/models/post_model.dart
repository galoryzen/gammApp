import 'user_model.dart';

/// This class represents the structure of a Post object.
class PostModel {
  /// This is the constructor of the PostModel class.
  PostModel(
      {this.id,
      required this.user,
      required this.picture,
      required this.caption,
      required this.postedTimeStamp,
      required this.likes,
      required this.comments,
      required this.shares});

  /// Post's uuid.
  final int? id;

  /// User that created the post.
  final UserModel user;

  /// Picture shown in the post (can be empty).
  final String picture;

  /// Caption of the post.
  String caption;

  /// Time at which the post was created.
  DateTime postedTimeStamp;

  /// List of users that liked the post.
  List<String> likes;

  /// List of comments of the post.
  List<Map<String, dynamic>> comments;

  /// List of users that shared the post.
  List<String> shares;

  /// This method is used to convert a [PostModel] object to a [Map] object containing its attributes.
  Map<String, dynamic> toMap() {
    return {
      'uiid': id,
      'uuidUser': user.id,
      'picture': picture,
      'caption': caption,
      'postedTimeStamp': postedTimeStamp,
      'likes': likes,
      'comments': comments,
      'shares': shares
    };
  }
}
