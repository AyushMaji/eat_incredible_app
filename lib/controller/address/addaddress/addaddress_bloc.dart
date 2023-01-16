import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/repo/address_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'addaddress_event.dart';
part 'addaddress_state.dart';
part 'addaddress_bloc.freezed.dart';

class AddaddressBloc extends Bloc<AddaddressEvent, AddaddressState> {
  AddaddressBloc() : super(const _Initial()) {
    on<_AddAddress>((event, emit) async {
      emit(const _Loading());
      var result = await AddressRepo().addaddress(
          event.locality,
          event.landmark,
          event.address,
          event.city,
          event.pincode,
          event.location);
      result.when(success: (data) {
        BotToast.showText(text: "Address Added");
        log(data.toString());
        emit(const _Success());
        emit(const _Initial());
      }, failure: (error) {
        emit(_Failure(error: NetworkExceptions.getErrorMessage(error)));
        emit(const _Initial());
      });
    });

    on<_EditAddress>((event, emit) async {
      emit(const _Loading());
      var result = await AddressRepo().updateaddress(
        locality: event.locality,
        landmark: event.landmark,
        address: event.address,
        city: event.city,
        pincode: event.pincode,
        location: event.location,
        addressId: event.addressId,
      );
      result.when(success: (data) {
        BotToast.showText(text: "Address Updated");
        emit(const _Success());
      }, failure: (error) {
        emit(_Failure(error: NetworkExceptions.getErrorMessage(error)));
      });
    });
  }
}
