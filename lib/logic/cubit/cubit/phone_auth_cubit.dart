// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState?> {
  PhoneAuthCubit() : super(null);

  late String? verificationId;

  Future<void> submitPhoneNumber({String? phoneNumber}) async {
    emit(LoadingState());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        print("TimeOut");
      },
    );
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    print("Success");
    await _signIn(credential);
  }

  void _verificationFailed(FirebaseAuthException exception) {
    emit(ErrorState(error: exception.toString()));
  }

  void _codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneNumberSubmittedState());
  }

  Future<void> submitOtpCode(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpCode);

    await _signIn(credential);
  }

  Future<void> _signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(OTPVerifiedState());
    } catch (e) {
      emit(ErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User loggedUser() {
    return FirebaseAuth.instance.currentUser!;
  }
}
