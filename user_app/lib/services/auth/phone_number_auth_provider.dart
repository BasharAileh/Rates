import 'package:firebase_auth/firebase_auth.dart' as ph;
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  String? verificationId;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) onVerificationCompleted,
    Function(FirebaseAuthException) onVerificationFailed,
    Function(String, int?) onCodeSent,
    Function(String) onCodeAutoRetrievalTimeout,
  ) async {
    await ph.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        onCodeSent(verId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        onCodeAutoRetrievalTimeout(verId);
      },
    );
  }

  Future<User?> signInWithOTP(String smsCode) async {
    if (verificationId == null) {
      throw Exception(
          "Verification ID is null. Start phone verification first.");
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await ph.FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }
}
