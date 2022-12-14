import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/login/verify_otp_model.dart';
import 'package:eat_incredible_app/repo/login_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'verify_event.dart';
part 'verify_state.dart';
part 'verify_bloc.freezed.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc() : super(const _Initial()) {
    on<_Verify>((event, emit) async {
      emit(const _Loading());
      var result = await LoginRepo().verify(event.phone, event.otp);
      var prefs = await SharedPreferences.getInstance();
      result.when(
        success: (data) {
          if (data['status'] == 1) {
            emit(_Loaded(verificationdata: VerifyModel.fromJson(data)));
            prefs.setString('token', data['token']);
            prefs.remove('guest_id');
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

    on<_VerifyEmail>((event, emit) async {
      emit(const _Loading());
      var result = await LoginRepo().verifyemail(event.email, event.otp);
      log(result.toString());
      var prefs = await SharedPreferences.getInstance();
      result.when(
        success: (data) {
          if (data['status'] == 1) {
            emit(_Loaded(verificationdata: VerifyModel.fromJson(data)));
            prefs.setString('token', data['token']);
            prefs.remove('guest_id');
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
  }
}
