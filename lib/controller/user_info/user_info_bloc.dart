import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/user_info/user_info_model.dart';
import 'package:eat_incredible_app/repo/user_info_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';
part 'user_info_bloc.freezed.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(const _Initial()) {
    on<_GetUserInfo>((event, emit) async {
      emit(const _Loading());
      var result = await UserInfoRepo().getUserInfo();

      result.when(
        success: (data) {
          emit(_Loaded(userInfo: UserInfoModel.fromJson(data)));
        },
        failure: (error) {
          emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });
  }
}
