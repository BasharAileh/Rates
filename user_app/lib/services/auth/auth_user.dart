import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final bool isAnonymous;
  final String? email;
  final String id;
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.id,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        isEmailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
      );

  /*  @override
  String toString() {
    return 'AuthUser{isEmailVerified: $isEmailVerified, isAnonymous: $isAnonymous}';
  } */
}
