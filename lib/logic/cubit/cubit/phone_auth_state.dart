part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class LoadingState extends PhoneAuthState {}

class ErrorState extends PhoneAuthState {
  final String? error;
  ErrorState({required this.error});
}

class PhoneNumberSubmittedState extends PhoneAuthState {}

class OTPVerifiedState extends PhoneAuthState {}
