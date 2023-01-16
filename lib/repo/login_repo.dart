import 'dart:developer';

import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/views/signup_page/signup_page_phone.dart';
import 'package:logger/logger.dart';
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
      Logger().i(res.data.toString());
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> verifyemail(String email, String otp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String guestId = prefs.getString('guest_id') ?? '';
    try {
      var res = await network.verifyemailOtp(email, otp, guestId);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> logout() async {
    try {
      var res = await network.logout();
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

  Future<ApiResult> insertName(
      String name, String value, String loginType) async {
    try {
      var res = await network.insertName(name, value, loginType);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      Logger().e(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
