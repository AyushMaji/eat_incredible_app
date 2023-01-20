part of 'invoice_bloc.dart';

@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial() = _Initial;
  const factory InvoiceState.loading() = _Loading;
  const factory InvoiceState.loaded({required InvoiceModel invoiceModel}) =
      _Loaded;

  const factory InvoiceState.error({required String message}) = _Error;
}
