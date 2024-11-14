import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final bool isAnonymous;
  final String? id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.isEmailVerified,
    required this.isAnonymous,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        isEmailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
      );

  /*  @override
  String toString() {
    return 'AuthUser{isEmailVerified: $isEmailVerified, isAnonymous: $isAnonymous}';
  } */
}
