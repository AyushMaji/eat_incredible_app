part of 'view_addresslist_bloc.dart';

@freezed
class ViewAddresslistEvent with _$ViewAddresslistEvent {
  const factory ViewAddresslistEvent.started() = _Started;
  const factory ViewAddresslistEvent.getAddressList() = _GetAddressList;
}
