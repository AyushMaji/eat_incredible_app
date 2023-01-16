import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/about/abou_model.dart';
import 'package:eat_incredible_app/repo/user_info_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_event.dart';
part 'about_state.dart';
part 'about_bloc.freezed.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(const _Initial()) {
    on<_AboutUs>((event, emit) async {
      emit(const _Loading());
      var result = await UserInfoRepo().getAbout();
      result.when(success: (value) {
        emit(_Loaded(AboutModel.fromJson(value)));
      }, failure: (error) {
        emit(_Error(NetworkExceptions.getErrorMessage(error)));
      });
    });
  }
}
