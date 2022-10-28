part of 'user_info_bloc.dart';

@freezed
class UserInfoState with _$UserInfoState {
  const factory UserInfoState.initial() = _Initial;
  const factory UserInfoState.loading() = _Loading;
  const factory UserInfoState.loaded({required UserInfoModel userInfo}) =
      _Loaded;
  const factory UserInfoState.error({required String message}) = _Error;
}
