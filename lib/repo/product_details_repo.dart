import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:logger/logger.dart';

class ProductDetailsRepo {
  static final Network network = Network();
  Future<ApiResult> getProductDetailsData(String id , String vid) async {
    try {
      var res = await network.getProductDetails(id, vid);
      Logger().e(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // weight api ==>

  Future<ApiResult> getWeightData(String pid) async {
    try {
      var res = await network.weightList(pid);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
