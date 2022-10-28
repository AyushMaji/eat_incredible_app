part of 'update_user_bloc.dart';

@freezed
class UpdateUserEvent with _$UpdateUserEvent {
  const factory UpdateUserEvent.started() = _Started;
  const factory UpdateUserEvent.updateUserEmail(String email) =
      _UpdateUserEmail;
  const factory UpdateUserEvent.updateUserPhone(String phone) =
      _UpdateUserPhone;
}
