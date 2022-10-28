import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'up_verrify_data_event.dart';
part 'up_verrify_data_state.dart';
part 'up_verrify_data_bloc.freezed.dart';

class UpVerrifyDataBloc extends Bloc<UpVerrifyDataEvent, UpVerrifyDataState> {
  UpVerrifyDataBloc() : super(const _Initial()) {
    on<_VerifyUserEmail>((event, emit) {});
    on<_VerifyUserPhone>((event, emit) {});
  }
}
