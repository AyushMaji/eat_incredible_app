part of 'view_addresslist_bloc.dart';

@freezed
class ViewAddresslistState with _$ViewAddresslistState {
  const factory ViewAddresslistState.initial() = _Initial;
  const factory ViewAddresslistState.loading() = _Loading;
  const factory ViewAddresslistState.loaded(
      {required List<ViewAddressListModel> addressList}) = _Loaded;
  const factory ViewAddresslistState.error({required String message}) = _Error;
}
