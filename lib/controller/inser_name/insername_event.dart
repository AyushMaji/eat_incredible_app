part of 'insername_bloc.dart';

@freezed
class InsernameEvent with _$InsernameEvent {
  const factory InsernameEvent.started() = _Started;

  const factory InsernameEvent.insertName(
      {required String name,
      required String value,
      required String loginType}) = _InsertName;
}
