part of 'invoice_bloc.dart';

@freezed
class InvoiceEvent with _$InvoiceEvent {
  const factory InvoiceEvent.started() = _Started;
  const factory InvoiceEvent.getInvoice() = _GetInvoice;
}