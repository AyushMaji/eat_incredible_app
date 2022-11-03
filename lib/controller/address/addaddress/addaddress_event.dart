part of 'addaddress_bloc.dart';

@freezed
class AddaddressEvent with _$AddaddressEvent {
  const factory AddaddressEvent.started() = _Started;
  const factory AddaddressEvent.addAddress({
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String landmark,
    required String locality,
    required String location,
  }) = _AddAddress;
}
