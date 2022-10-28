part of 'up_verrify_data_bloc.dart';

@freezed
class UpVerrifyDataState with _$UpVerrifyDataState {
  const factory UpVerrifyDataState.initial() = _Initial;
  const factory UpVerrifyDataState.loading() = _Loading;
  const factory UpVerrifyDataState.success() = _Success;
  const factory UpVerrifyDataState.failure({required String message}) =
      _Failure;
}
