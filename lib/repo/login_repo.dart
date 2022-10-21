import 'dart:developer';

import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/barrel.dart';

class LoginRepo {
  static final Network network = Network();
  Future<ApiResult> login(String phone, String countryCode) async {
    try {
      var res = await network.postlogin(phone, countryCode);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> loginwithEmail(String email, String password) async {
    try {
      var res = await network.postloginwithEmail(email, password);

      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> verify(String phone, String otp) async {
    try {
      var res = await network.verifyOtp(phone, otp);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> verifyemail(String email, String otp) async {
    try {
      var res = await network.verifyemailOtp(email, otp);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> logout(String phone) async {
    try {
      var res = await network.logout(phone);
      log(res.data.toString());
      if (res.data['status'] == 1) {
        var prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => const SignupPage());
        prefs.get('token');
        log(prefs.get('token').toString());
      }
      return ApiResult.success(data: res.data);
    } catch (e) {
      log(NetworkExceptions.getDioException(e).toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
