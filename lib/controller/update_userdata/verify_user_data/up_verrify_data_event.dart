part of 'up_verrify_data_bloc.dart';

@freezed
class UpVerrifyDataEvent with _$UpVerrifyDataEvent {
  const factory UpVerrifyDataEvent.started() = _Started;
  const factory UpVerrifyDataEvent.verifyUserEmail(String email) =
      _VerifyUserEmail;
  const factory UpVerrifyDataEvent.verifyUserPhone(String phone) =
      _VerifyUserPhone;
}