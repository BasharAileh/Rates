import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String? email;
  final String id;
  bool isEmailVerified;
  bool isAnonymous;
  String? profileImageUrl;
  String userName;

  AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.id,
    required this.userName,
    this.profileImageUrl,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        isEmailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        profileImageUrl: user.photoURL,
        userName: user.displayName ?? user.email!.split('@').first,
      );

  factory AuthUser.fromGoogle(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        isEmailVerified: true,
        isAnonymous: false,
        profileImageUrl: user.photoURL,
        userName: user.displayName ?? user.email!.split('@').first,
      );

  factory AuthUser.fromAnonymous(User user) => AuthUser(
        id: user.uid,
        email: '',
        isEmailVerified: false,
        isAnonymous: true,
        profileImageUrl: '',
        userName: 'Anonymous',
      );

  get emailVerified => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'is_email_verified': isEmailVerified,
      'is_anonymous': isAnonymous,
      'profile_imageUrl': profileImageUrl,
      'user_name': userName,
    };
  }

  static AuthUser fromMap(Map<String, dynamic> data) {
    return AuthUser(
      id: data['id'],
      email: data['email'],
      isEmailVerified: data['is_email_verified'],
      isAnonymous: data['is_anonymous'],
      profileImageUrl:
          data['profile_imageUrl'] == '' ? null : data['profile_imageUrl'],
      userName: data['user_name'],
    );
  }

  @override
  String toString() {
    return 'AuthUser{id: $id, email: $email, isEmailVerified: $isEmailVerified, isAnonymous: $isAnonymous, profileImageUrl: $profileImageUrl, userName: $userName, }';
  }
}
