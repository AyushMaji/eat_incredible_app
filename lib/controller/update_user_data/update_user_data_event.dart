part of 'update_user_data_bloc.dart';

@freezed
class UpdateUserDataEvent with _$UpdateUserDataEvent {
  const factory UpdateUserDataEvent.started() = _Started;
  const factory UpdateUserDataEvent.updateUserData(
      String name, String email, String phone) = _UpdateUserData;
}
