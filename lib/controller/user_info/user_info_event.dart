part of 'user_info_bloc.dart';

@freezed
class UserInfoEvent with _$UserInfoEvent {
  const factory UserInfoEvent.started() = _Started;
  const factory UserInfoEvent.getUserInfo() = _GetUserInfo;
}