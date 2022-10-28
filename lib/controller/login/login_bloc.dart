import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/login/login_model.dart';
import 'package:eat_incredible_app/repo/login_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      var result = await LoginRepo().login(event.phone, event.countryCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result.when(
        success: (data) {
          if (data['status'].toString() == "1") {
            prefs.setString('isNewUser', data['isNewUser'].toString());
            emit(_Loaded(logindata: LoginModel.fromJson(data)));
          } else {
            emit(_Failure(message: data['message']));
          }
        },
        failure: (error) {
          emit(_Failure(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });

    on<_LoginWithEmail>((event, emit) async {
      emit(const _Loading());
      var result =
          await LoginRepo().loginwithEmail(event.email, event.password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      result.when(
        success: (data) {
          if (data['status'] == 1) {
            prefs.setString('isNewUser', data['isNewUser'].toString());
            emit(_Loaded(logindata: LoginModel.fromJson(data)));
          } else {
            log(data['message'].toString());
            emit(_Failure(message: data['message']));
          }
        },
        failure: (error) {
          emit(_Failure(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });
  }
}
