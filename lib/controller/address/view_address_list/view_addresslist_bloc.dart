import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/view_address_list/view_addresslist_model.dart';
import 'package:eat_incredible_app/repo/address_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_addresslist_event.dart';
part 'view_addresslist_state.dart';
part 'view_addresslist_bloc.freezed.dart';

class ViewAddresslistBloc
    extends Bloc<ViewAddresslistEvent, ViewAddresslistState> {
  ViewAddresslistBloc() : super(const _Initial()) {
    on<_GetAddressList>((event, emit) async {
      emit(const _Loading());
      List<ViewAddressListModel> addressList = [];
      var result = await AddressRepo().getaddress();
      result.when(
        success: (data) {
          for (var i = 0; i < data.length; i++) {
            addressList.add(ViewAddressListModel.fromJson(data[i]));
          }
          emit(_Loaded(addressList: addressList)); 
        },
        failure: (error) {
          emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
        },
      );
    });
  }
}
