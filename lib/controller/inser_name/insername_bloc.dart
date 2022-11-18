import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/repo/login_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insername_event.dart';
part 'insername_state.dart';
part 'insername_bloc.freezed.dart';

class InsernameBloc extends Bloc<InsernameEvent, InsernameState> {
  InsernameBloc() : super(const _Initial()) {
    on<_InsertName>((event, emit) async {
      emit(const _Loading());
      var result = await LoginRepo()
          .insertName(event.name, event.value, event.loginType);
      result.when(
        success: (data) {
          emit(const _Loaded());
        },
        failure: (error) {
          emit(_Error(message: error.toString()));
          emit(const _Initial());
        },
      );
    });
  }
}
