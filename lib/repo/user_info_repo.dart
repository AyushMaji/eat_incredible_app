import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';

class UserInfoRepo {
  static final Network network = Network();
  Future<ApiResult> getUserInfo() async {
    try {
      var res = await network.getuserInfo();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> updateUerEmail(String email) async {
    try {
      var res = await network.updateUserEmail(email);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> updateUerPhone(String phone) async {
    try {
      var res = await network.updateUserPhone(phone);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
