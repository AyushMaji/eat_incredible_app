import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/repo/user_info_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_data_event.dart';
part 'update_user_data_state.dart';
part 'update_user_data_bloc.freezed.dart';

class UpdateUserDataBloc
    extends Bloc<UpdateUserDataEvent, UpdateUserDataState> {
  UpdateUserDataBloc() : super(const _Initial()) {
    on<_UpdateUserData>((event, emit) async {
      emit(const _Loading());
      var result = await UserInfoRepo()
          .updateUerInfo(event.email, event.phone, event.name);
      result.when(
        success: (data) {
          if (data['status'].toString() == '200') {
            emit(_Success(data['status'].toString(), data['msg']));
          } else {
            emit(_Failure(data['msg']));
          }
        },
        failure: (error) {
          emit(_Failure(error.toString()));
        },
      );
    });
  }
}
