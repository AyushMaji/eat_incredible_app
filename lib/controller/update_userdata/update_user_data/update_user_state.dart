part of 'update_user_bloc.dart';

@freezed
class UpdateUserState with _$UpdateUserState {
  const factory UpdateUserState.initial() = _Initial;
  const factory UpdateUserState.loading() = _Loading;
  const factory UpdateUserState.success() = _Success;
  const factory UpdateUserState.failure({ required String message}) = _Failure;
}
