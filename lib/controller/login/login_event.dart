part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.login(
      {required String phone, required String countryCode}) = _Login;
  const factory LoginEvent.loginWithEmail(
      {required String email, required String password}) = _LoginWithEmail;
}
