import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/model/invoice/invoice.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';
part 'invoice_bloc.freezed.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(const _Initial()) {
    on<_GetInvoice>((event, emit) async {
      emit(const _Loading());
      var result = await CartRepo().invoice();
      result.when(success: (value) {
        emit(_Loaded(invoiceModel: InvoiceModel.fromJson(value)));
      }, failure: (error) {
        emit(_Error(message: error.toString()));
      });
    });
  }
}
