part of 'insername_bloc.dart';

@freezed
class InsernameState with _$InsernameState {
  const factory InsernameState.initial() = _Initial;
  const factory InsernameState.loading() = _Loading;
  const factory InsernameState.loaded() = _Loaded;
  const factory InsernameState.error({required String message}) = _Error;
}
