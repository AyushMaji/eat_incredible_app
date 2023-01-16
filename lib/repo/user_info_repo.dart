import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:logger/logger.dart';

class UserInfoRepo {
  static final Network network = Network();

  Future<ApiResult> getUserInfo() async {
    try {
      var res = await network.getuserInfo();
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> updateUerInfo(
      String email, String phone, String name) async {
    try {
      var res = await network.updateUserInfo(email, phone, name);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  //* about apis
  Future<ApiResult> getAbout() async {
    try {
      var res = await network.getAbout();
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
