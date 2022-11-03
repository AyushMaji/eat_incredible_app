part of 'addaddress_bloc.dart';

@freezed
class AddaddressState with _$AddaddressState {
  const factory AddaddressState.initial() = _Initial;
  const factory AddaddressState.loading() = _Loading;
  const factory AddaddressState.success() = _Success;
  const factory AddaddressState.failure({required String error}) = _Failure;
}
