import 'package:eat_incredible_app/api/api_result.dart';
import 'package:eat_incredible_app/api/network.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:logger/logger.dart';

class SearchRepo {
  static final Network network = Network();
  Future<ApiResult> searchProduct(String search) async {
    try {
      var res = await network.searchProduct(search);
      Logger().e(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> searchKey(String search) async {
    try {
      var res = await network.searchKey(search);
      Logger().i(res.data);
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult> treadingSearch() async {
    try {
      var res = await network.trendingSearch();
      return ApiResult.success(data: res.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
