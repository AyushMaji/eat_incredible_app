import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/repo/user_info_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';
part 'update_user_bloc.freezed.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UpdateUserBloc() : super(const _Initial()) {
    on<_UpdateUserEmail>((event, emit) async {
      emit(const _Loading());
      var result = await UserInfoRepo().updateUerEmail(event.email);
      result.when(
        success: (data) {
          emit(const _Success());
        },
        failure: (error) {
          emit(_Failure(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });

    on<_UpdateUserPhone>((event, emit) async {
      emit(const _Loading());
      var result = await UserInfoRepo().updateUerPhone(event.phone);
      result.when(
        success: (data) {
          emit(const _Success());
        },
        failure: (error) {
          emit(_Failure(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });
  }
}
